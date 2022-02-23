#!/bin/bash
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Locally updates docker-library/official-images with new Amazon Linux
# container images.
#
# For details about why this is the way it is, see the README.md at the root of
# this repository.
#
# Before running this, you've generated some new container image tarballs.
# After running this, you need to git push (--force) the container image
# branches, then push the official-images.git change to a fork of
# docker-library/official-images and open a pull request.
#
# Requirements:
# - This is being run on the latest Amazon Linux (to ensure the RPM DB is
#   readable).
# - AWS credentials to put files in the amazon-linux-docker-sources S3 bucket
#   are configured.
# - Git's user.name and user.email variables are configured. (If you want
#   commit signing, configure commit.gpgsign.)
# - Not all images need to be updated, but if you're updating a multi-arch
#   image, all architectures are updated at once.
#
# Blame: iliana destroyer of worlds <iweller@amazon.com>

set -euo pipefail

TERM_CLEAR=$(tput sgr0 2>/dev/null || :)
TERM_RED=$(tput setaf 1 2>/dev/null || :)
echo_red() {
    >&2 echo "$TERM_RED$*$TERM_CLEAR"
}
TERM_GREEN=$(tput setaf 2 2>/dev/null || :)
echo_green() {
    >&2 echo "$TERM_GREEN$*$TERM_CLEAR"
}

# set this after tput to prevent obnoxious output
set -x

# Build the branch name based on the image version and architecture.
# e.g. version "2", architecture "aarch64", branch name "amzn2-arm64"
build_branch_name() {
    version="${1:?}"
    arch="${2:?}"

    case "$version" in
        20??)
            printf al%s "$version"
            ;;
        201?.??)
            printf %s "$version"
            ;;
        *)
            printf amzn%s "$version"
            ;;
    esac

    case "$arch" in
        x86_64)
            printf "\n"
            ;;
        aarch64)
            printf -- "-arm64\n"
            ;;
        *)
            echo_red "unknown arch: $arch"
            exit 1
            ;;
    esac
}

OUTDIR=
while getopts "o:" OPTION; do
    case $OPTION in
        o)
            OUTDIR="$(readlink -m "$OPTARG")"
            if [[ -e $OUTDIR ]]; then
                echo_red "OUTDIR \"$OUTDIR\" already exists"
                exit 1
            fi
            mkdir -p "$OUTDIR"
            ;;
        *)
            echo_red "unexpected flag: $OPTION"
            >&2 echo "usage: $0 [-o OUTDIR] IMAGES..."
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

if [[ $# -eq 0 ]]; then
    echo_red "no images specified"
    >&2 echo "usage: $0 [-o OUTDIR] IMAGES..."
    exit 1
fi

hash awk aws curl docker file git git-lfs rpm sha256sum tar
docker info # check that it's awake, and get the output for logs

ORIGINAL_CWD=$PWD
WORKDIR=$(mktemp -dp "" official-images-workdir.XXXXXXXXXX)
cleanup() {
    cd "$ORIGINAL_CWD"
    rm -rf "$WORKDIR"
}
trap cleanup EXIT

mkdir "$WORKDIR/empty"
if [[ -z $OUTDIR ]]; then
    OUTDIR=$(mktemp -dp "$PWD" official-images-output.XXXXXXXXXX)
fi
echo_green "Output will be in $OUTDIR"

(
    cd "$OUTDIR"
    git clone --single-branch https://github.com/amazonlinux/container-images.git images
    cd images
    git lfs install --local
)

declare -A FULL_VERSIONS COMMIT_FOR_BRANCH

for arg in "$@"; do
    path=$(readlink -f "$arg")
    filename=$(basename "$path")
    image_workdir="$(mktemp -dp "$WORKDIR")"

    # Get full image version string
    # "This is a little fragile" is the understatement of the year
    # Example argument: "some-directory/amzn2-container-raw-2.0.20190207-arm64.tar.xz"
    # Expected awk output: "2.0.20190207"
    full_version=$(awk -F- '{ print $4 }' <<<"$filename")
    [[ -z $full_version ]] && { echo_red "image version is empty string"; exit 1; }

    # Extract the RPM DB from the tarball
    tar -xC "$image_workdir" -f "$path" ./var/lib/rpm \
        || tar -xC "$image_workdir" -f "$path" var/lib/rpm \
        || { echo_red "no rpmdb found in image"; exit 1; }
    # Rebuild it, in case it's for a different architecture
    rpm --root "$image_workdir" --rebuilddb

    # Get system-release version
    [[ $(rpm --root "$image_workdir" -q system-release --qf '%{version}') =~ (^2018.03$|^2$|^20[0-9]{2}) ]] && version="${BASH_REMATCH[1]}" || exit 1
    # Get architecture of image
    arch=$(rpm --root "$image_workdir" -q glibc --qf '%{arch}')
    branch_name=$(build_branch_name "$version" "$arch")

    FULL_VERSIONS[$version]=$full_version

    # Build the source RPM bundle
    # Get the list of source RPMs to fetch:
    rpm --root "$image_workdir" -qa --qf '%{SOURCERPM}\n' | grep -v '^(none)$' | sed -e 's/\.rpm$//' | sort -u >"$image_workdir/srpm_list"
    # Make a hash of the list. The S3 URL of the bundle includes this hash so we don't have to regenerate it.
    srpm_list_sha256=$(sha256sum "$image_workdir/srpm_list" | awk '{ print $1 }')
    if [[ ! -e "$WORKDIR/srpm-bundle-${srpm_list_sha256}.tar.gz" ]]; then
        if curl -Isf "https://amazon-linux-docker-sources.s3.amazonaws.com/srpm-bundle-${srpm_list_sha256}.tar.gz"; then
            curl "https://amazon-linux-docker-sources.s3.amazonaws.com/srpm-bundle-${srpm_list_sha256}.tar.gz" >"$WORKDIR/srpm-bundle-${srpm_list_sha256}.tar.gz"
        else
            # Build an "srpm-fetcher" Docker image that reads source RPM names on stdin and generates a tarball on stdout.
            # To make a deterministic tarball, we need to ensure consistent ordering of files within and ensure no timestamps.
            docker build -t "srpm-fetcher:$version" -f - "$WORKDIR/empty" <<EOF
FROM amazonlinux:$version
RUN yum -y install findutils yum-utils tar gzip
WORKDIR /srpms
CMD set -euxo pipefail; \\
    xargs yumdownloader --source 1>&2; \\
    touch -r \`ls -tp | head -n 1\` .; \\
    cd ..; \\
    find srpms -print0 | LC_ALL=C sort -z | \\
    tar --owner=0 --group=0 --numeric-owner --no-recursion --null -T - -c | gzip -n
EOF
            docker run --rm -i "srpm-fetcher:$version" <"$image_workdir/srpm_list" >"$WORKDIR/srpm-bundle-${srpm_list_sha256}.tar.gz"
            # Upload it to S3 so we don't need to fetch it again.
            aws s3 cp "$WORKDIR/srpm-bundle-${srpm_list_sha256}.tar.gz" "s3://amazon-linux-docker-sources/srpm-bundle-${srpm_list_sha256}.tar.gz"
        fi
    fi
    if [[ -e "$WORKDIR/srpm-bundle-${srpm_list_sha256}.tar.gz.sha256" ]]; then
        srpm_bundle_sha256="$(cat <"$WORKDIR/srpm-bundle-${srpm_list_sha256}.tar.gz.sha256")"
    else
        srpm_bundle_sha256="$(sha256sum "$WORKDIR/srpm-bundle-${srpm_list_sha256}.tar.gz" | awk '{ print $1 }')"
        echo "$srpm_bundle_sha256" >"$WORKDIR/srpm-bundle-${srpm_list_sha256}.tar.gz.sha256"
    fi

    pushd "$OUTDIR/images" >/dev/null

    # Normal branch
    git checkout -B "$branch_name"
    cp "$path" ./
    cat >Dockerfile <<EOF
FROM scratch
ADD $filename /
CMD ["/bin/bash"]
EOF
    git add Dockerfile "$filename"
    git commit -m "Add $full_version $arch image"

    # with-sources branch
    git checkout -B "$branch_name-with-sources"
    echo "srpm-bundle.tar.gz filter=lfs diff=lfs merge=lfs -text" >.gitattributes
    cp "$WORKDIR/srpm-bundle-${srpm_list_sha256}.tar.gz" srpm-bundle.tar.gz
    cat >>Dockerfile <<EOF
RUN mkdir /usr/src/srpm \\
 && curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/srpm-bundle-${srpm_list_sha256}.tar.gz" \\
 && echo "$srpm_bundle_sha256  /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -
EOF
    git add .gitattributes srpm-bundle.tar.gz Dockerfile
    git commit -m "Add $full_version $arch image with sources"

    # finish up this arg
    git checkout master
    popd >/dev/null
    echo_green "Done processing $arg"
done

### Done making branches in $OUTDIR/images
### Now modify docker-library/official-images

cd "$OUTDIR"
git clone https://github.com/docker-library/official-images.git
cd official-images

# If we didn't process a version locally, get the current date-stamped image tag
for version in 2 2018.03 2022; do
    [[ -z ${FULL_VERSIONS[$version]:-} ]] && FULL_VERSIONS[$version]=$(awk -v v=$version, '$3 == v {print $2}' library/amazonlinux | tr -d ,)
done

# Get commit hashes for all the branches
for branch in master {amzn2,amzn2-arm64,2018.03,al2022,al2022-arm64}{,-with-sources}; do
    # First try to get the local commit; if it's not local, we're not pushing
    # it, so get the remote commit for this branch.
    COMMIT_FOR_BRANCH[$branch]=$(
        set -euo pipefail
        cd "$OUTDIR/images"
        git rev-parse --verify "$branch" 2>/dev/null || git ls-remote origin "$branch" | awk '{ print $1 }'
    )
done

# Write out the library file
cat >library/amazonlinux <<EOF
Maintainers: Amazon Linux <amazon-linux@amazon.com> (@amazonlinux),
             Frédérick Lefebvre (@fred-lefebvre),
             Samuel Karp (@samuelkarp),
             Stewart Smith (@stewartsmith),
             Christopher Miller (@mysteriouspants),
             Sumit Tomer (@sktomer),
             Sean Kelly (@cbgbt),
             Tanu Rampal (@trampal),
             Kyle Gosselin-Harris (@kgharris),
             Sam Thornton (@boostyc),
             Preston Carpenter (@timidger),
             Richard Kelly (@rpkelly)
             Joseph Howell-Burke (@jhowell-burke)
GitRepo: https://github.com/amazonlinux/container-images.git
GitCommit: ${COMMIT_FOR_BRANCH[master]}

Tags: ${FULL_VERSIONS[2]}, 2, latest
Architectures: amd64, arm64v8
amd64-GitFetch: refs/heads/amzn2
amd64-GitCommit: ${COMMIT_FOR_BRANCH[amzn2]}
arm64v8-GitFetch: refs/heads/amzn2-arm64
arm64v8-GitCommit: ${COMMIT_FOR_BRANCH[amzn2-arm64]}

Tags: ${FULL_VERSIONS[2]}-with-sources, 2-with-sources, with-sources
Architectures: amd64, arm64v8
amd64-GitFetch: refs/heads/amzn2-with-sources
amd64-GitCommit: ${COMMIT_FOR_BRANCH[amzn2-with-sources]}
arm64v8-GitFetch: refs/heads/amzn2-arm64-with-sources
arm64v8-GitCommit: ${COMMIT_FOR_BRANCH[amzn2-arm64-with-sources]}

Tags: ${FULL_VERSIONS[2018.03]}, 2018.03, 1
Architectures: amd64
amd64-GitFetch: refs/heads/2018.03
amd64-GitCommit: ${COMMIT_FOR_BRANCH[2018.03]}

Tags: ${FULL_VERSIONS[2018.03]}-with-sources, 2018.03-with-sources, 1-with-sources
Architectures: amd64
amd64-GitFetch: refs/heads/2018.03-with-sources
amd64-GitCommit: ${COMMIT_FOR_BRANCH[2018.03-with-sources]}

Tags: ${FULL_VERSIONS[2022]}, 2022
Architectures: amd64, arm64v8
amd64-GitFetch: refs/heads/al2022
amd64-GitCommit: ${COMMIT_FOR_BRANCH[al2022]}
arm64v8-GitFetch: refs/heads/al2022-arm64
arm64v8-GitCommit: ${COMMIT_FOR_BRANCH[al2022-arm64]}

Tags: ${FULL_VERSIONS[2022]}-with-sources, 2022-with-sources
Architectures: amd64, arm64v8
amd64-GitFetch: refs/heads/al2022-with-sources
amd64-GitCommit: ${COMMIT_FOR_BRANCH[al2022-with-sources]}
arm64v8-GitFetch: refs/heads/al2022-arm64-with-sources
arm64v8-GitCommit: ${COMMIT_FOR_BRANCH[al2022-arm64-with-sources]}
EOF
git commit -m "Update Amazon Linux images" library/amazonlinux
git --no-pager show

echo_green "Finished repositories in $OUTDIR"

# Stage 1: Fetch an Alpine container so that we may download the appropriate
#          version of Amazon Linux
FROM alpine:3.19 AS extract

# The variables set here will determine what is downloaded.
ARG target_arch="arm64"

ARG amzn_linux_release="al2023"
ARG amzn_linux_version="2023.3.20231218.0"
ARG amzn_linux_file="${amzn_linux_release}-container-${amzn_linux_version}-${target_arch}.tar.xz"
ARG amzn_linux_url="https://amazon-linux-docker-sources.s3.amazonaws.com/${amzn_linux_release}/${amzn_linux_version}/${amzn_linux_file}"

COPY version.sha256 /

# Download the packages required to extract the files from the container source
# archive.
RUN apk add --no-cache curl tar xz

# The below does the following:
#   * Downloads the compressed container archive, and the appropriate sha256sum
#     file from the docker sources repository.
#   * Verifies the container archive SHA256 checksum.
#   * Extracts the content of the archive into /rootfs.
RUN                                                   \
  curl                                                \
    --fail                                            \
    --location                                        \
    --remote-name                                     \
    --url "${amzn_linux_url}"                         \
&& curl                                               \
     --fail                                           \
     --location                                       \
     --remote-name                                    \
     --url "${amzn_linux_url}.sha256"                 \
\
&& cat ${amzn_linux_file}.sha256                      \
&& sha256sum -c ${amzn_linux_file}.sha256             \
\
&& echo "$(cat version.sha256) ${amzn_linux_file}"    \
                  > ${amzn_linux_file}.version.sha256 \
&& cat ${amzn_linux_file}.version.sha256              \
&& sha256sum -c ${amzn_linux_file}.version.sha256     \
\
&& mkdir /rootfs                                      \
&& tar -C /rootfs --extract --file ${amzn_linux_file}

RUN echo target_arch="\"${target_arch}\""                | tee version.info    \
&& echo amzn_linux_release="\"${amzn_linux_release}\""   | tee -a version.info \
&& echo amzn_linux_version="\"${amzn_linux_version}\""   | tee -a version.info \
&& echo amzn_linux_file="\"${amzn_linux_file}\""         | tee -a version.info \
&& echo amzn_linux_url="\"${amzn_linux_url}\""           | tee -a version.info \
&& echo amzn_linux_url_sha256="\"$(cat version.sha256)\"" | tee -a version.info


# Stage 2: Extract the content of the archive into the root filesystem of a
#          new container.
FROM scratch AS root

COPY --from=extract /version.* /
COPY --from=extract /rootfs/ /

CMD ["/bin/bash"]

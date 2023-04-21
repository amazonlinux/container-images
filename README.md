# Amazon Linux container images

This repository contains the base container images for Amazon Linux on
[Docker Hub][dockerhub] and [Amazon Elastic Container Registry][ecr].

This is more of an *artifact store* than a Git repository, for reasons
explained later. Please note that **branches other than `master` are
regularly force-pushed, and content may disappear without warning**. For
more reliable sources of Amazon Linux container images, use the
[Amazon Linux on-premises image download site][onprem], Docker Hub, or
Amazon ECR.

## What we're doing here

The [Docker Official Images program][doi] produces the top-level images
available on Docker Hub, including the base OS images that serve as a
starting point for most Docker users.

The images are maintained in the open. Image generation starts from a
file in [docker-library/official-images.git][doi-git] named
[library/amazonlinux][doi-git-al]. This file is machine-readable and
connects image tags to a Git repository and commit.

During image build, the build system clones the referenced Git
repository at a given commit and runs `docker build` in that directory.
For application images, this usually involves downloading and installing
software. For base OS images, this means adding the contents of a
tarball as a single layer.

## Distribution SLAs

Amazon Linux is able to update our first-party sources (ECR) same-day as
the associated AMI release. To reduce the operational load on the Docker
Official Images program, we batch our OS releases and submit them
weekly.

[dockerhub]: https://hub.docker.com/_/amazonlinux/
[ecr]: https://docs.aws.amazon.com/AmazonECR/latest/userguide/amazon_linux_container_image.html
[onprem]: https://cdn.amazonlinux.com/os-images/latest/
[doi]: https://docs.docker.com/docker-hub/official_images/
[doi-git]: https://github.com/docker-library/official-images
[doi-git-al]: https://github.com/docker-library/official-images/blob/master/library/amazonlinux

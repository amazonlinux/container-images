# Amazon Linux container images

This repository contains the base container images for Amazon Linux on [Docker Hub](https://hub.docker.com/_/amazonlinux/) and [Amazon Elastic Container Registry](https://docs.aws.amazon.com/AmazonECR/latest/userguide/amazon_linux_container_image.html).

This is more of an *artifact store* than a Git repository, for reasons explained later. Please note that **branches other than `master` are regularly force-pushed, and content may disappear without warning**. For more reliable sources of Amazon Linux container images, use the [Amazon Linux on-premises image download site](https://cdn.amazonlinux.com/os-images/latest/), Docker Hub, and Amazon ECR.

## What we're doing here

The [Docker Official Images program](https://docs.docker.com/docker-hub/official_images/) produces the top-level images available on Docker Hub, including the base OS images that serve as a starting point for most Docker users.

The images are maintained in the open. Image generation starts from a file in [docker-library/official-images.git](https://github.com/docker-library/official-images) named [library/amazonlinux](https://github.com/docker-library/official-images/blob/master/library/amazonlinux). This file is machine-readable and connects image tags to a Git repository and commit.

During image build, the build system clones the referenced Git repository at a given commit and runs `docker build` in that directory. For application images, this usually involves downloading and installing software. For base OS images, this means adding the contents of a tarball as a single layer:

```
FROM scratch
ADD amzn2-container-raw-2.0.yyyymmdd-x86_64.tar.xz /
CMD ["/bin/bash"]
```

Committed alongside the Dockerfile is the tarball, which balloons the repository size. Thus, we force-push branches that contain the tarballs.

Although we force-push the files away, the older versions of our images remain present on Docker Hub and Amazon ECR.

We use [a script to generate the other branches of this repository](update-script/update.sh).

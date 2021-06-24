FROM scratch
ADD amzn2-container-raw-2.0.20210617.0-x86_64.tar.xz /
CMD ["/bin/bash"]
RUN mkdir /usr/src/srpm \
 && curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/srpm-bundle-802f7b2589030657b0b80f3e6055fdd0a78fb8c62cd9535d8ffe15cb8b199160.tar.gz" \
 && echo "397633fadc78e78bba3fce8c756b34cbc069ff0547c587f8084d562df42492ea  /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -

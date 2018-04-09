FROM scratch
ADD amzn-container-minimal-2017.09.1.20180409-x86_64.tar.xz /
CMD ["/bin/bash"]
RUN mkdir /usr/src/srpm \
 && curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/srpm-bundle.tar.gz?versionId=yLR2HAwYv1zX8_5cmj9QoFHz8cCgSCpE" \
 && echo "311fa0fe6cc982b86636f9966f968432357d9d6074b1991c39d0f84d5219b49b /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -

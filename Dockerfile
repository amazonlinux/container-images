FROM scratch
ADD al2022-container-2022.0.20230118.3-arm64.tar.xz /
CMD ["/bin/bash"]
RUN mkdir /usr/src/srpm \
    && curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/srpm-bundle-1b0dd271d54be9dbb3fcfa0b37f2c0ec0cee4279b55d596ff37915e26ad6a533.tar.gz" \
    && echo "6a05192a5bdf55ee6b82715c027521a534bef1cc3b45b3b9b07fda0700fb583f  /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -

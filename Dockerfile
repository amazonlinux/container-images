FROM scratch
ADD amzn-container-minimal-2018.03.0.20230207.0-x86_64.tar.xz /
CMD ["/bin/bash"]
RUN mkdir /usr/src/srpm \
    && curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/srpm-bundle-2f3f7e5ea9b509a345d00531d4b8504f7720dde9cae889e01f4d4e8dbc71db34.tar.gz" \
    && echo "717d08c398cc28d075ab0ebe75c3785a5277a51c6ab89f5a959b7f1c7d2b98fa  /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -

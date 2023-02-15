FROM scratch
ADD amzn2-container-raw-2.0.20230207.0-x86_64.tar.xz /
CMD ["/bin/bash"]
RUN mkdir /usr/src/srpm \
    && curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/srpm-bundle-7e289542d782642b256d8350ebcc22b568c00303c6cedda53c0cc26f5de6cca4.tar.gz" \
    && echo "28173c8559de7e4838d9ae0e1c163243d6d1274f28d242ced6e7fa44272b36bb  /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -

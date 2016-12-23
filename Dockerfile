FROM scratch
ADD amzn-container-minimal-2016.09.1.20161221-x86_64.tar.xz /
CMD ["/bin/bash"]
RUN curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/srpm-bundle.tar.gz?versionId=IGTZ.Uzl4n4Vmg1z88gcQ0zKpHdgEUIW" \
 && echo "83e8a2a80e6607e89dc2a7848ccd1e5487970267bd95eb96512c706307092328 /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -

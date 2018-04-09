FROM scratch
ADD amzn2-container-raw-2017.12.0.20180330-x86_64.tar.xz /
CMD ["/bin/bash"]
RUN mkdir /usr/src/srpm \
 && curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/amzn2/srpm-bundle.tar.gz?versionId=8mjrgeFJaShkkKMhxThnPadPGHh2ayog" \
 && echo "f133970b2c227b440c92d44de5ff329b6fd4d2454ddbebacba98070ffb224caa /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -

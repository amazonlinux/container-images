FROM scratch
ADD amzn2-container-raw-2.0.20181114-arm64.tar.xz /
CMD ["/bin/bash"]
RUN mkdir /usr/src/srpm \
 && curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/amzn2/srpm-bundle.20181114.tar.gz?versionId=nB5.4dIHFJSZqiKkbJWmAufA2zT96NtU" \
 && echo "9e69458ec7d3617a02584b64d77558c513253de6ef0d33b8efbd709430c6e14a /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -

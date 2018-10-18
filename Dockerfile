FROM scratch
ADD amzn-container-minimal-2018.03.0.20181017-x86_64.tar.xz /
CMD ["/bin/bash"]
RUN mkdir /usr/src/srpm \
 && curl -o /usr/src/srpm/srpm-bundle.tar.gz "https://amazon-linux-docker-sources.s3-accelerate.amazonaws.com/srpm-bundle.tar.gz?versionId=ZW2bFkam8Gb.QRLgUOEuoufz6_pqpKO4" \
 && echo "25486405c5da50973bd8d153fc0126bfda35767f7a3f335d5fabf405bedb1377 /usr/src/srpm/srpm-bundle.tar.gz" | sha256sum -c -

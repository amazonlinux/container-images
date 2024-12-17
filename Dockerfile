FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20241113.1-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20241113.1/amzn2-container-raw-2.0.20241113.1-x86_64.tar.xz") \
  && echo '0f1df8ab4e42f67efd934ca4ed62839f3067b49184359dbe0d8b9aa740ed313c  amzn2-container-raw-2.0.20241113.1-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20241113.1-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20241113.1-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20241113.1-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

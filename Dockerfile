FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20240318.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20240318.0/amzn2-container-raw-2.0.20240318.0-arm64.tar.xz") \
  && echo 'c9cd6918e6b349112e8eaf46b4d2067ac3b6b1ea521f7ea0d40ead0c52e712af  amzn2-container-raw-2.0.20240318.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20240318.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20240318.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20240318.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

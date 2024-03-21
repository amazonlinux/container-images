FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.4.20240319.1-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.4.20240319.1/al2023-container-2023.4.20240319.1-arm64.tar.xz") \
  && echo '9965b27c32f46073bcd2bd3703c4c8507306359083c19a860e267e39d85c82f5  al2023-container-2023.4.20240319.1-arm64.tar.xz' >> /tmp/al2023-container-2023.4.20240319.1-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.4.20240319.1-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.4.20240319.1-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

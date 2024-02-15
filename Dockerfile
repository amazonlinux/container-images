FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.3.20240205.2-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.3.20240205.2/al2023-container-2023.3.20240205.2-arm64.tar.xz") \
  && echo 'dd6793e29db2d63bed2bc448a801e04a6f1f9878779917081574465c884e5c60  al2023-container-2023.3.20240205.2-arm64.tar.xz' >> /tmp/al2023-container-2023.3.20240205.2-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.3.20240205.2-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.3.20240205.2-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar \
    -C /rootfs \
    --extract \
    --exclude="./dev/*" \
    --exclude="./proc/*" \
    --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20260909.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20260909.0/al2023-container-2023.12.20260909.0-arm64.tar.xz") \
  && echo '28c33e4c87e994fbd2ce5ba96954e05ce6179b5f253a3ceed6dbd1fa8412f837  al2023-container-2023.12.20260909.0-arm64.tar.xz' >> /tmp/al2023-container-2023.12.20260909.0-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20260909.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20260909.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

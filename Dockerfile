FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20261016.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20261016.0/al2023-container-2023.12.20261016.0-arm64.tar.xz") \
  && echo '1f691be779bc3ac4e356260fec1a208dc41cce540f9e29d194c47a87b1b2e1cb  al2023-container-2023.12.20261016.0-arm64.tar.xz' >> /tmp/al2023-container-2023.12.20261016.0-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20261016.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20261016.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20260930.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20260930.0/al2023-container-2023.12.20260930.0-arm64.tar.xz") \
  && echo 'd9433fb6c6a04651ea9a6d76a3886550ec20a726fdbbd883704f25197fcb95c3  al2023-container-2023.12.20260930.0-arm64.tar.xz' >> /tmp/al2023-container-2023.12.20260930.0-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20260930.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20260930.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

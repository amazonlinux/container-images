FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20261102.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20261102.0/al2023-container-2023.12.20261102.0-arm64.tar.xz") \
  && echo 'fee09f9a8be7f966b6e607a72749d0d50d862c9b55decfb891f40f51a471da06  al2023-container-2023.12.20261102.0-arm64.tar.xz' >> /tmp/al2023-container-2023.12.20261102.0-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20261102.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20261102.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

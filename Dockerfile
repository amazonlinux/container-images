FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.6.20241010.1-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.6.20241010.1/al2023-container-2023.6.20241010.1-arm64.tar.xz") \
  && echo '403cb8cfa96897612eb8ea0cff9e6eebd6753d692f279215407453a1bcaf057b  al2023-container-2023.6.20241010.1-arm64.tar.xz' >> /tmp/al2023-container-2023.6.20241010.1-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.6.20241010.1-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.6.20241010.1-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

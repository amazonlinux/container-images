FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.3.20240108.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.3.20240108.0/al2023-container-2023.3.20240108.0-arm64.tar.xz") \
  && echo 'cc56e4426e4e51cd15c943f2f3ab51adf6918b53bce5c3b4b7cdfe91b038fa28  al2023-container-2023.3.20240108.0-arm64.tar.xz' >> /tmp/al2023-container-2023.3.20240108.0-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.3.20240108.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.3.20240108.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

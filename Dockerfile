FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20260918.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20260918.0/al2023-container-2023.12.20260918.0-arm64.tar.xz") \
  && echo '27546cfffcfa80dbc5d86d881b880af31ec1cad54e6831778f0cd6645fbfd6ae  al2023-container-2023.12.20260918.0-arm64.tar.xz' >> /tmp/al2023-container-2023.12.20260918.0-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20260918.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20260918.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

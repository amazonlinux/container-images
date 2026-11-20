FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20261120.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20261120.0/al2023-container-2023.12.20261120.0-arm64.tar.xz") \
  && echo '3b4e0a0eda988030e258368c6048d39b2880f44d53f4ed52c4993741f809b583  al2023-container-2023.12.20261120.0-arm64.tar.xz' >> /tmp/al2023-container-2023.12.20261120.0-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20261120.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20261120.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

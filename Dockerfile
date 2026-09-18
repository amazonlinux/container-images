FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20260918.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20260918.0/amzn2-container-raw-2.0.20260918.0-arm64.tar.xz") \
  && echo '80744c090e1c405da19ed97d65fa3fad4de420b5a418439dc3f9398a19e97fad  amzn2-container-raw-2.0.20260918.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20260918.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20260918.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20260918.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

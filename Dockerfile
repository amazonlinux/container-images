FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20260909.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20260909.0/amzn2-container-raw-2.0.20260909.0-arm64.tar.xz") \
  && echo 'fcae26eb8b84cc9d1f763dd4ef46b1e32d410878f742db2e8822af1dc2d19eae  amzn2-container-raw-2.0.20260909.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20260909.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20260909.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20260909.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

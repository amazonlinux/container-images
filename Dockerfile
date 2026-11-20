FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20261120.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20261120.0/amzn2-container-raw-2.0.20261120.0-arm64.tar.xz") \
  && echo '6d349f8a73035afaf3ff184aff1d03ec0266a29f74e33921a7a47ba51bb63b92  amzn2-container-raw-2.0.20261120.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20261120.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20261120.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20261120.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

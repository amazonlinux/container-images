FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20261021.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20261021.0/amzn2-container-raw-2.0.20261021.0-x86_64.tar.xz") \
  && echo '76f4b5ecd04d2159d0c8334a9d0369824d4bd934de0ce0f8aedee1f7c409e947  amzn2-container-raw-2.0.20261021.0-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20261021.0-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20261021.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20261021.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

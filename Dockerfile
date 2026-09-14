FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20260914.1-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20260914.1/amzn2-container-raw-2.0.20260914.1-arm64.tar.xz") \
  && echo 'ab5de19bab4e9af8a593cebbd912506bd0b461d36c4887728cbd1e3280ee4a5c  amzn2-container-raw-2.0.20260914.1-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20260914.1-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20260914.1-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20260914.1-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

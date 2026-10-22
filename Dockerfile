FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20261021.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20261021.0/amzn2-container-raw-2.0.20261021.0-arm64.tar.xz") \
  && echo 'b7254e27429b0d937f81028873bc7123e39b439d252906f0402a4c6d54c5e56a  amzn2-container-raw-2.0.20261021.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20261021.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20261021.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20261021.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

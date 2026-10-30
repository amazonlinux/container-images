FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20261102.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20261102.0/amzn2-container-raw-2.0.20261102.0-arm64.tar.xz") \
  && echo '63f0c9be40102457d1dd89ca40cbfa8cd2c3311d8dd4fee3b25150b3624538d7  amzn2-container-raw-2.0.20261102.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20261102.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20261102.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20261102.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

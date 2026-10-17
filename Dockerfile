FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20261016.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20261016.0/amzn2-container-raw-2.0.20261016.0-arm64.tar.xz") \
  && echo '79b6429cf48d55cf2bc91871586628306066ba856fabf8203b318d229e9e6784  amzn2-container-raw-2.0.20261016.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20261016.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20261016.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20261016.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

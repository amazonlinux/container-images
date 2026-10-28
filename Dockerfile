FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20261027.0-arm64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20261027.0/al2027-preview-container-2027.0.20261027.0-arm64.docker.tar.xz") \
  && echo '5c9e9eda3790e02bd8872ee206e978348d2042a3ac816ee591cd2578b9772dc8  al2027-preview-container-2027.0.20261027.0-arm64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20261027.0-arm64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20261027.0-arm64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20261027.0-arm64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

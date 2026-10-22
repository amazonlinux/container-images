FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20261021.0-arm64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20261021.0/al2027-preview-container-2027.0.20261021.0-arm64.docker.tar.xz") \
  && echo '5bf5689a39c2f381b3a05b6e582eb43e34aa7992f1ee18a4fab6fddce0b16f0a  al2027-preview-container-2027.0.20261021.0-arm64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20261021.0-arm64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20261021.0-arm64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20261021.0-arm64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

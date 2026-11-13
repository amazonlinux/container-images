FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20261112.1-arm64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20261112.1/al2027-preview-container-2027.0.20261112.1-arm64.docker.tar.xz") \
  && echo '1ad7784fc34c27127bd47348d866b00708d8703317646f52c482b960945554f8  al2027-preview-container-2027.0.20261112.1-arm64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20261112.1-arm64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20261112.1-arm64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20261112.1-arm64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

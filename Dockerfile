FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20260928.1-arm64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20260928.1/al2027-preview-container-2027.0.20260928.1-arm64.docker.tar.xz") \
  && echo 'c2fb6c6059e5f0b1a062f581ca38ded5e9305d3301872020a66c15ee64f76d7c  al2027-preview-container-2027.0.20260928.1-arm64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20260928.1-arm64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20260928.1-arm64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20260928.1-arm64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

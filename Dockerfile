FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20260914.0-arm64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20260914.0/al2027-preview-container-2027.0.20260914.0-arm64.docker.tar.xz") \
  && echo 'b7bd88fdce2c8d95ee7c1dee20d5b98aaa6d2c17afd4e3f5b4b41eec888ca0a1  al2027-preview-container-2027.0.20260914.0-arm64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20260914.0-arm64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20260914.0-arm64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20260914.0-arm64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

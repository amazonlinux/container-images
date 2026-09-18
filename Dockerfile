FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20260914.0-x86_64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20260914.0/al2027-preview-container-2027.0.20260914.0-x86_64.docker.tar.xz") \
  && echo '3b6a2102c46622ada93424833da94c75a1ab989ec45b607ef0b5e64df0f8a6e7  al2027-preview-container-2027.0.20260914.0-x86_64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20260914.0-x86_64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20260914.0-x86_64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20260914.0-x86_64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

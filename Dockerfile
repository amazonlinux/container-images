FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20261016.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20261016.0/al2023-container-2023.12.20261016.0-x86_64.tar.xz") \
  && echo '9a5274311a5849eed32d0db31f0cd28430d5aa9e1ed46a7c3d54ca6a3b2cbe14  al2023-container-2023.12.20261016.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.12.20261016.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20261016.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20261016.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

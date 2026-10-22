FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20261021.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20261021.0/al2023-container-2023.12.20261021.0-x86_64.tar.xz") \
  && echo '0e0158cb9c4275c538f17075fcc86c3b425879c219a28cdce61656da187c8550  al2023-container-2023.12.20261021.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.12.20261021.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20261021.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20261021.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

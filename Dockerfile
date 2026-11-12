FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20261112.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20261112.0/al2023-container-2023.12.20261112.0-x86_64.tar.xz") \
  && echo 'b7520dbf02090fe87c0dd9b5071b8f91d561abdfceac44569cd2e2751fbc8f42  al2023-container-2023.12.20261112.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.12.20261112.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20261112.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20261112.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

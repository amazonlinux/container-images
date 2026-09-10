FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20260909.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20260909.0/al2023-container-2023.12.20260909.0-x86_64.tar.xz") \
  && echo '6c80c9c46ae8f4665925232d55d76f9d8f83928d3c9eca0b1b10fa659bbbbac7  al2023-container-2023.12.20260909.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.12.20260909.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20260909.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20260909.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

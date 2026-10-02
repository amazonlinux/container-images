FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20260930.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20260930.0/al2023-container-2023.12.20260930.0-x86_64.tar.xz") \
  && echo '215a257916d6076fc21d4d76e18c745816f149ec0be080a29e578ac54e2ca61e  al2023-container-2023.12.20260930.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.12.20260930.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20260930.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20260930.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

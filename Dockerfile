FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20260918.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20260918.0/al2023-container-2023.12.20260918.0-x86_64.tar.xz") \
  && echo '8d7504c57aaa649b01720d9d359140baea4a4e6d5881221db2ed05ee97276a11  al2023-container-2023.12.20260918.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.12.20260918.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20260918.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20260918.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

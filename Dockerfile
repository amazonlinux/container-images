FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20260914.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20260914.0/al2023-container-2023.12.20260914.0-x86_64.tar.xz") \
  && echo '3456ad7dfd09307f01437cef2ed3dd509de6f83979f5ca97cf536d7a2bd9245d  al2023-container-2023.12.20260914.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.12.20260914.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20260914.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20260914.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

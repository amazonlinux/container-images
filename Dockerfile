FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.4.20240319.1-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.4.20240319.1/al2023-container-2023.4.20240319.1-x86_64.tar.xz") \
  && echo '8a9460ff38911e4997bf829d9b2dc3c020f370fc80d0c1bf9d24b302e3ece502  al2023-container-2023.4.20240319.1-x86_64.tar.xz' >> /tmp/al2023-container-2023.4.20240319.1-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.4.20240319.1-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.4.20240319.1-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

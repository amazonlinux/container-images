FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.3.20240108.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.3.20240108.0/al2023-container-2023.3.20240108.0-x86_64.tar.xz") \
  && echo '375e917134782efb468c2c4f9f9a00d299c0a1140476d9471a0a9615dbf63158  al2023-container-2023.3.20240108.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.3.20240108.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.3.20240108.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.3.20240108.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

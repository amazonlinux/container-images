FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20241014.1-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20241014.1/amzn2-container-raw-2.0.20241014.1-arm64.tar.xz") \
  && echo 'be2263d9642730c37b82e83d96a5158bfd85d5d77e436155a6b14a88fbbb034e  amzn2-container-raw-2.0.20241014.1-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20241014.1-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20241014.1-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20241014.1-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

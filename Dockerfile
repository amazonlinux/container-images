FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20240318.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20240318.0/amzn2-container-raw-2.0.20240318.0-x86_64.tar.xz") \
  && echo 'cbc8441bda155fc0d95e9c150cf4fa12b7e0fbdcd273aa0d44b8a8468f27a7a1  amzn2-container-raw-2.0.20240318.0-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20240318.0-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20240318.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20240318.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

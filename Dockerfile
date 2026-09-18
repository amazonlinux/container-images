FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20260918.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20260918.0/amzn2-container-raw-2.0.20260918.0-x86_64.tar.xz") \
  && echo '38a5248d379ddcb9aff5e6db2296824094a7bf5800a5f7e5b94c139aa119afb1  amzn2-container-raw-2.0.20260918.0-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20260918.0-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20260918.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20260918.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

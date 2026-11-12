FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20261112.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20261112.0/amzn2-container-raw-2.0.20261112.0-x86_64.tar.xz") \
  && echo '6cde4ff3840d957acbf16fcded7c5ae421c0c48c9ade9cf44b8843c9ed83029c  amzn2-container-raw-2.0.20261112.0-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20261112.0-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20261112.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20261112.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

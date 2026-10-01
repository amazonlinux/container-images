FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20260930.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20260930.0/amzn2-container-raw-2.0.20260930.0-x86_64.tar.xz") \
  && echo '956e6b7d0161c674d736396d438d854a108e1639b48b2ec7fbf8be04ee9718b4  amzn2-container-raw-2.0.20260930.0-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20260930.0-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20260930.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20260930.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

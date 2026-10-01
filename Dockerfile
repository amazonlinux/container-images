FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20260930.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20260930.0/amzn2-container-raw-2.0.20260930.0-arm64.tar.xz") \
  && echo 'ab27f8c5f7b358aa0802802c4782fc0dbd685d18c70b9e1ec403838bb0f111d9  amzn2-container-raw-2.0.20260930.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20260930.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20260930.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20260930.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

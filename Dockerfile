FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20260923.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20260923.0/amzn2-container-raw-2.0.20260923.0-arm64.tar.xz") \
  && echo 'f197c4dd04b30f11ca02915eb7689825d5d92a9e5bbad37d5733d15e71fb38e4  amzn2-container-raw-2.0.20260923.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20260923.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20260923.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20260923.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

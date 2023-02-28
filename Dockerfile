FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sOJL -w "amzn2-container-raw-2.0.20230221.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20230221.0/amzn2-container-raw-2.0.20230221.0-arm64.tar.xz") \
  && echo '9138bc34ddfa2ef46e1963ff72172920a30118c747064513640bf7f7b7f5104b  amzn2-container-raw-2.0.20230221.0-arm64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20230221.0-arm64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20230221.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20230221.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

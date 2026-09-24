FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20260923.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20260923.0/amzn2-container-raw-2.0.20260923.0-x86_64.tar.xz") \
  && echo 'b0718384a1dd3b569b5282177e3848eae47121e7ad34e39f75b29022d127daf8  amzn2-container-raw-2.0.20260923.0-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20260923.0-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20260923.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20260923.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

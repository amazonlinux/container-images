FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn-container-minimal-2018.03.0.20231218.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn/2018.03.0.20231218.0/amzn-container-minimal-2018.03.0.20231218.0-x86_64.tar.xz") \
  && echo 'd5de9d764937f8847d3dd81eabaa9cf734d52fcbbb78ab545b20abec0fa356bb  amzn-container-minimal-2018.03.0.20231218.0-x86_64.tar.xz' >> /tmp/amzn-container-minimal-2018.03.0.20231218.0-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn-container-minimal-2018.03.0.20231218.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn-container-minimal-2018.03.0.20231218.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

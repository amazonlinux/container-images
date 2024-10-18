FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20241014.1-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20241014.1/amzn2-container-raw-2.0.20241014.1-x86_64.tar.xz") \
  && echo '0b7aa3f82a8bb4a55f81f122434c104ac138da47444f663b55ada98983bae57d  amzn2-container-raw-2.0.20241014.1-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20241014.1-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20241014.1-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20241014.1-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20261102.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20261102.0/amzn2-container-raw-2.0.20261102.0-x86_64.tar.xz") \
  && echo '4865c71278b8df468d0eeb289357ad28adf255b86f750676098172d4e0c9d221  amzn2-container-raw-2.0.20261102.0-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20261102.0-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20261102.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20261102.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

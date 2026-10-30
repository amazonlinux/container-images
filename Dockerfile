FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20261102.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20261102.0/al2023-container-2023.12.20261102.0-x86_64.tar.xz") \
  && echo 'b1f138b77457824558e904344c2871555d203eab7037d5ee105917c78fbcac7d  al2023-container-2023.12.20261102.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.12.20261102.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20261102.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20261102.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

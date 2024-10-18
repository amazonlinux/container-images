FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.6.20241010.1-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.6.20241010.1/al2023-container-2023.6.20241010.1-x86_64.tar.xz") \
  && echo '06d09de41f7baa7a5450c86f5f6b234780ea5a13efa7651e53cbd43669ad80fa  al2023-container-2023.6.20241010.1-x86_64.tar.xz' >> /tmp/al2023-container-2023.6.20241010.1-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.6.20241010.1-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.6.20241010.1-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

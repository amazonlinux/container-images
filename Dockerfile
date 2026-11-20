FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20261120.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20261120.0/al2023-container-2023.12.20261120.0-x86_64.tar.xz") \
  && echo 'ad132446589144a55d3b3c6e43167c11d95c18389d60fa8baab9efe904da2864  al2023-container-2023.12.20261120.0-x86_64.tar.xz' >> /tmp/al2023-container-2023.12.20261120.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20261120.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20261120.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

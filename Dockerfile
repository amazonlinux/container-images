FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2023-container-2023.12.20261021.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2023/2023.12.20261021.0/al2023-container-2023.12.20261021.0-arm64.tar.xz") \
  && echo 'c2e50345eb2964cd4aae4c57d46db03ffd5a050818d089891801d0cb8b1cefed  al2023-container-2023.12.20261021.0-arm64.tar.xz' >> /tmp/al2023-container-2023.12.20261021.0-arm64.tar.xz.sha256 \
  && cat /tmp/al2023-container-2023.12.20261021.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2023-container-2023.12.20261021.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

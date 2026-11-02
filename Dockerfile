FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20261102.0-arm64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20261102.0/al2027-preview-container-2027.0.20261102.0-arm64.docker.tar.xz") \
  && echo 'a897074b39edc093c69bedb6d293e055fd8e4fb779037b8c02fa38a09519f1bc  al2027-preview-container-2027.0.20261102.0-arm64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20261102.0-arm64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20261102.0-arm64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20261102.0-arm64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20261012.0-arm64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20261012.0/al2027-preview-container-2027.0.20261012.0-arm64.docker.tar.xz") \
  && echo '9470b9cba5e12d08bb9bebb96ef117b70516caa0071981a9505a5f8bf34e0336  al2027-preview-container-2027.0.20261012.0-arm64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20261012.0-arm64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20261012.0-arm64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20261012.0-arm64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

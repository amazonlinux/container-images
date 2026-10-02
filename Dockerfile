FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20260928.1-x86_64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20260928.1/al2027-preview-container-2027.0.20260928.1-x86_64.docker.tar.xz") \
  && echo '7f2701174a305b0d602a32cb73a6f082b4d3b7acbee53ef7b95e746696f93450  al2027-preview-container-2027.0.20260928.1-x86_64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20260928.1-x86_64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20260928.1-x86_64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20260928.1-x86_64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

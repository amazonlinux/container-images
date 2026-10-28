FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20261027.0-x86_64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20261027.0/al2027-preview-container-2027.0.20261027.0-x86_64.docker.tar.xz") \
  && echo '7a83ed00859dca563e885800c87808acc6e042af317263cd7fb181802457c08c  al2027-preview-container-2027.0.20261027.0-x86_64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20261027.0-x86_64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20261027.0-x86_64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20261027.0-x86_64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

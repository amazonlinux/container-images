FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20261012.0-x86_64.docker.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20261012.0/al2027-preview-container-2027.0.20261012.0-x86_64.docker.tar.xz") \
  && echo '27088b16900a6ff69d3b7b7761c19da6fca62072c988c39afd224512a81d47d9  al2027-preview-container-2027.0.20261012.0-x86_64.docker.tar.xz' >> /tmp/al2027-preview-container-2027.0.20261012.0-x86_64.docker.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20261012.0-x86_64.docker.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20261012.0-x86_64.docker.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

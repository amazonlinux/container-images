FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20260903.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20260903.0/al2027-preview-container-2027.0.20260903.0-x86_64.tar.xz") \
  && echo '5c622910cf1a8693693a636b30690b51bbe71f034b434966bb4b36ff8ae937eb  al2027-preview-container-2027.0.20260903.0-x86_64.tar.xz' >> /tmp/al2027-preview-container-2027.0.20260903.0-x86_64.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20260903.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20260903.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

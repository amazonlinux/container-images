FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "al2027-preview-container-2027.0.20260903.0-arm64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/al2027/2027.0.20260903.0/al2027-preview-container-2027.0.20260903.0-arm64.tar.xz") \
  && echo '241029a1a5b527fffd425484b24e2f38cdef6b47c65c776272f63ea898bdb45a  al2027-preview-container-2027.0.20260903.0-arm64.tar.xz' >> /tmp/al2027-preview-container-2027.0.20260903.0-arm64.tar.xz.sha256 \
  && cat /tmp/al2027-preview-container-2027.0.20260903.0-arm64.tar.xz.sha256 \
  && sha256sum -c /tmp/al2027-preview-container-2027.0.20260903.0-arm64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

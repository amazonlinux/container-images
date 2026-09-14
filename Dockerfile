FROM alpine:latest AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sfOJL -w "amzn2-container-raw-2.0.20260914.1-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20260914.1/amzn2-container-raw-2.0.20260914.1-x86_64.tar.xz") \
  && echo '59eb182a71ea00fcd72eba38c4d776349f174a31956c1246e9d2b9014295b34b  amzn2-container-raw-2.0.20260914.1-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20260914.1-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20260914.1-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20260914.1-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

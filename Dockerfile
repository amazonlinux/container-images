FROM alpine:3.17 AS verify
RUN apk add --no-cache curl tar xz

RUN ROOTFS=$(curl -sOJL -w "amzn2-container-raw-2.0.20230221.0-x86_64.tar.xz" "https://amazon-linux-docker-sources.s3.amazonaws.com/amzn2/2.0.20230221.0/amzn2-container-raw-2.0.20230221.0-x86_64.tar.xz") \
  && echo '6103adfbad9f8a9a58e151183ec11f51f9b7ba85ff13bd976d6998077ecf34c1  amzn2-container-raw-2.0.20230221.0-x86_64.tar.xz' >> /tmp/amzn2-container-raw-2.0.20230221.0-x86_64.tar.xz.sha256 \
  && cat /tmp/amzn2-container-raw-2.0.20230221.0-x86_64.tar.xz.sha256 \
  && sha256sum -c /tmp/amzn2-container-raw-2.0.20230221.0-x86_64.tar.xz.sha256 \
  && mkdir /rootfs \
  && tar -C /rootfs --extract --file "${ROOTFS}"

FROM scratch AS root
COPY --from=verify /rootfs/ /

CMD ["/bin/bash"]

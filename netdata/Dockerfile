ARG BUILD_FROM
FROM $BUILD_FROM
LABEL maintainer="packruler"

EXPOSE 19999

# Install openssl to claim node
RUN apk update &&\
    apk add openssl

# Execute during the build of the image
RUN curl https://my-netdata.io/kickstart.sh > /tmp/netdata-kickstart.sh && \
  sh /tmp/netdata-kickstart.sh \
  --no-updates \
  --stable-channel \ 
  --disable-telemetry \
  --non-interactive \
  --install-version 1.37.1

COPY ./cloud.conf /opt/netdata/etc/netdata/netdata.conf
COPY ./cloud.conf /opt/netdata/var/lib/netdata/cloud.d/cloud.conf

# Copy data for add-on
COPY rootfs /

CMD [ "/usr/bin/run.sh" ]
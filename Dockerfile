FROM alpine:3 AS builder

RUN apk add --update-cache --no-cache make gcc musl-dev && \
  wget -O - https://github.com/nns779/px4_drv/archive/refs/heads/develop.zip | unzip - && \
  cd px4_drv-develop/fwtool && \
  make -j$(nproc) && \
  tar czvf /px4_drv.tar.gz /px4_drv-develop


FROM alpine:3

COPY --from=builder /px4_drv.tar.gz /
RUN tar zxvf /px4_drv.tar.gz
WORKDIR /px4_drv-develop/fwtool

VOLUME /lib/firmware
VOLUME /usr/src/px4_drv-0.2.1

COPY ./build.sh /
CMD /build.sh

### build stage
FROM debian:stretch-slim as builder

RUN apt-get update && apt-get install -y libleveldb-dev libcurl4-openssl-dev libmicrohttpd-dev libudev-dev cmake

COPY . /data
 
WORKDIR /data

RUN ./scripts/install_deps.sh

RUN cmake -H. -Bbuild && cd build/ethminer && make -j $(nproc)

FROM debian:stretch-slim as runner

COPY --from=builder /data/build/ethminer/ethminer /usr/bin/ethminer
COPY --from=builder /data/scripts/install_deps.sh /data/install_deps.sh

RUN sh /data/install_deps.sh

RUN chmod +x /usr/bin/ethminer

ENTRYPOINT [ "ethminer" ]

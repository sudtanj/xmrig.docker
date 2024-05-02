FROM ubuntu:latest as build
 
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y build-essential cmake automake libtool autoconf wget	 
RUN wget https://github.com/xmrig/xmrig/archive/refs/tags/v6.21.3.tar.gz; \
    tar xf v6.21.3.tar.gz; \
    mkdir -p xmrig-6.21.3/build; \
    cd xmrig-6.21.3/scripts && ./build_deps.sh; \
    cd xmrig-6.21.3/build; \
    cmake .. -DXMRIG_DEPS=scripts/deps; \
    make; \
    cp xmrig /usr/local/bin/xmrig
    
    
FROM ubuntu:latest as main

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y uuid-runtime && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bin/xmrig /usr/local/bin/xmrig

ENV POOL_USER="" \
    POOL_URL="" \
    POOL_PASS="" \
    DONATE_LEVEL=1 \
    PRIORITY=1 \
    THREADS=0 \
    ACCESS_TOKEN="" \
    ALGO="" \
    COIN=""

ADD entrypoint.sh /entrypoint.sh
WORKDIR /tmp
EXPOSE 3000

LABEL org.opencontainers.image.source=https://github.com/murf2/xmrig.docker
LABEL org.opencontainers.image.description="An up-to-date and easy to use XMRig image for mining Monero on any x86/ARM Docker host."
LABEL org.opencontainers.image.licenses=MIT

CMD ["/entrypoint.sh"]

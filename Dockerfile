FROM debian:12 AS builder
ARG VERSION=1.25.2
WORKDIR /
RUN apt-get update; apt-get install -y git cmake build-essential libssl-dev zlib1g-dev libpcre3-dev pkg-config libc-ares-dev libre2-dev 
RUN git clone https://github.com/nginx/nginx.git && cd /nginx && git checkout tags/release-$VERSION && auto/configure --with-compat
RUN git clone https://github.com/nginxinc/nginx-otel.git && cd /nginx-otel && mkdir build && cd build && cmake -DNGX_OTEL_NGINX_BUILD_DIR=/nginx/objs .. && make

FROM gcr.io/distroless/static-debian12
COPY --from=builder /nginx-otel/build/ngx_otel_module.so /ngx_otel_module.so

FROM ubuntu:20.04 AS build

LABEL maintainer="BecodReyes <i@muir.fun>"

ENV DEBIAN_FRONTEND noninteractive

ENV NGINX_VERSION 1.21.3
ENV NGINX_SHA256 14774aae0d151da350417efc4afda5cce5035056e71894836797e1f6e2d1175a

ENV PCRE_VERSION 8.45
ENV PCRE_SHA256 4e6ce03e0336e8b4a3d6c2b70b1c5e18590a5673a98186da90d4f33c23defc09

ENV JEMALLOC_VERSION 5.2.1
ENV JEMALLOC_SHA256 34330e5ce276099e2e8950d9335db5a875689a4c6a56751ef3b1d8c537f887f6

ENV OPENSSL_VERSION 3.0.0
ENV OPENSSL_SHA256 59eedfcb46c25214c9bd37ed6078297b4df01d012267fe9e9eee31f61bc70536

ADD https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz /tmp/nginx.tar.gz
ADD https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz /tmp/pcre.tar.gz
ADD https://github.com/jemalloc/jemalloc/releases/download/$JEMALLOC_VERSION/jemalloc-$JEMALLOC_VERSION.tar.bz2 /tmp/jemalloc.tar.bz2
ADD https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz /tmp/openssl.tar.gz

RUN [ "$(sha256sum /tmp/nginx.tar.gz | awk '{print $1}')" = "$NGINX_SHA256" ] \
    && [ "$(sha256sum /tmp/pcre.tar.gz | awk '{print $1}')" = "$PCRE_SHA256" ] \
    && [ "$(sha256sum /tmp/jemalloc.tar.bz2 | awk '{print $1}')" = "$JEMALLOC_SHA256" ] \
    && [ "$(sha256sum /tmp/openssl.tar.gz | awk '{print $1}')" = "$OPENSSL_SHA256" ] \
    && apt update \
    && apt-get install -y \
    build-essential \
    git \
    cmake \
    golang \
    ca-certificates \
    wget \
    autoconf \
    && mkdir /tmp/modules \
    && cpuCores=`cat /proc/cpuinfo| grep "processor"| wc -l`

# 准备pcre
RUN tar -C "/tmp/modules" -xf "/tmp/pcre.tar.gz" \
    && cd "/tmp/modules/pcre-$PCRE_VERSION" \
    && ./configure \
    && make -j${cpuCores}\
    && make install

# 准备openssl
RUN tar -C "/tmp/modules" -xf "/tmp/openssl.tar.gz" \
    && cd "/tmp/modules/openssl-$OPENSSL_VERSION" \
    && ./Configure \
    && make -j${cpuCores} \
    && make install

#准备luajit
RUN git clone --depth 1 https://github.com/openresty/luajit2.git  "/tmp/modules/luajit2" \
	&& cd "/tmp/modules/luajit2" \
    && make -j${cpuCores} \
    && make install PREFIX=/usr/local/LuaJIT \
    && echo "/usr/local/lib" >> /etc/ld.so.conf \
    && ldconfig

# 准备zlib-cf
RUN git clone --depth 1 https://github.com/cloudflare/zlib.git "/tmp/modules/zlib-cf" \
	&& cd "/tmp/modules/zlib-cf" \
	&& ./configure \
    && make -j${cpuCores} \
    && make install

#准备其他模块
RUN git clone --depth 1 https://github.com/openresty/headers-more-nginx-module.git /tmp/modules/ngx_headers_more \
    && git clone --depth 1 https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git /tmp/modules/ngx_subs_filter \
    && git clone --depth 1 https://github.com/leev/ngx_http_geoip2_module.git /tmp/modules/ngx_http_geoip2_module \
    && git clone --depth=1 https://github.com/nginx/njs.git /tmp/modules/njs \
    && git clone --depth=1 https://github.com/vision5/ngx_devel_kit.git /tmp/modules/ngx_devel_kit \
    && git clone --depth=1 https://github.com/FRiCKLE/ngx_cache_purge.git /tmp/modules/ngx_cache_purge \
    && git clone --depth=1 https://github.com/Refinitiv/nginx-sticky-module-ng.git /tmp/modules/nginx_sticky_module \
    && git clone --depth=1 https://github.com/AirisX/nginx_cookie_flag_module.git /tmp/modules/nginx_cookie_flag_module \
    && git clone --depth=1 https://github.com/openresty/lua-nginx-module.git /tmp/modules/lua_nginx_module \
    && git clone --depth 1 https://github.com/google/ngx_brotli.git /tmp/modules/ngx_brotli \
    && cd /tmp/modules/ngx_brotli && git submodule update --init

#静态编译nginx
RUN cat /etc/ld.so.conf \
    && export LUAJIT_LIB=/usr/local/LuaJIT/lib \
    && export LUAJIT_INC=/usr/local/LuaJIT/include/luajit-2.1 \
	&& export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH \
    && tar -C "/tmp/" -xf "/tmp/nginx.tar.gz" \
    && cd "/tmp/nginx-$NGINX_VERSION" \
    && ./configure \
    --prefix=/tmp \
	--with-cc-opt="-static -static-libgcc" \
	--with-ld-opt="-static" \
    --sbin-path=/tmp/nginx \
    --modules-path=/tmp/modules \
    --conf-path=/tmp/nginx.conf \
    --http-log-path=/dev/stdout \
    --error-log-path=/dev/stderr \
    --pid-path=/tmp/nginx.pid \
    --lock-path=/tmp/nginx.lock \
    --http-client-body-temp-path=/tmp/client_temp \
    --http-proxy-temp-path=/tmp/proxy_temp \
    --http-fastcgi-temp-path=/tmp/fastcgi_temp \
    --http-uwsgi-temp-path=/tmp/uwsgi_temp \
    --http-scgi-temp-path=/tmp/scgi_temp \
    --with-pcre=/tmp/modules/pcre-$PCRE_VERSION \
    --with-pcre-jit \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream_realip_module \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-compat \
    --with-ipv6 \
    --with-file-aio \
    --with-openssl=/tmp/modules/openssl-$OPENSSL_VERSION \
    --with-openssl-opt=zlib \
    --with-http_v2_module \
    --with-zlib=/tmp/modules/zlib-cf \
    --add-module=/tmp/modules/ngx_brotli \
    --add-module=/tmp/modules/ngx_headers_more \
    --add-module=/tmp/modules/ngx_subs_filter \
    --add-module=/tmp/modules/njs/nginx \
    --add-module=/tmp/modules/nginx_cookie_flag_module \
    --add-module=/tmp/modules/ngx_devel_kit \
    --add-module=/tmp/modules/lua_nginx_module \
    --add-module=/tmp/modules/ngx_cache_purge \
    --add-module=/tmp/modules/nginx_sticky_module \
    && make -j${cpuCores}


# 复制所需文件，准备打包到0层
RUN mkdir -p /rootfs/bin && \
      cp /tmp/nginx-$NGINX_VERSION/objs/nginx /rootfs/bin/ && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd && \
    mkdir -p /rootfs/etc/nginx && \
    mkdir -p /rootfs/etc/ssl/certs && \
      cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/ && \
    mkdir -p /rootfs/tmp

# 复制到0层
FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /

USER 10000:10000
ENTRYPOINT ["/bin/nginx"]
CMD ["-g", "daemon off;"]
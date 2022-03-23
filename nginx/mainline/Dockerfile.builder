FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

ENV JEMALLOC_VERSION 5.2.1
ENV PCRE_VERSION 8.45
ENV OPENSSL_VERSION 3.0.1
ENV NGINX_VERSION 1.21.5
ENV INOTIFY_TOOLS_VERSON 3.21.9.6

RUN echo "deb http://mirrors.aliyun.com/debian bullseye main" > /etc/apt/sources.list \
 && apt update \
 && apt-get install ca-certificates -y \
 && echo "deb https://mirrors.aliyun.com/debian bullseye main" > /etc/apt/sources.list \
 && apt update \
 && apt-get install -y \
    build-essential \
    git \
    cmake \
    wget \
    libtool \
    pkg-config \
    autoconf

RUN wget -O "/usr/local/src/jemalloc.tar.bz2" "https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2" \
 && tar -C "/usr/local/src" --no-same-owner -jxf "/usr/local/src/jemalloc.tar.bz2" \
 && cd "/usr/local/src/jemalloc-${JEMALLOC_VERSION}" \
 && ./configure \
 && make -j$(nproc) \
 && make install

RUN wget -O "/usr/local/src/pcre.tar.gz" "https://jaist.dl.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz" \
 && tar -C "/usr/local/src" -xf "/usr/local/src/pcre.tar.gz" \
 && cd "/usr/local/src/pcre-$PCRE_VERSION" \
 && ./configure \
 && make -j${cpuCores}\
 && make install

RUN wget -O "/usr/local/src/openssl.tar.gz" "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" \
 && tar -C "/usr/local/src" -xf "/usr/local/src/openssl.tar.gz" \
 && cd "/usr/local/src/openssl-$OPENSSL_VERSION" \
 && ./Configure \
 && make -j$(nproc) \
 && make install

RUN git clone --depth 1 https://github.com/cloudflare/zlib.git "/usr/local/src/zlib-cf" \
 && cd "/usr/local/src/zlib-cf" \
 && ./configure \
 && make -j$(nproc) \
 && make install

RUN git clone --depth 1 https://github.com/google/ngx_brotli.git /usr/local/src/ngx_brotli \
 && cd /usr/local/src/ngx_brotli && git submodule update --init

RUN git clone --depth=1 -b ${INOTIFY_TOOLS_VERSON} https://github.com/inotify-tools/inotify-tools /usr/local/src/inotify-tools \
 && cd /usr/local/src/inotify-tools \
 && ./autogen.sh \
 && ./configure --prefix=/inotify-tools \
 && make -j$(nproc) \
 && make install

RUN wget -O "/usr/local/src/nginx.tar.gz" "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
 && tar -C "/usr/local/src/" -xf "/usr/local/src/nginx.tar.gz" \
 && cd "/usr/local/src/nginx-${NGINX_VERSION}" \
 && ldconfig \
 && ./configure \
    --with-ld-opt='-ljemalloc -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' \
    --with-cc-opt='-g -O2 -pipe -fstack-protector-strong -Wformat -Werror=format-security -fPIC' \
    --prefix=/etc/nginx \
    --sbin-path=/usr/bin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --modules-path=/usr/lib/nginx/modules \
    --http-log-path=/dev/stdout \
    --error-log-path=/dev/stderr \
    --pid-path=/etc/nginx/nginx.pid \
    --lock-path=/etc/nginx/nginx.lock \
    --http-client-body-temp-path=/tmp/nginx/client_temp \
    --http-proxy-temp-path=/tmp/nginx/proxy_temp \
    --http-fastcgi-temp-path=/tmp/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/tmp/nginx/uwsgi_temp \
    --http-scgi-temp-path=/tmp/nginx/scgi_temp \
    --with-pcre=/usr/local/src/pcre-$PCRE_VERSION \
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
    --with-ipv6 \
    --with-file-aio \
    --with-openssl=/usr/local/src/openssl-$OPENSSL_VERSION \
    --with-openssl-opt=zlib \
    --with-zlib=/usr/local/src/zlib-cf \
    --with-http_v2_module \
    --with-compat \
    --add-module=/usr/local/src/ngx_brotli \
 && make -j$(nproc)
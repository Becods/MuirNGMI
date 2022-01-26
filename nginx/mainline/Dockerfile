FROM nginx:builder AS Building

RUN mkdir -p /rootfs/usr/bin /rootfs/tmp/nginx /rootfs/lib /rootfs/entrypoint.d \
 && cp /usr/local/src/nginx-$NGINX_VERSION/objs/nginx /rootfs/usr/bin/ \
 && cp /usr/local/lib/libjemalloc.so.2 /rootfs/lib/ \
 && cp /inotify-tools/bin/* /rootfs/usr/bin/ -rf \
 && cp /inotify-tools/lib/* /rootfs/lib/ -rf \
 && mkdir -p /rootfs/etc \
 && mkdir -p /rootfs/etc/nginx \
 && mkdir -p /rootfs/etc/ssl/certs \
 && cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/

FROM debian:bullseye-slim
COPY --from=Building /rootfs /
COPY rootfs /
RUN useradd -l -u 25872 -s /sbin/nologin -p www www
ENTRYPOINT ["/entrypoint.sh"]
STOPSIGNAL SIGQUIT
CMD ["nginx", "-g", "daemon off;"]
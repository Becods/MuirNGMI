FROM becod/composer:8.1

USER root

RUN apt-get update \
 && apt-get install -y --no-install-recommends cron sudo \
 && rm -r /var/lib/apt/lists/* \
 && rm -r /var/cache/* \
 && sed -i 's#www:x:25872:25872::/home/www:/sbin/nologin#www:x:25872:25872::/home/www:/bin/bash#' /etc/passwd \
 && touch /var/log/cron.log \
 && rm -rf /etc/cron.d/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cron", "-f"]
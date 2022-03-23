FROM becod/php:7.3

RUN apt-get update \
 && apt-get install -y --no-install-recommends git libzip-dev zip unzip p7zip-full \
 && docker-php-ext-install zip \
 && rm -r /var/lib/apt/lists/* \
 && rm -r /var/cache/* \
 && mkdir /home/www/ \
 && chown -R www /home/www/

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

USER www

CMD composer ; bash
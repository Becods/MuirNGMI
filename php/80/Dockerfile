FROM php:8.0-fpm

RUN apt-get update \
 && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
 && apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmagickwand-dev libmemcached-dev zlib1g-dev \
 && rm -r /var/lib/apt/lists/* \
 && rm -r /var/cache/*

RUN docker-php-ext-configure gd -with-freetype=/usr/include/ -with-jpeg=/usr/include/ \
 && docker-php-ext-configure opcache --enable-opcache \
 && docker-php-ext-install -j$(nproc) gd opcache bcmath calendar exif gettext sockets dba mysqli pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm iconv \
 && pecl install imagick memcached redis swoole \
 && docker-php-ext-enable imagick memcached redis swoole opcache

RUN useradd -l -u 25872 -s /sbin/nologin -p www www

COPY zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
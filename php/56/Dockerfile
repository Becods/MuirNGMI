FROM php:5.6-fpm

RUN apt-get update \
 && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
 && apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmagickwand-dev zlib1g-dev libz-dev libmemcached-dev libzip-dev zip unzip p7zip-full git \
 && rm -r /var/lib/apt/lists/* \
 && rm -r /var/cache/*

RUN docker-php-ext-configure gd -with-freetype-dir=/usr/include/ -with-jpeg-dir=/usr/include/ \
 && docker-php-ext-configure opcache --enable-opcache \
 && docker-php-ext-configure zip --with-libzip \
 && docker-php-ext-install -j$(nproc) gd opcache bcmath calendar exif gettext sockets dba mysqli pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm iconv zip \
 && pecl install imagick memcached redis \
 && docker-php-ext-enable imagick opcache sockets

RUN useradd -l -u 25872 -s /sbin/nologin -p www www \
 && mkdir /home/www/ \
 && chown -R www /home/www/

COPY zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
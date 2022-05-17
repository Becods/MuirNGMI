FROM becod/php:7.3

RUN mkdir /home/www/ \
 && chown -R www /home/www/

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

USER www

CMD composer ; bash
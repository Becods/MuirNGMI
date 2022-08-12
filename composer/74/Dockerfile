FROM becod/php:74-cli

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

USER www

CMD composer ; bash
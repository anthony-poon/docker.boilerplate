FROM composer as build

WORKDIR /opt/workspace
COPY /src/composer.json /opt/workspace
COPY /src/composer.lock /opt/workspace
RUN composer install --ignore-platform-reqs

FROM php:8.4-fpm-alpine
ARG BUILD_ENV=prod

RUN apk add --no-cache \
    libpq \
    libzip
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS postgresql-dev libzip-dev linux-headers \
    && docker-php-ext-install pdo_pgsql pgsql zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && if [ "$BUILD_ENV" = "dev" ]; then \
      pecl install xdebug && docker-php-ext-enable xdebug; \
    fi \
    && apk del .build-deps

COPY /docker/app/php.ini /usr/local/etc/php/conf.d/php.ini
COPY /docker/app/xdebug.ini /tmp/xdebug.ini
RUN if [ "$BUILD_ENV" = "dev" ]; then \
      cp /tmp/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini; \
    fi \
    && rm -f /tmp/xdebug.ini

COPY --from=build /opt/workspace/vendor /var/www/vendor
COPY /src /var/www/html

WORKDIR /var/www
EXPOSE 80
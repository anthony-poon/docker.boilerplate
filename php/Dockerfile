FROM ubuntu:latest as staging

RUN apt-get update && apt-get install -y dos2unix
WORKDIR /opt/workspace
COPY ../configs/vhost-000-default.conf /opt/workspace/vhost-000-default.conf
COPY ../configs/xdebug.ini /opt/workspace/xdebug.ini

RUN dos2unix /opt/workspace/*

FROM composer as build

WORKDIR /opt/workspace
COPY ./src/composer.json /opt/workspace
COPY ./src/composer.lock /opt/workspace
RUN composer install --ignore-platform-reqs

FROM php:7.4-apache

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN mkdir /tmp/staging
## Overwritting default 000-default.conf
COPY --from=staging /opt/workspace/vhost-000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY --from=staging /opt/workspace/xdebug.ini /tmp/staging/xdebug.ini

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN cat /tmp/staging/xdebug.ini >> "$PHP_INI_DIR/php.ini"
RUN rm -rf /tmp/staging

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

COPY --from=build /opt/workspace/vendor /var/www/vendor
WORKDIR /var/www
EXPOSE 80
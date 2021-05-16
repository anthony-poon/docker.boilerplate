FROM composer as build

WORKDIR /opt/workspace
COPY ./composer.json /opt/workspace
COPY ./composer.lock /opt/workspace
RUN composer install

FROM php:7.4-apache
ARG BUILD_ENV
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public_html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# only install and activate xdebug on local docker build
RUN if [ $BUILD_ENV = dev ] ; then pecl install -o -f xdebug &&  rm -rf tmppear; docker-php-ext-enable xdebug; fi
# on local docker build use the development php.ini, otherwise use the production version of the image
RUN if [ $BUILD_ENV = dev ] ; then mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini;  else mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini; fi
RUN a2enmod rewrite

WORKDIR /var/www/html/
COPY --from=build /opt/workspace/vendor /var/www/html/vendor


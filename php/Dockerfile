FROM composer2.0.7 as build

FROM php7.3-apache
ARG BUILD_ENV
RUN apt-get update -y
RUN apt-get install -y git unzip lftp gnupg curl wget libcurl4-openssl-dev libpng-dev libfreetype6-dev libjpeg-dev libjpeg62-turbo-dev zlib1g-dev libpq-dev libxml2-dev libzip-dev libgmp-dev
RUN docker-php-ext-install curl
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install soap
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install xml
RUN docker-php-ext-install gmp
RUN docker-php-ext-install zip
RUN docker-php-ext-install json
RUN if [ $HTTP_PROXY ] ; then pear config-set http_proxy $HTTP_PROXY; fi
RUN pecl install -o -f redis &&  rm -rf tmppear &&  docker-php-ext-enable redis
# only install and activate xdebug on local docker build
RUN if [ $BUILD_ENV = local ] ; then pecl install -o -f xdebug &&  rm -rf tmppear; docker-php-ext-enable xdebug; fi

RUN docker-php-ext-configure gd --with-png-dir=usrinclude --with-jpeg-dir=usrinclude --with-freetype-dir=usrinclude
RUN docker-php-ext-install gd

# on local docker build use the development php.ini, otherwise use the production version of the image
RUN if [ $BUILD_ENV = local ] ; then mv $PHP_INI_DIRphp.ini-development $PHP_INI_DIRphp.ini;  else mv $PHP_INI_DIRphp.ini-production $PHP_INI_DIRphp.ini; fi
RUN sed -i 'spgsql.auto_reset_persistent = Offpgsql.auto_reset_persistent = Ong' $PHP_INI_DIRphp.ini
RUN a2enmod rewrite

RUN mkdir -p tmptemp
RUN chmod 777 tmptemp
RUN mkdir -p tmpcache
RUN chmod 777 tmpcache
RUN mkdir -p tmptemplates_c
RUN chmod 777 tmptemplates_c

COPY --from=build usrbincomposer usrbincomposer
COPY . varwww
WORKDIR varwww
RUN sed -i 's80${PORT}g' etcapache2sites-available000-default.conf etcapache2ports.conf

RUN composer install

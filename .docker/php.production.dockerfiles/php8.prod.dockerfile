FROM php:8 AS build

############################################################################
# Install system commands and libraries
############################################################################
RUN apt-get -y update \
    && apt-get install -y \
       curl \
       wget \
       git \
       zip \
       unzip

############################################################################
# Install Internationalization for composer require
############################################################################
RUN apt-get -y update \
&& apt-get install -y libicu-dev \
&& docker-php-ext-configure intl \
&& docker-php-ext-install intl

############################################################################
# Install MySQL PDO for composer require
############################################################################
RUN docker-php-ext-install pdo pdo_mysql \
&& docker-php-ext-configure pdo_mysql

############################################################################
# Copy prodcution ini file
############################################################################
COPY ./.docker/php.production.dockerfiles/configs/php.ini /usr/local/etc/php/php.ini

############################################################################
# Install PHP Composer https://getcomposer.org/download/
# Add "--version=1.10.22" after "php --" to get a specific version.
############################################################################
#RUN cd ~ \
#    && mkdir ~/bin \
#    && curl -sS https://getcomposer.org/installer | php -- --install-dir=$HOME/bin --filename=composer.phar \
#    && chmod u+x ~/bin/composer.phar \
#    && echo "#!/usr/bin/env bash\n\nXDEBUG_MODE=off ~/bin/composer.phar \$@" > ~/bin/composer \
#    && chmod u+x ~/bin/composer

############################################################################
# copy the code into the container
############################################################################
COPY ./app /var/www


############################################################################
# Remove all libraries to force a fresh install
############################################################################
RUN rm -fr /var/www/vendor

############################################################################
# Install composer dependencies
############################################################################
WORKDIR /var/www
#RUN ~/bin/composer install --no-dev --optimize-autoloader

############################################################################
# Remove unneeded files
############################################################################
RUN rm -rf /var/www/vendor/composer \
    && rm -rf /var/www/vendor/bin




FROM php:8-apache AS production

############################################################################
# Install Internationalization
############################################################################
RUN apt-get -y update \
&& apt-get install -y libicu-dev \
&& docker-php-ext-configure intl \
&& docker-php-ext-install intl

############################################################################
# Install MySQL PDO
############################################################################
RUN docker-php-ext-install pdo pdo_mysql \
&& docker-php-ext-configure pdo_mysql

############################################################################
# Install Apache modules
############################################################################
RUN a2enmod rewrite

############################################################################
# Copy production ini file
############################################################################
COPY ./.docker/php.production.dockerfiles/configs/php.ini /usr/local/etc/php/php.ini

############################################################################
# copy production code into the container
############################################################################
COPY --from=build /var/www /var/www

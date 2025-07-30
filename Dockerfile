FROM php:8.1-apache AS php8base
############################################################################
# This is the base PHP 8 docker image used for both the development and
# production docker files.  By having this file common we can ensure that
# any needed extensions are installed the same in both docker enviornments.
#
# Only things that are common acorss both the development and prodcution
# docker files should go in this file.
############################################################################


############################################################################
# Install system commands and libraries
############################################################################
RUN apt-get -y update \
    && apt-get install -y \
       curl \
       wget \
       git \
       zip \
       unzip \
       dos2unix

############################################################################
# Install AWS-CLI
# https://stackoverflow.com/questions/46038891/how-to-install-awscli-using-pip-in-library-node-docker-image
############################################################################
#RUN apt-get install -y unzip
#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#        && unzip awscliv2.zip \
#        && ./aws/install \
#        && rm awscliv2.zip \
#        && rm -rf ./aws
#RUN apt-get remove -y unzip

############################################################################
# Install Internationalization
############################################################################
RUN apt-get -y update && apt-get install -y libicu-dev \
  && docker-php-ext-install intl && docker-php-ext-configure intl

############################################################################
# Install MySQL PDO
############################################################################
RUN docker-php-ext-install pdo pdo_mysql && docker-php-ext-configure pdo_mysql

############################################################################
# Install MySQLi
############################################################################
#RUN docker-php-ext-install mysqli && docker-php-ext-configure mysqli

############################################################################
# Install SOAP
#############################################################################
#RUN apt-get -y update && apt-get install -y libxml2-dev \
#  && docker-php-ext-install soap && docker-php-ext-configure soap

############################################################################
# Install GD
############################################################################
#RUN apt-get update -y && apt-get install -y libwebp-dev libjpeg62-turbo-dev \
#    libpng-dev libxpm-dev libfreetype6-dev \
#  && docker-php-ext-install gd && docker-php-ext-configure gd

############################################################################
# Install ZIP
############################################################################
#RUN apt-get update -y && apt-get install -y libzip-dev zip \
#    && docker-php-ext-install zip && docker-php-ext-configure zip

############################################################################
# Install Session
############################################################################
#RUN docker-php-ext-install session && docker-php-ext-configure session

############################################################################
# Install Redis
############################################################################
#RUN pecl install redis && docker-php-ext-enable redis

############################################################################
# Install LDAP
############################################################################
#RUN apt-get -y update && apt-get install libldap2-dev -y \
#    && apt-get install -y libldap-common \
#    && apt-get install -y ldap-utils \
#    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && docker-php-ext-install ldap

############################################################################
# Install XSL
############################################################################
#RUN apt-get -y update && apt-get install -y libxslt-dev \
#    && docker-php-ext-install xsl && docker-php-ext-configure xsl

############################################################################
# Install XML
############################################################################
#RUN apt-get -y update && apt-get install -y libxml2-dev \
#    && docker-php-ext-install xml && docker-php-ext-configure xml

############################################################################
# Install XMLRPC
# TODO: Broken
############################################################################
#RUN apt-get -y update && apt-get install -y libxmlrpc-epi-dev
#RUN docker-php-ext-install xmlrpc && docker-php-ext-configure xmlrpc

############################################################################
# Install XMLWriter
# TODO: Broken
############################################################################
#RUN apt-get -y update && apt-get install -y libxmlwriter-dev
#RUN docker-php-ext-install xmlwriter && docker-php-ext-configure xmlwriter

############################################################################
# Install XMLReader
# TODO: Broken
############################################################################
#RUN apt-get -y update && apt-get install -y libxmlreader-dev
#RUN docker-php-ext-install xmlreader && docker-php-ext-configure xmlreader

############################################################################
# Install PHP Composer https://getcomposer.org/download/
# Add "--version=1.10.22" after "php --" to get a specific version.
# Creates a shell wrapper for composer to run without XDebug.
############################################################################
# Turn xDebug off so we dont "debug" during docker build.
RUN export XDEBUG_MODE=off \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer.phar \
    && chmod a+x /usr/local/bin/composer.phar \
    && echo "#!/usr/bin/env bash\n\nXDEBUG_MODE=off /usr/local/bin/composer.phar \$@" > /usr/local/bin/composer \
    && chmod a+x /usr/local/bin/composer




FROM php8base AS php8dev
############################################################################
# This is the PHP 8 development docker image.
# It is based on the php8base image and includes additional
# development tools and configurations.
# This image is used for local development and testing.
# It includes XDebug for debugging and development aids.
# It is not intended for production use.
# The php8prodcution image should be used for production.
################################################################################


############################################################################
# Setup XDebug https://xdebug.org/download/historical
# xdebug-x.x.x for specific version
############################################################################
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

############################################################################
# Create proper security higene for enviornemnt.
# Manage SSH keys https://medium.com/trabe/use-your-local-ssh-keys-inside-a-docker-contaieragener-ea1d117515dc
############################################################################
#ENV GIT_SSL_NO_VERIFY="1"
RUN useradd -m user \
    && mkdir -p /home/user/.ssh \
#    && ssh-keyscan github.com >> /home/user/.ssh/known_hosts \
#    && echo "Host *\n\tStrictHostKeyChecking no\n" >> /home/user/.ssh/config \
    && chown -R user:user /home/user/.ssh \
    && echo "password\npassword" | passwd root

############################################################################
# Install MySQL client
############################################################################
RUN apt-get install -y default-mysql-client
RUN echo "alias mysql='mysql --user=root'\n" >> /home/user/.bashrc

#############################################################################
# Install Apicize
#############################################################################
# RUN wget https://github.com/apicize/cli/releases/download/apicize-cli-v0.21.3/Apicize-run_0.21.3_amd64.deb
# RUN apt install ./Apicize-run_0.21.3_amd64.deb
# RUN rm -f Apicize-run_0.21.3_amd64.deb



USER user
WORKDIR /app
CMD ["/bin/bash"]
# Add our script files to the path so they can be found
ENV PATH /app/bin:$PATH

############################################################################
# Install laravel installer
############################################################################
# RUN composer global require laravel/installer

############################################################################
# Setup Default XDebug CLI settings
############################################################################
# XDebug mode, this will override the xdebug.ini settings for the container.
# off - Nothing is enabled. XDebug does no work besides checking whether functionality is enabled. Use this setting if you want close to 0 overhead.
# develop - Enables Development Aids including the overloaded var_dump().
# coverage - Enables Code Coverage Analysis to generate code coverage reports, mainly in combination with PhpUnit.  Will slow down execution conciderably.
# debug - Enables Step Debugging. This can be used to step through your code while it is running, and analyze values of variables.
# gcstats - Enables Garbage Collection Statistics to collect statistics about PHP's Garbage Collection Mechanism.
# profile - Enables Profiling, with which you can analyze performance bottlenecks with tools like KCacheGrind.
# trace - Enables the Function Trace feature, which allows you to record every function call, including arguments, variable assignment, and return value that is made during a request to a file.
#ENV XDEBUG_MODE debug,develop,coverage
ENV PHP_IDE_CONFIG="serverName=PHPSTORM"
# Uncomment the line below to start XDebug on every request.
#ENV XDEBUG_TRIGGER="PHPSTORM"


############################################################################
# Create aliases and set prompt for CLI
############################################################################
RUN echo "alias debug='export XDEBUG_MODE=debug,develop,coverage'" >> /home/user/.bashrc \
    && echo "alias coverage='export XDEBUG_MODE=coverage'" >> /home/user/.bashrc \
    && echo "alias debug_off='export XDEBUG_MODE=off'" >> /home/user/.bashrc \
    && echo "alias profile='export XDEBUG_MODE=profile'" >> /home/user/.bashrc \
    && echo "alias debug_all='export XDEBUG_MODE=debug,develop,gcstats,profile,trace'" >> /home/user/.bashrc \
    && echo "alias phpunit='XDEBUG_MODE=debug,develop,coverage; phpunit'" >> /home/user/.bashrc \
    && echo "export PS1=\"\u@\h (PHP \$(php -v | head -n 1 | cut -d ' ' -f 2) XDebug: \\\$XDEBUG_MODE)) \w\$ \"" >> /home/user/.bashrc

# Add our script files to the path so they can be found
ENV PATH /app/vendor/bin:/var/www/vendor/bin:~/bin:~/.composer/vendor/bin:$PATH

############################################################################
# Install Codeception native
############################################################################
#RUN mkdir -p ~/bin \
#    && curl -LsS https://codeception.com/codecept.phar -o ~/bin/codecept \
#    && chmod u+x ~/bin/codecept \
#    && echo "alias codecept='XDEBUG_MODE=off ~/bin/codecept'" >> /home/user/.bashrc

#############################################################################
# Install PHPUnit native
#############################################################################
#RUN mkdir -p ~/bin \
#    && wget -O ~/bin/phpunit https://phar.phpunit.de/phpunit-12.phar \
#    && chmod u+x ~/bin/phpunit


FROM php8dev AS test

RUN mkdir -p /home/user/bin
COPY ./self-test.sh /home/user/bin/self-test.bash
# RUN dos2unix /home/user/bin/self-test.bash

ENTRYPOINT ["bash","/home/user/bin/self-test.bash"]

############################################################################
# Copy development ini file
############################################################################
COPY config/docker/php.ini-development /usr/local/etc/php/php.ini


WORKDIR /app

############################################################################
# Copy the source files into the container.
############################################################################
#COPY ./app /var/www


############################################################################
# If the composer.json file is present, install the dependencies.
# This is done in the production image to ensure that the dependencies
# are installed in the production environment.
############################################################################
#RUN if [ -f /var/www/composer.json ]; then \
#        echo "Installing composer dependencies..."; \
#        rm -fr /var/www/vendor \
#        cd /var/www \
#        composer install \
#    else \
#        echo "No composer.json file found, skipping composer install."; \
#    fi
#
## run test script
#RUN if [ -f ./test_to_run.sh ]; then \
#        echo "\n\n\n ################## Running test script... ################\n\n"; \
#        chmod +x ./test_to_run.sh \
#        && ./test_to_run.sh \
#    else \
#        echo "No test script found, skipping test script."; \
#    fi

# Host the test results



FROM php8base AS php8prod
############################################################################
# This is the PHP 8 production docker image.
# It is based on the php8base image and includes additional
# production tools and configurations.
# This image is used for production deployments.
# It does not include XDebug or any development tools.
# The php8dev image should be used for development.
############################################################################

############################################################################
# Copy production ini file
############################################################################
COPY config/docker/php.ini-production /usr/local/etc/php/php.ini

############################################################################
# Copy the source files into the container.
############################################################################
COPY ./app /var/www

WORKDIR /var/www

############################################################################
# If the composer.json file is present, install the dependencies.
# This is done in the production image to ensure that the dependencies
# are installed in the production environment.
############################################################################
RUN if [ -f /var/www/composer.json ]; then \
        echo "Installing composer dependencies..."; \
        rm -fr /var/www/vendor; \
        cd /var/www; \
        composer install -n --no-dev --optimize-autoloader; \
    else \
        echo "No composer.json file found, skipping composer install."; \
    fi

############################################################################
# Link html to public
############################################################################
RUN rm -fr html
RUN ln -s /var/www/public /var/www/html

############################################################################
# Set permissions for the storage directory
############################################################################
#RUN chown -Rf root:root /var/www/storage | true \
#    && chmod -Rf 777 /var/www/storage | true

############################################################################
# Remove unneeded files
############################################################################



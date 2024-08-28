# For PHP 7.2-7.4 use this file
FROM php:7

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
# Install AWS-CLI
# https://stackoverflow.com/questions/46038891/how-to-install-awscli-using-pip-in-library-node-docker-image
############################################################################
#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#        && unzip awscliv2.zip \
#        && ./aws/install \
#        && rm awscliv2.zip \
#        && rm -rf ./aws

############################################################################
# Install Internationalization
############################################################################
RUN apt-get -y update && apt-get install -y libicu-dev
RUN docker-php-ext-install intl && docker-php-ext-configure intl

############################################################################
# Install SOAP
############################################################################
#RUN apt-get -y update && apt-get install -y libxml2-dev
#RUN docker-php-ext-install soap && docker-php-ext-configure soap

############################################################################
# Install GD
############################################################################
#RUN apt-get update -y && apt-get install -y libwebp-dev libjpeg62-turbo-dev \
#    libpng-dev libxpm-dev libfreetype6-dev
#RUN docker-php-ext-install gd && docker-php-ext-configure gd

############################################################################
# Install ZIP
#############################################################################
#RUN apt-get update -y && apt-get install -y libzip-dev zip
#RUN docker-php-ext-install zip && docker-php-ext-configure zip

############################################################################
# Install MySQL PDO
############################################################################
RUN docker-php-ext-install pdo pdo_mysql && docker-php-ext-configure pdo_mysql

############################################################################
# Install MySQLi
############################################################################
#RUN docker-php-ext-install mysqli && docker-php-ext-configure mysqli

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
#    && apt-get install -y ldap-utils
#RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && docker-php-ext-install ldap


############################################################################
# Setup XDebug https://xdebug.org/download/historical
# xdebug-x.x.x for specific version
# xdebug for PHP 8.0 and nerwer
# xdebug-3.1.5 for PHP 7.2-7.4
# xdebug-2.6.1 for PHP 7.0-7.1
# xdebug-2.5.5 for PHP 5.x
# NOTE: You will need to chage the mapped file `xdebug.ini` in the
#       docker-compose.yml to match your xdebug version.  See the README.md
#       file for details.
############################################################################
RUN pecl install xdebug-3.1.5 \
    && docker-php-ext-enable xdebug

# Copy the xdebug.ini file to the container.
COPY ./.docker/php.development.dockerfiles/configs/conf.d/xdebug_3.x.x.ini /usr/local/etc/php/conf.d/xdebug.ini

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

USER user
WORKDIR /app
CMD ["/bin/bash"]
# Add our script files to the path so they can be found
ENV PATH /app/bin:$PATH

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
ENV XDEBUG_MODE debug,develop,coverage


############################################################################
# Create aliases and set prompt for CLI
############################################################################
RUN echo "alias debug='export XDEBUG_MODE=debug,develop'" >> /home/user/.bashrc \
    && echo "alias coverage='export XDEBUG_MODE=coverage'" >> /home/user/.bashrc \
    && echo "alias debug_off='export XDEBUG_MODE=off'" >> /home/user/.bashrc \
    && echo "alias phpunit='XDEBUG_MODE=debug,develop,coverage; phpunit'" >> /home/user/.bashrc \
    && echo "export PS1=\"\u@\h (PHP \$(php -v | head -n 1 | cut -d ' ' -f 2) XDebug: \\\$XDEBUG_MODE)) \w\$ \"" >> /home/user/.bashrc

############################################################################
# Copy the php.ini file to the container.
############################################################################
COPY ./.docker/php.development.dockerfiles/configs/php.ini /usr/local/etc/php/php.ini

############################################################################
# Install PHP Composer https://getcomposer.org/download/
# Add "--version=1.10.22" after "php --" to get a specific version.
# Creates a shell wrapper for composer to run without XDebug.
# This is needed for PhpStorm to run Composer directly.
############################################################################
RUN cd ~ \
    && export XDEBUG_MODE=off \
    && mkdir ~/bin \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=$HOME/bin --filename=composer.phar \
    && chmod u+x ~/bin/composer.phar \
    && echo "#!/usr/bin/env bash\n\nXDEBUG_MODE=off ~/bin/composer.phar \$@" > ~/bin/composer \
    && chmod u+x ~/bin/composer

# Add our script files to the path so they can be found
ENV PATH /app/vendor/bin:/var/www/vendor/bin:~/bin:~/.composer/vendor/bin:$PATH

############################################################################
# Install Codeception native
############################################################################
#RUN curl -LsS https://codeception.com/codecept.phar -o ~/bin/codecept \
#    && export XDEBUG_MODE=off \
#    && chmod u+x ~/bin/codecept \
#    && echo "alias codecept='XDEBUG_MODE=off ~/bin/codecept'" >> /home/user/.bashrc

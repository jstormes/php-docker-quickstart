FROM php:5

############################################################################
# Install system commands and libraries
############################################################################
#RUN sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
#RUN apt-get -y update
#RUN apt-get -y upgrade
#RUN apt-get install -y curl
#RUN apt-get install -y wget
#RUN apt-get install -y git
#RUN apt-get isntall -y zip
#RUN apt-get install -y unzip


############################################################################
# Install Internationalization
############################################################################
#RUN apt-get -y update \
#&& apt-get install -y libicu-dev \
#&& docker-php-ext-configure intl \
#&& docker-php-ext-install intl

############################################################################
# Copy the php.ini file to the container.
############################################################################
#COPY ./.docker/php.development.dockerfiles/configs/php.ini /usr/local/etc/php/php.ini

############################################################################
# Setup XDebug https://xdebug.org/download/historical
# xdebug-x.x.x for specific version
# Last PHP 5 XDebug version is 2.5.5
############################################################################
RUN pecl install xdebug-2.5.5 \
    && docker-php-ext-enable xdebug

############################################################################
# Create proper security higene for enviornemnt.
# Manage SSH keys https://medium.com/trabe/use-your-local-ssh-keys-inside-a-docker-container-ea1d117515dc
############################################################################
#ENV GIT_SSL_NO_VERIFY="1"
RUN useradd -m user \
    && mkdir -p /home/user/.ssh \
#    && ssh-keyscan github.com >> /home/user/.ssh/known_hosts \
#    && echo "Host *\n\tStrictHostKeyChecking no\n" >> /home/user/.ssh/config \
    && chown -R user:user /home/user/.ssh \
    && echo "naked\nnaked" | passwd root


USER user
WORKDIR /app
# Add our script files to the path so they can be found
ENV PATH /app/bin:$PATH
CMD ["/bin/bash"]

############################################################################
# Create aliases and set prompt
############################################################################
RUN echo "alias mysql='mysql --user=root'\n" >> /home/user/.bashrc \
    && echo "alias debug='export XDEBUG_CONFIG=remote_enable=on'" >> /home/user/.bashrc \
    && echo "alias debug_off='export XDEBUG_CONFIG=remote_enable=off'" >> /home/user/.bashrc \
    && echo "export PS1=\"\u@\h (PHP \$(php -v | head -n 1 | cut -d ' ' -f 2) XDebug: \\\$XDEBUG_CONFIG)) \w\$ \"" >> /home/user/.bashrc

############################################################################
# Setup Default XDebug settings
############################################################################
# This is for PHP 5.x and <7.1.
COPY ./.docker/php.development.dockerfiles/configs/conf.d/xdebug_2.x.x.ini /usr/local/etc/php/conf.d/xdebug.ini
# If you don't turn this off here it will try and debug during the composer install.
#ENV XDEBUG_CONFIG "remote_enable=off"

############################################################################
# Install PHP Composer https://getcomposer.org/download/
# Add "--version=1.10.22" after "php --" to get a specific version.
############################################################################
RUN cd ~ \
    && export XDEBUG_CONFIG=remote_enable=off \
    && mkdir bin \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer.phar \
    && chmod u+x ~/bin/composer.phar \
    && echo "#!/usr/bin/env bash\n\nXDEBUG_CONFIG=remote_enable=off ~/bin/composer.phar \$@" > ~/bin/composer \
    && chmod u+x ~/bin/composer

# Add our script files to the path so they can be found
ENV PATH /app/vendor/bin:/var/www/vendor/bin:~/bin:~/.composer/vendor/bin:$PATH:


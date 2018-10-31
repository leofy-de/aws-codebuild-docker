#############################
#
# Docker image to build PHP and JS projects using composer and npm/yarn
#
#############################

FROM php:7.2

MAINTAINER Sebastian Buckpesch <sebastian@buckpesch.io>

ARG composer_checksum=55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30
ARG composer_url=https://raw.githubusercontent.com/composer/getcomposer.org/ba0141a67b9bd1733409b71c28973f7901db201d/web/installer

# Set environment variables
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH=$PATH:vendor/bin

# Install Ubuntu packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        libcurl4-openssl-dev \
        libicu-dev \
        libmcrypt-dev \
        libmysqlclient-dev \
        libpng-dev \
        mysql-client \
        ruby \
        software-properties-common \
        zip
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y \
        nodejs \
        yarn \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      curl \
      gd \
      zip \
    && curl -o installer "$composer_url" \
    && echo "$composer_checksum *installer" | shasum –c –a 384 \
    && php installer --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /var/lib/apt/lists/*

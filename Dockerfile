#############################
# Docker image to build PHP and JS projects using composer and npm/yarn
#############################

FROM php:7.2

MAINTAINER Sebastian Buckpesch <sebastian@buckpesch.io>

# Set environment variables
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH=$PATH:vendor/bin

# Install Ubuntu packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        gnupg \
        libcurl4-openssl-dev \
        libpng-dev \
        curl \
        git \
        python-dev \
        python-pip \
        zlib1g-dev \
        ruby \
        software-properties-common \
        zip \
    && pip install --upgrade setuptools \
    && pip install awscli \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y \
        nodejs \
        yarn \
    && docker-php-ext-install \
      curl \
      gd \
      zip \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && yarn global add bower webpack requirejs \
    && mkdir /run/php \
    && apt-get remove -y --purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

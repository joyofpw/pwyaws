# - ref: https://hub.docker.com/r/lfex/yaws
# - ref: https://github.com/lfex/dockerfiles/tree/main/common
# - ref: https://dev.to/jackmiras/laravel-with-php7-4-in-an-alpine-container-3jk6#dockerfile
# - note: Needs Erlang 22 or newer.
# - note: Erlang 26 or newer does not work (some deprecated functions used by yaws). check erlyaws/yaws/issues/467
FROM erlang:22-alpine

RUN apk update && apk upgrade
RUN apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        g++ \
        gawk \
        gcc \
        libtool \
        linux-pam-dev \
        make \
        git \
    && git clone https://github.com/erlyaws/yaws.git /yaws-src \
    && cd /yaws-src \
    && autoreconf -fi \
    && ./configure --localstatedir=/var --sysconfdir=/etc \
    && make && make install \
    && cd /var \
    && rm -rf /yaws-src \
    && apk del .build-deps


# Essentials
RUN echo "UTC" > /etc/timezone
RUN apk add --no-cache zip unzip curl sqlite

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing PHP
RUN apk add --no-cache php-cgi \
    php-common \
    php-fpm \
    php-pdo \
    php-gd \
    php-opcache \
    php-zip \
    php-phar \
    php-iconv \
    php-cli \
    php-curl \
    php-openssl \
    php-mbstring \
    php-tokenizer \
    php-fileinfo \
    php-json \
    php-xml \
    php-xmlwriter \
    php-simplexml \
    php-dom \
    php-pdo_mysql \
    php-pdo_sqlite \
    php-tokenizer

ENV ERLANG_HOME /usr/local/lib/erlang
ENV YAWS_HOME ${ERLANG_HOME}/lib/yaws-2.1.1/
ENV YAWS_INCLUDE $YAWS_HOME/include
ENV YAWS_CONF /usr/local/etc/yaws
ENV PATH $PATH:$YAWS_HOME/bin

## Compile Config
COPY yaws $YAWS_CONF
WORKDIR $YAWS_CONF/appmods
RUN erlc processwire.erl


ENTRYPOINT [ "yaws", "-i", "--conf", "/usr/local/etc/yaws/yaws.conf" ]

#CMD yaws -i


#
#FROM erlang:23
#
## YAWS Setup
#
#RUN apt-get update -y && \
#    apt-get install -y build-essential curl git libpam0g libpam0g-dev dh-autoreconf unzip
#
#ENV ERLANG_HOME /opt/erlang
#ENV YAWS_HOME $ERLANG_HOME/yaws
#ENV YAWS_CONF /usr/local/etc/yaws
#ENV WWW /var/www
#ENV PATH $PATH:$YAWS_HOME/bin
#
#RUN git clone https://github.com/erlyaws/yaws.git $YAWS_HOME
#
#WORKDIR $YAWS_HOME
#
## Using rebar3 yaws branch installation method
#
#RUN mkdir log && \
#    rebar3 compile && \
#    autoreconf -fi > /dev/null && \
#    ./configure > /dev/null && \
#    make > /dev/null
#
#
## YAWS Config Files
#COPY yaws $YAWS_CONF
#
## Compile Config
#WORKDIR $YAWS_CONF/appmods
#RUN erlc processwire.erl
#
#WORKDIR $YAWS_HOME
#
## Install PHP
#
#RUN apt install --yes apt-transport-https lsb-release ca-certificates software-properties-common
#RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
#RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
#RUN apt update
#
#RUN apt-get install -y \
#        php8.2-cli \
#        php8.2-cgi \
#        locales locales-all \
#        libpq-dev \
#        libzip-dev \
#        libicu-dev \
#        libfreetype6-dev \
#        libjpeg62-turbo-dev \
#        libpng-dev \
#        libwebp-dev \
#        php8.2-zip \
#        php8.2-mysql \
#        php8.2-bz2 \
#        php8.2-curl \
#        php8.2-mbstring \
#        php8.2-intl \
#        php8.2-common \
#        php8.2-gd \
#        php8.2-pdo
#
## Enable PHP Extensions
## Change Settings if Needed
#ENV PHP_CONF /etc/php/8.2/cgi
#
#ENTRYPOINT [ "yaws", "--daemon", "--heart", "--conf", "/usr/local/etc/yaws/yaws.conf" ]

# - ref: https://github.com/segeda/docker-yaws
# - ref: https://hub.docker.com/r/lfex/yaws
# - ref: https://github.com/lfex/dockerfiles/tree/main/common
# - ref: https://dev.to/jackmiras/laravel-with-php7-4-in-an-alpine-container-3jk6#dockerfile
# - note: Needs Erlang 22 or newer.
# - note: Erlang 26 or newer does not work (some deprecated functions used by yaws). check erlyaws/yaws/issues/467
FROM erlang:22-alpine

RUN apk update && apk upgrade

# Install YAWS
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


# Install Essentials
RUN echo "UTC" > /etc/timezone
RUN apk add --no-cache zip unzip curl sqlite

# Install bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Install PHP
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
    php-tokenizer \
    php-mysqli \
    php-session \
    php-ctype

# Set ENV
ENV ERLANG_HOME /usr/local/lib/erlang
ENV YAWS_HOME ${ERLANG_HOME}/lib/yaws-2.1.1/
ENV YAWS_INCLUDE $YAWS_HOME/include
ENV YAWS_CONF /usr/local/etc/yaws
ENV PATH $PATH:$YAWS_HOME/bin

# Compile YAWS Config
COPY yaws $YAWS_CONF
WORKDIR $YAWS_CONF/appmods
RUN erlc processwire.erl

# Entrypoint
ENTRYPOINT [ "yaws", "-i", "--conf", "/usr/local/etc/yaws/yaws.conf" ]

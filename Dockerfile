FROM php:8.2.11-fpm-alpine3.18

RUN apk add --update linux-headers

RUN apk --no-cache add \
  curl \
  nginx \
  git \
  bash \
  openssh \
  build-base \
  autoconf \
  supervisor \
  libxml2-dev

RUN pecl install redis mysqli && \
    docker-php-ext-install mysqli pdo_mysql opcache mysqli && \
    docker-php-ext-enable redis pdo_mysql opcache mysqli && \
    apk del --purge autoconf build-base

RUN git config --global user.email "ngon@ngon.info"
RUN git config --global user.name "Tran Trung Ngon"

ENV LANG C.UTF-8

# Set which kind of environment we want to use (can be setup in BUILD time)

#COPY all required files
COPY ./docker/production/nginx/conf.d/* /etc/nginx/conf.d/
COPY ./docker/production/nginx/nginx.conf /etc/nginx/
COPY ./docker/production/php/conf.d/* /usr/local/etc/php/conf.d/
COPY ./docker/production/php/php-fpm.d/* /usr/local/etc/php-fpm.d/
COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/entrypoint.sh /
COPY docker/cmd.sh /

RUN chmod +x /entrypoint.sh
EXPOSE 80
#EXPOSE 9000

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir /code
WORKDIR /code

EXPOSE 80

# supervisord conf and startup
CMD ["/bin/bash", "/cmd.sh"]
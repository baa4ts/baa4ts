# Usa una imagen base de PHP con FPM y Alpine para un tamaño de imagen más pequeño
FROM php:8.3-fpm-alpine

# Actualiza los repositorios de paquetes e instala las dependencias del sistema necesarias
RUN apk update && apk add --no-cache \
    build-base \
    autoconf \
    bzip2-dev \
    libbz2 \
    curl-dev \
    libxml2-dev \
    libzip-dev \
    postgresql-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    gettext-dev \
    libxslt-dev \
    libtool \
    libffi-dev \
    openssl-dev \
    llvm18-libs \
    php-dev

# Clean up the apk cache to reduce image size
RUN rm -rf /var/cache/apk/*

# Install and configure PHP extensions -  Separated for debugging
RUN set -eux; \
    pecl install --force bcmath \
    && docker-php-ext-enable bcmath

RUN set -eux; \
    pecl install --force bz2 \
    && docker-php-ext-configure bz2 \
    && docker-php-ext-install -j$(nproc) bz2 \
    && docker-php-ext-enable bz2

RUN set -eux; \
    pecl install --force calendar \
    && docker-php-ext-enable calendar

RUN set -eux; \
    docker-php-ext-install -j$(nproc) ctype

RUN set -eux; \
    pecl install --force curl \
    && docker-php-ext-configure curl \
    && docker-php-ext-install -j$(nproc) curl \
    && docker-php-ext-enable curl

RUN set -eux; \
    pecl install --force dba \
    && docker-php-ext-enable dba

RUN set -eux; \
    docker-php-ext-install -j$(nproc) dom

RUN set -eux; \
    pecl install --force exif \
    && docker-php-ext-configure exif \
    && docker-php-ext-install -j$(nproc) exif \
    && docker-php-ext-enable exif

RUN set -eux; \
    docker-php-ext-install -j$(nproc) fileinfo

RUN set -eux; \
    docker-php-ext-install -j$(nproc) filter

RUN set -eux; \
    pecl install --force ftp \
    && docker-php-ext-enable ftp

RUN set -eux; \
    pecl install --force gettext \
    && docker-php-ext-configure gettext \
    && docker-php-ext-install -j$(nproc) gettext \
    && docker-php-ext-enable gettext

RUN set -eux; \
    docker-php-ext-install -j$(nproc) hash

RUN set -eux; \
    pecl install --force iconv \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-enable iconv

RUN set -eux; \
    docker-php-ext-install -j$(nproc) json

RUN set -eux; \
    docker-php-ext-install -j$(nproc) mbstring

RUN set -eux; \
    docker-php-ext-install -j$(nproc) mysqli

RUN set -eux; \
    pecl install --force openssl \
    && docker-php-ext-configure openssl \
    && docker-php-ext-install -j$(nproc) openssl \
    && docker-php-ext-enable openssl

RUN set -eux; \
    docker-php-ext-install -j$(nproc) pcntl

RUN set -eux; \
    docker-php-ext-install -j$(nproc) pdo_mysql

RUN set -eux; \
    docker-php-ext-install -j$(nproc) pdo

RUN set -eux; \
    pecl install --force phar \
    && docker-php-ext-enable phar

RUN set -eux; \
    docker-php-ext-install -j$(nproc) posix

RUN set -eux; \
    docker-php-ext-install -j$(nproc) readline

RUN set -eux; \
    docker-php-ext-install -j$(nproc) session

RUN set -eux; \
    docker-php-ext-install -j$(nproc) shmop

RUN set -eux; \
    docker-php-ext-install -j$(nproc) sockets

RUN set -eux; \
    pecl install --force sodium \
    && docker-php-ext-configure sodium \
    && docker-php-ext-install -j$(nproc) sodium \
    && docker-php-ext-enable sodium

RUN set -eux; \
    docker-php-ext-install -j$(nproc) sysvmsg

RUN set -eux; \
    docker-php-ext-install -j$(nproc) sysvsem

RUN set -eux; \
    docker-php-ext-install -j$(nproc) sysvshm

RUN set -eux; \
    docker-php-ext-install -j$(nproc) tokenizer

RUN set -eux; \
    docker-php-ext-install -j$(nproc) xml

RUN set -eux; \
    docker-php-ext-install -j$(nproc) xmlreader

RUN set -eux; \
    docker-php-ext-install -j$(nproc) xmlwriter

RUN set -eux; \
    pecl install --force xsl \
    && docker-php-ext-configure xsl \
    && docker-php-ext-install -j$(nproc) xsl \
    && docker-php-ext-enable xsl

RUN set -eux; \
    docker-php-ext-install -j$(nproc) zip

RUN set -eux; \
    docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable opcache

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /var/www/html

# Copia los archivos de tu aplicación PHP al contenedor
COPY . /var/www/html

# Expone el puerto 9000 para que FPM pueda recibir conexiones
EXPOSE 9000

# Comando para ejecutar PHP-FPM al iniciar el contenedor
CMD ["php-fpm", "-F"]

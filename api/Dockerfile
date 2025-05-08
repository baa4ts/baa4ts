FROM php:8.3.8-apache

# Notas
# xmlrpc: deprecated
# Geoip: deprecated

# Instalar dependencias de sistema, construir extensiones y limpiar cache en una sola capa
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    g++ zlib1g-dev make autoconf libc-dev pkg-config libzip-dev \
    libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev \
    libxslt-dev libcurl4-openssl-dev libpq-dev libldap2-dev \
    libsqlite3-dev libbz2-dev libgmp-dev libwebp-dev libicu-dev \
    libc-client-dev libkrb5-dev libsodium-dev libedit-dev \
    libbrotli-dev uuid-dev \
    && docker-php-ext-install \
    bcmath bz2 calendar exif ftp gettext intl mysqli opcache \
    pdo_mysql pdo_sqlite soap sockets xsl zip \
    # !!!!!
    # Extensión IMAP (opcional)
    # !!!!! Descomenatar las 2 siguientes lineas para activar imap
    # && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    # && docker-php-ext-install imap \
    # !!!!!
    && pecl install \
    apcu brotli ds igbinary msgpack redis uuid \
    # !!!!! Descomenatar las 2 siguientes lineas para activar mongodb, grpc
    # mongodb \
    # grpc \
    # !!!!!
    && docker-php-ext-enable \
    apcu brotli ds igbinary msgpack redis uuid \
    # !!!!! Descomenatar las 2 siguientes lineas para activar mongodb, grpc
    # mongodb grpc \
    # !!!!!
    && apt-get purge -y --auto-remove g++ make autoconf pkg-config libc-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/pear
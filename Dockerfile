
FROM debian:jessie

LABEL maintainer "Rafa Couto <caligari@treboada.net>"

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" \
        >> /etc/apt/sources.list.d/jessie-backports.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends \
        -t jessie-backports certbot \
    && rm -rf /var/lib/apt/lists/*

ADD hooks /etc/letsencrypt/hooks

RUN echo 'webroot-path = /var/www/html' > /etc/letsencrypt/cli.ini \
    && chmod +x /etc/letsencrypt/hooks/*

# default command
CMD certbot renew --post-hook "/etc/letsencrypt/hooks/post-hook"

# webroot to share with nginx container
VOLUME /var/www/html

# configuration
VOLUME /etc/letsencrypt


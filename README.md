
# docker-letsencrypt

[![Docker Stars](https://img.shields.io/docker/stars/caligari/letsencrypt.svg)](https://hub.docker.com/r/caligari/letsencrypt/)
[![Docker Pulls](https://img.shields.io/docker/pulls/caligari/letsencrypt.svg)](https://hub.docker.com/r/caligari/letsencrypt/)
[![Docker Build](https://img.shields.io/docker/automated/caligari/letsencrypt.svg)](https://hub.docker.com/r/caligari/letsencrypt/)

Docker image to run [Letsencrypt](https://letsencrypt.org/) certbot command 
and sharing resources with nginx.

## Get the docker image

### Pull a pre-built image

    docker pull caligari/letsencrypt:latest

Available [image tags here](https://hub.docker.com/r/caligari/letsencrypt/tags/).


### From Dockerfile

    git clone git@github.com:rafacouto/docker-letsencrypt.git
    docker build -t caligari/letsencrypt:latest ./docker-letsencrypt


## Prepare the connection with your web proxy

You need to setup the proxy server on your host to redirect _/.well-known_
location requests to serve the directory where letsencrypt generate its
verification files required by the CA.

This is my _letsencrypt.conf_ with Nginx:

    server {

        listen 80;
        server_name *;

        location /.well-known {
            root /var/www/letsencrypt;
            try_files $uri =404;
        }
    }

This is my _docker-compose.yml_ to run the Nginx server:

    version: '2'

    services:
      web:
        image: 'nginx:latest'
        restart: 'always'
        ports:
          - '80:80'
          - '443:443'
        volumes:
          - './config:/etc/nginx:ro'
          - './letsencrypt/webroot:/var/www/letsencrypt:ro'
          - './letsencrypt/conf:/usr/local/letsencrypt:ro'


## Usage

    docker run --rm \
        -v $(pwd)/letsencrypt/webroot:/var/www/html \
        -v $(pwd)/letsencrypt/conf:/etc/letsencrypt \
        -ti caligari/letsencrypt \
        /bin/bash

And you can generate new certificates with certbot command:

    certbot certonly -d mydomain.com



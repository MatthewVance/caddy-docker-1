FROM alpine:3.4
MAINTAINER Abiola Ibrahim <abiola89@gmail.com>

LABEL caddy_version="0.9.1" architecture="amd64"

ARG plugins=git,ipfilter

RUN apk add --update --no-cache --virtual .build-deps openssh-client git tar curl \
 && curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=${plugins}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && apk del .build-deps \
 && /usr/bin/caddy -version

EXPOSE 80 443 2015
WORKDIR /srv

ADD Caddyfile /etc/Caddyfile
ADD index.html /srv/index.html

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]

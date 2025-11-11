# syntax=docker/dockerfile:1.7.0

FROM caddy:2.8-alpine

COPY ./caddy/Caddyfile /etc/caddy/Caddyfile

VOLUME /var/www

EXPOSE 80
EXPOSE 443

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]

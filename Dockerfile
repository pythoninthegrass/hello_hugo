# syntax=docker/dockerfile:1.7.0

FROM nginx:1.27.0-alpine-slim

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/ssl.conf /etc/nginx/global/ssl.conf
COPY ./nginx/conf.d/*.conf /etc/nginx/conf.d/

VOLUME /var/www

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

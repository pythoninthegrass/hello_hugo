# syntax=docker/dockerfile:1.7.0

FROM nginx:1.27.0-alpine-slim

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

VOLUME /var/www

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

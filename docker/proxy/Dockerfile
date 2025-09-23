FROM nginx:alpine

COPY /src/public /usr/share/nginx/html
COPY /docker/proxy/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
FROM openresty/openresty:latest

WORKDIR /app

COPY . .

EXPOSE 9000

CMD ["openresty", "-p", "/app", "-c", "/app/nginx.conf", "-g", "daemon off;"]

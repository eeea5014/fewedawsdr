FROM openresty/openresty:latest

WORKDIR /app

COPY . .

EXPOSE 9000

CMD ["resty", "d127e1a304605558.lua"]

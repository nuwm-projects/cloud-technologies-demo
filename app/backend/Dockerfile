FROM ubuntu:jammy

RUN adduser app

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y php-fpm unzip wget nginx supervisor composer php-dom php-pdo php-mysql php-json php-opcache php-mbstring php-curl

COPY ./src /var/www/app

WORKDIR /var/www/app

RUN composer install

COPY ./configs/var/www/app/.env /var/www/app/.env

RUN chown -R app:app /var/www/app

COPY ./configs/etc/php/8.1/fpm/pool.d/app.conf /etc/php/8.1/fpm/pool.d/app.conf
COPY ./configs/etc/nginx/sites-available/default /etc/nginx/sites-available/default
COPY ./configs/etc/supervisord.conf /etc/supervisord.conf

CMD ["/var/www/app/run.sh"]
EXPOSE 80
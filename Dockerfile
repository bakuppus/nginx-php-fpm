FROM ubuntu:20.04

LABEL maintainer="Mayur Shingrakhiya <mk.shingrakhiya@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

# RUN apt-get update \
#     && apt-get install -y gnupg tzdata \
#     && echo "UTC" ? "/etc/timezone" \
#     && dpkg-reconfigure -f noninteractive tzdata

RUN apt update
RUN apt -y install php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath
RUN apt -y install php7.4
RUN apt -y install nginx php7.4-fpm

RUN apt-get update \
    && apt-get install -y curl zip unzip git supervisor \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

ADD default /etc/nginx/sites-available/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD initial.sh /usr/bin/initial
RUN chmod +x /usr/bin/initial
RUN pkill -f nginx & wait $!
ENTRYPOINT [ "initial" ]

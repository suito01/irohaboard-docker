FROM php:7-fpm

LABEL maintainer "suito01 <suito.y@gmail.com>"

RUN apt-get update && apt-get install -y \
    wget \
    nginx \
    supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql mbstring

RUN mkdir -p /var/www/irohaboard/public_html/ \
    && mkdir -p /var/www/irohaboard/cake/
RUN cd /tmp && wget https://github.com/irohasoft/irohaboard/archive/v0.10.2.tar.gz \
    && tar -zxvf v0.10.2.tar.gz \
    && cd irohaboard-0.10.2 \
    && cp -pr ./Config/ /var/www/irohaboard/public_html/ \
    && cp -pr ./Controller/ /var/www/irohaboard/public_html/ \
    && cp -pr ./Custom/ /var/www/irohaboard/public_html/ \
    && cp -pr ./Model/ /var/www/irohaboard/public_html/ \
    && cp -pr ./Plugin/ /var/www/irohaboard/public_html/ \
    && cp -pr ./Vendor/ /var/www/irohaboard/public_html/ \
    && cp -pr ./View/ /var/www/irohaboard/public_html/ \
    && cp -pr ./webroot/ /var/www/irohaboard/public_html/
RUN cd /tmp && wget https://github.com/cakephp/cakephp/archive/2.10.13.tar.gz \
    && tar -zxvf 2.10.13.tar.gz \
    && cd cakephp-2.10.13/ \
    && cp -pr ./app/ /var/www/irohaboard/cake/ \
    && cp -pr ./lib/ /var/www/irohaboard/cake/ \
    && cp -pr ./plugins/ /var/www/irohaboard/cake/ \
    && cp -pr ./vendors/ /var/www/irohaboard/cake/
RUN rm -rf /tmp/*
RUN chown www-data:www-data -R /var/www/irohaboard/

COPY web/default.conf /etc/nginx/sites-available/default

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN sed -i -e "s/;listen.owner/listen.owner/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -e "s/;listen.group/listen.group/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -e "s/;listen.mode/listen.mode/g" /usr/local/etc/php-fpm.d/www.conf

RUN sed -i -e "s/'host' => 'localhost'/'host' => 'db'/g" /var/www/irohaboard/public_html/Config/database.php \
    && sed -i -e "s/'login' => 'root'/'login' => 'irohaboard'/g" /var/www/irohaboard/public_html/Config/database.php \
    && sed -i -e "s/'password' => ''/'password' => 'irohaboard'/g" /var/www/irohaboard/public_html/Config/database.php 

EXPOSE 80

COPY web/supervisord.conf /etc/supervisord.conf

ENTRYPOINT [ "" ]
CMD ["/usr/bin/supervisord"]

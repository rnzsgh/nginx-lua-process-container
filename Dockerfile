# Dockerfile for openresty
# VERSION   0.0.4

FROM ubuntu:16.04
MAINTAINER Tor Hveem <tor@hveem.no>
ENV REFRESHED_AT 2014-08-08

ENV    DEBIAN_FRONTEND noninteractive
RUN    echo "deb-src http://archive.ubuntu.com/ubuntu xenial main" >> /etc/apt/sources.list
RUN    sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN    apt-get update
RUN    apt-get upgrade -y
RUN    apt-get -y install wget vim git libpq-dev openjdk-8-jdk

# Openresty (Nginx)
RUN    apt-get -y build-dep nginx \
  && apt-get -q -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
RUN    wget https://openresty.org/download/ngx_openresty-1.9.7.2.tar.gz \
  && tar xvfz ngx_openresty-1.9.7.2.tar.gz \
  && cd ngx_openresty-1.9.7.2 \
  && ./configure --with-luajit  --with-http_addition_module --with-http_dav_module --with-http_geoip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_realip_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-http_xslt_module --with-ipv6 --with-http_postgres_module --with-pcre-jit \
  && make \
  && make install \
  && rm -rf /ngx_openresty*

RUN mkdir -p /app/logs

COPY nginx.conf /app
COPY app.lua /app

EXPOSE 8080

CMD /usr/local/openresty/nginx/sbin/nginx -p /app -c /app/nginx.conf


#bench Dockerfile

FROM ubuntu:16.04
MAINTAINER freeyourmind

USER root
RUN apt-get update
RUN apt-get install -y iputils-ping
RUN apt-get install -y git build-essential python-setuptools python-dev libffi-dev libssl-dev
RUN apt-get install -y redis-tools software-properties-common libxrender1 libxext6 xfonts-75dpi xfonts-base
RUN apt-get install -y libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev python-tk apt-transport-https libsasl2-dev libldap2-dev libtiff5-dev tcl8.6-dev tk8.6-dev
RUN apt-get install -y wget
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py
RUN pip install --upgrade setuptools pip
RUN useradd -ms /bin/bash frappe
RUN apt-get install -y curl
RUN apt-get install -y rlwrap
RUN apt-get install -y redis-tools
RUN apt-get install -y nano
RUN apt-get install -y vim 
RUN apt-get install -y sudo 
RUN apt-get install -y supervisor
RUN apt-get install -y nginx
RUN apt-get install -y redis-server
RUN apt-get install -y fontconfig
RUN sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
RUN usermod -aG sudo frappe
RUN printf '# User rules for frappe\nfrappe ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/frappe

# Generate locale C.UTF-8 for mariadb and general locale data
ENV LANG C.UTF-8

#nodejs
RUN apt-get install curl
RUN curl https://deb.nodesource.com/node_6.x/pool/main/n/nodejs/nodejs_6.7.0-1nodesource1~xenial1_amd64.deb > node.deb \
 && dpkg -i node.deb \
 && rm node.deb

ADD wkhtmltox_0.12.5-1.xenial_amd64.deb ./ 
RUN dpkg -i ./wkhtmltox_0.12.5-1.xenial_amd64.deb 

USER frappe
WORKDIR /home/frappe
RUN git clone -b master https://github.com/frappe/bench.git bench-repo

USER root
RUN pip install -e bench-repo
RUN apt-get install -y libmysqlclient-dev mariadb-client mariadb-common
RUN npm install -g yarn
RUN chown -R frappe:frappe /home/frappe/*

USER frappe
WORKDIR /home/frappe/frappe-bench

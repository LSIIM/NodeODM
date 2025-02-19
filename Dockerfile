FROM opendronemap/odm:latest
MAINTAINER Piero Toffanin <pt@masseranolabs.com>

EXPOSE 3000
USER root

# Configura o repositório de pacotes para evitar erros de timeout
RUN echo '\
    Acquire::Retries "1000";\
    Acquire::https::Timeout "2400";\
    Acquire::http::Timeout "2400";\
    APT::Get::Assume-Yes "true";\
    APT::Install-Recommends "false";\
    APT::Install-Suggests "false";\
    Debug::Acquire::https "true";\
    ' > /etc/apt/apt.conf.d/99custom

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

# Instalação de pacotes

RUN apt-get update 
RUN apt-get install -y curl gpg-agent
RUN curl --silent --location https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs unzip p7zip-full && npm install -g nodemon && \
    ln -s /code/SuperBuild/install/bin/untwine /usr/bin/untwine && \
    ln -s /code/SuperBuild/install/bin/entwine /usr/bin/entwine && \
    ln -s /code/SuperBuild/install/bin/pdal /usr/bin/pdal


RUN mkdir /var/www

WORKDIR "/var/www"
COPY . /var/www

RUN npm install --production && mkdir -p tmp

ENTRYPOINT ["/usr/bin/node", "/var/www/index.js"]

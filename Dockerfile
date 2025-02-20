# por algum motivo a tag :latest não ta funcionando. Erro reportado pelo @Yuri. Usar a tag latest faz com que a linha 11 `apt-get install -y curl gpg-agent ca-certificates` falhe. A solução foi usar a tag :gpu
FROM opendronemap/odm:gpu
MAINTAINER Piero Toffanin <pt@masseranolabs.com>

EXPOSE 3000
USER root

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

FROM debian

## Instalación y configuración mysql
RUN apt-get update
RUN apt-get install -y net-tools
RUN apt install -y sudo
RUN echo "mysql-server-5.7 mysql-server/root_password password abc123." | debconf-set-selections
RUN echo "mysql-server-5.7 mysql-server/root_password_again password abc123." | debconf-set-selections

## Instalación de servicios y librerías
RUN apt-get install -y apache2 php-mysql php libapache2-mod-php mysql-server wget nano curl

## Establecer permisos mysql
RUN /etc/init.d/mysql start && mysql -uroot -pabc123. -e "create database wordpress" && mysql -uroot -pabc123. -e "grant all on wordpress.* to 'wordpress'@'localhost' identified by 'abc123.';flush privileges"

##############
#### OPCION 1: Descargar, descomprimir e instalar Wordpress desde cero
##############
# Descargar y descomprimir Wordpress
#RUN cd /tmp;wget https://wordpress.org/latest.tar.gz
#RUN cd /var/www/html; rm index.html; tar xvzf /tmp/latest.tar.gz; mv wordpress/* .; rm -rf wordpress

# Copiar wp-config.php al directorio Wordpress
#COPY wp-config.php /var/www/html/wp-config.php

##############
#### OPCION 2: Copiar Wordpress con plantilla previamente configurada y adaptada.
##############
# Copiar Wordpress con plantilla modificada, configuraciones y wp-config.php
RUN cd /var/www/html; rm index.html
COPY webitgal/ /var/www/html/

# Establecer permisos en el directorio donde trajará apache
RUN chown -R www-data:www-data /var/www/html

# Agregar certificados SSL Web ITGAL
RUN mkdir /certificados
COPY itgal.es_private_key.key /certificados/itgal.es_private_key.key
COPY itgal.es_ssl_certificate.cer /certificados/itgal.es_ssl_certificate.cer
RUN chown -R root:www-data /certificados
RUN chmod -R 755 /certificados

# Copiar VirtualHosts Apache2
COPY itgal-http.conf /etc/apache2/sites-available/itgal-http.conf
COPY itgal-https.conf /etc/apache2/sites-available/itgal-https.conf

# Habilitar sitios y modulos Apache2
RUN a2enmod rewrite ; a2enmod ssl ; a2dissite 000-default.conf ; a2ensite itgal-http.conf ; a2ensite itgal-https.conf
RUN /etc/init.d/apache2 restart

# Agregar usuario raso para conexión por SSH
RUN mkdir /home/USER ; useradd USER -d /home/USER -s /bin/bash
RUN echo "USER:abc123." | chpasswd USER
RUN echo "USER ALL=(ALL:ALL) ALL" > /etc/sudoers

# Instalar y configurar servidor SSH
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo "Port 22" >> /etc/ssh/sshd_config
RUN echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config
RUN echo "AllowUsers USER" >> /etc/ssh/sshd_config

## Configuración de Supervisord
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## Establecer banner motd
RUN mv /etc/motd /etc/motd.bak
COPY motd /etc/motd

## Abrir puertos: SSH, HTTP, HTTPS
EXPOSE 22 80 443

## Comando en el que se ejecutará el contenedor. Supervisa en un único daemon los servicios: SSH, Apache2 y Mysql
CMD ["/usr/bin/supervisord"]

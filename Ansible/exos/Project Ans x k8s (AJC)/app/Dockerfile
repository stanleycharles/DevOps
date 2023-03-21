FROM debian:latest

RUN apt update && apt upgrade -y
RUN apt install -y apache2 

ADD scripts /var/www/html
COPY index.html /var/www/html
# EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]


# FROM httpd

# ADD scripts /var/www/html
# COPY index.html /var/www/html
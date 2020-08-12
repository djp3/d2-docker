FROM mariadb:latest

#Reduce error messages on docker build
ARG DEBIAN_FRONTEND=noninteractive

#Configure timezone
ARG TZ
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
RUN echo ${TZ} > /etc/timezone
RUN dpkg-reconfigure tzdata

#Update package repos
RUN apt-get update -qq

#Install foundation
RUN apt-get install apt-utils -qq

#Upgrade if necessary
RUN apt-get upgrade -qq

#Install other stuff
RUN apt-get install host -qq

#Copy configuration files
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d 

COPY conf.d/settings.cnf /etc/mysql/conf.d/settings.cnf

EXPOSE 3306

CMD ["mysqld"]


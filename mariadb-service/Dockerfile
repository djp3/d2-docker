FROM mariadb:latest

RUN apt-get update -qq
RUN apt-get install apt-utils host -qq

COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d 

COPY conf.d/settings.cnf /etc/mysql/conf.d/settings.cnf

EXPOSE 3306

CMD ["mysqld"]


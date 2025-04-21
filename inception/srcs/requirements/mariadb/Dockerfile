FROM alpine:3.20

RUN apk update && apk add --no-cache mariadb mariadb-client bash gettext

COPY ./conf/my.cnf /etc/my.cnf

COPY ./tools/db-entrypoint.sh /usr/local/bin/db-entrypoint.sh
RUN chmod +x /usr/local/bin/db-entrypoint.sh

COPY ./conf/init.sql.template /etc/init.sql.template

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/db-entrypoint.sh"]
#!/bin/bash
set -e

INIT_MARKER=/var/lib/mysql/.db_initialized

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql


if [ ! -f "$INIT_MARKER" ]; then
  echo "[MariaDB] Database directory not found. Running initial setup..."

  # Substitui as variáveis de ambiente
  envsubst '$WP_DATABASE_NAME $WP_DATABASE_USER $WP_DATABASE_PASSWORD $WP_DATABASE_ROOT_PASSWORD $HEALTH_USER $HEALTH_PASS' < /etc/init.sql.template > /etc/init.sql
  rm /etc/init.sql.template


  echo "[MariaDB] Initializing data directory..."
  if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
  fi

  echo "[MariaDB] Starting temporary server..."
  mysqld_safe --user=mysql &

  echo "[MariaDB] Waiting for server to become ready..."
  until mariadb-admin ping --protocol=socket --socket=/run/mysqld/mysqld.sock --silent; do
    sleep 1
  done

  echo "[MariaDB] Setting up database and users..."
  mariadb --protocol=socket -u root < /etc/init.sql

  echo "[MariaDB] Shutting down temporary server..."
  mysqladmin -u root --protocol=socket --socket=/run/mysqld/mysqld.sock -p"${WP_DATABASE_ROOT_PASSWORD}" shutdown


  touch "$INIT_MARKER"
  echo "[MariaDB] Initialization complete."
else
    echo "[MariaDB] Existing database detected. Skipping initialization."
fi

# Inicia o MariaDB em foreground
echo "[MariaDB] Starting main server..."
exec mariadbd --user=mysql

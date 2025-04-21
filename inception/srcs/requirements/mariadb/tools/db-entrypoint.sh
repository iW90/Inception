#!/bin/bash
set -e

# Substitui as variáveis de ambiente
envsubst '$WP_DATABASE_NAME $WP_DATABASE_USER $WP_DATABASE_PASSWORD $WP_DATABASE_ROOT_PASSWORD $HEALTH_USER $HEALTH_PASS' < /etc/init.sql.template > /etc/init.sql
rm /etc/init.sql.template

# Verifica se o banco já está inicializado
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[MariaDB] Database directory not found. Running initial setup..."

    echo "[MariaDB] Initializing data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

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

    echo "[MariaDB] Initialization complete."

else
    echo "[MariaDB] Existing database detected. Skipping initialization."
fi

# Inicia o MariaDB em foreground
echo "[MariaDB] Starting main server..."
exec mariadbd --user=mysql


# #!/bin/bash

# # Encerra o script se ocorrer qualquer erro (fail-fast)
# set -e

# # Substitui as variáveis de ambiente
# envsubst '$WP_DATABASE_NAME $WP_DATABASE_USER $WP_DATABASE_PASSWORD $WP_DATABASE_ROOT_PASSWORD $HEALTH_USER $HEALTH_PASS' < /etc/init.sql.template > /etc/init.sql
# rm /etc/init.sql.template

# # Garante que o diretório de dados do MariaDB está inicializado
# echo "[MariaDB] Starting server in the background..."
# if [ ! -d "/var/lib/mysql/mysql" ]; then
#     echo "[MariaDB] Initializing data directory..."
#     mariadb-install-db --user=mysql --datadir=/var/lib/mysql
# fi

# # Inicia o MariaDB temporariamente em segundo plano
# echo "[MariaDB] Starting temporary server..."
# mysqld_safe --user=mysql &

# # Aguarda até o servidor responder via socket
# echo "[MariaDB] Waiting for server to become ready..."
# until mariadb-admin ping --protocol=socket --socket=/run/mysqld/mysqld.sock --silent; do
#   sleep 1
# done

# # Executa comandos SQL de configuração
# if mariadb --protocol=socket -u root -e "USE \`${WP_DATABASE_NAME}\`;" 2>/dev/null; then
#   echo "Database '${WP_DATABASE_NAME}' already exists. Skipping initialization."
# else
#   echo "[MariaDB] Setting up database and users..."
#   mariadb --protocol=socket -u root < /etc/init.sql
# fi

# # Finaliza o servidor temporário
# echo "[MariaDB] Shutting down temporary server..."
# mysqladmin -u root --protocol=socket --socket=/run/mysqld/mysqld.sock -p"${WP_DATABASE_ROOT_PASSWORD}" shutdown

# # Inicia o MariaDB em foreground (mantém o container rodando)
# echo "[MariaDB] Initialization complete. Starting main server..."
# exec mariadbd --user=mysql

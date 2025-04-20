#!/bin/bash

# Encerra o script se ocorrer qualquer erro (fail-fast)
set -e

# Substitui as variáveis de ambiente
envsubst '$WP_DATABASE_NAME $WP_DATABASE_USER $WP_DATABASE_PASSWORD $WP_DATABASE_ROOT_PASSWORD $HEALTH_USER $HEALTH_PASS' < /etc/init.sql.template > /etc/init.sql
rm /etc/init.sql.template

# Garante que o diretório de dados do MariaDB está inicializado
echo "[MariaDB] Starting server in the background..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[MariaDB] Initializing data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Inicia o MariaDB temporariamente em segundo plano
echo "[MariaDB] Starting temporary server..."
mysqld_safe --user=mysql &

# Aguarda até o servidor responder via socket
echo "[MariaDB] Waiting for server to become ready..."
until mariadb-admin ping --protocol=socket --socket=/run/mysqld/mysqld.sock --silent; do
  sleep 1
done

# Executa comandos SQL de configuração
if mariadb --protocol=socket -u root -e "USE \`${WP_DATABASE_NAME}\`;" 2>/dev/null; then
  echo "Database '${WP_DATABASE_NAME}' already exists. Skipping initialization."
else
  echo "[MariaDB] Setting up database and users..."
  mariadb --protocol=socket -u root < /etc/init.sql
#   mariadb --protocol=socket -u root <<EOF
#   -- Remove usuário anônimo e banco de testes
#   DROP USER IF EXISTS ''@'localhost';
#   DROP DATABASE IF EXISTS test;

#   -- Cria o banco de dados do WordPress (se não existir)
#   CREATE DATABASE IF NOT EXISTS \`${WP_DATABASE_NAME}\`;

#   -- Cria o usuário de aplicação e concede permissões
#   CREATE USER IF NOT EXISTS '${WP_DATABASE_USER}'@'%' IDENTIFIED BY '${WP_DATABASE_PASSWORD}';
#   GRANT ALL PRIVILEGES ON \`${WP_DATABASE_NAME}\`.* TO '${WP_DATABASE_USER}'@'%';

#   -- Configura senha do usuário root
#   ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_DATABASE_ROOT_PASSWORD}';

#   -- Usuário para healthcheck
#   CREATE USER IF NOT EXISTS '${HEALTH_USER}'@'localhost' IDENTIFIED BY '${HEALTH_PASS}';
#   GRANT USAGE ON *.* TO '${HEALTH_USER}'@'localhost';

#   -- Aplica todas as mudanças
#   FLUSH PRIVILEGES;
# EOF
fi

# Finaliza o servidor temporário
echo "[MariaDB] Shutting down temporary server..."
mysqladmin -u root --protocol=socket --socket=/run/mysqld/mysqld.sock -p"${WP_DATABASE_ROOT_PASSWORD}" shutdown

# Inicia o MariaDB em foreground (mantém o container rodando)
echo "[MariaDB] Initialization complete. Starting main server..."
exec mariadbd --user=mysql

#!/bin/bash

# Faz o script parar imediatamente se algum comando falhar (fail-fast)
set -e

# Se o diretório de dados do MariaDB ainda não foi inicializado, inicializa o banco de dados vazio
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data dir..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Inicia o MariaDB em segundo plano de forma segura
echo "Starting MariaDB..."
mysqld_safe --user=mysql &

# Aguarda o servidor MariaDB ficar pronto (verifica via socket)
until mariadb-admin ping --protocol=socket --socket=/run/mysqld/mysqld.sock --silent; do
  echo "Waiting for MariaDB to be ready..."
  sleep 1
done

# Executa os comandos SQL para criar o banco e os usuários
echo "Creating database and users..."
mariadb --protocol=socket -u root <<EOF
DROP USER IF EXISTS ''@'localhost';                           -- Remove usuário anônimo
DROP DATABASE IF EXISTS test;                                 -- Remove DB de testes padrão
CREATE DATABASE IF NOT EXISTS \`${WP_DATABASE_NAME}\`;        -- Cria o banco do WordPress
CREATE USER IF NOT EXISTS '${WP_DATABASE_USER}'@'%' 
  IDENTIFIED BY '${WP_DATABASE_PASSWORD}';                    -- Cria usuário do WordPress
GRANT ALL PRIVILEGES ON \`${WP_DATABASE_NAME}\`.* 
  TO '${WP_DATABASE_USER}'@'%';                               -- Dá permissões totais ao user

ALTER USER 'root'@'localhost' 
  IDENTIFIED BY '${WP_DATABASE_ROOT_PASSWORD}';               -- Define senha para o root

CREATE USER IF NOT EXISTS '${HEALTH_USER}'@'localhost' 
  IDENTIFIED BY '${HEALTH_PASS}';                             -- Cria user para o healthcheck
GRANT USAGE ON *.* TO '${HEALTH_USER}'@'localhost';           -- Dá acesso limitado p/ healthcheck

FLUSH PRIVILEGES;                                             -- Aplica todas as mudanças
EOF

# Desliga o MariaDB que estava rodando em segundo plano
mysqladmin -u root --protocol=socket --socket=/run/mysqld/mysqld.sock -p"${WP_DATABASE_ROOT_PASSWORD}" shutdown

# Inicia o servidor principal em foreground
exec mariadbd --user=mysql

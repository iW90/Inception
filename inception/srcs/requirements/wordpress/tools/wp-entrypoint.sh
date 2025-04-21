#!/bin/sh

# Faz o script parar imediatamente se algum comando falhar (fail-fast)
set -e

# Espera o banco de dados estar disponível antes de seguir, tentando se conectar continuamente
echo "[WP] Waiting for MariaDB at $WP_DATABASE_HOST..."
until mysqladmin ping -h"$WP_DATABASE_HOST" --silent; do
  echo "[WP] Waiting..."
  sleep 1
done
echo "[WP] MariaDB is up."

# Verifica se o WordPress já está instalado (para evitar re-instalar a cada start)
if ! wp core is-installed --allow-root --path=/var/www/wordpress; then
  echo "[WP] Installing WordPress..."

  # Cria o arquivo wp-config.php com as configurações do banco
  wp config create --allow-root \
    --path=/var/www/wordpress \
    --dbname="$WP_DATABASE_NAME" \
    --dbuser="$WP_DATABASE_USER" \
    --dbpass="$WP_DATABASE_PASSWORD" \
    --dbhost="$WP_DATABASE_HOST" \
    --dbprefix='wp_' \
    --dbcharset='utf8'

  # Faz a instalação principal do WordPress, definindo URL, título e o admin
  wp core install --allow-root \
    --path=/var/www/wordpress \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email

  # Cria um usuário adicional com papel de autor (útil para conteúdo)
  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASSWORD" \
    --role=author \
    --path=/var/www/wordpress \
    --allow-root

  #  Configura o WordPress para usar o Redis como sistema de cache
  wp plugin install redis-cache --activate --allow-root --path=/var/www/wordpress
  wp config set WP_REDIS_HOST "$REDIS_HOST" --allow-root --path=/var/www/wordpress
  wp config set WP_REDIS_PORT "$REDIS_PORT" --allow-root --path=/var/www/wordpress
  wp redis enable --allow-root --path=/var/www/wordpress

  # Ajusta permissões para garantir que o Nginx tenha acesso ao conteúdo corretamente
  chown -R nginx:nginx /var/www/wordpress
  chmod -R 775 /var/www/wordpress
fi

# Inicia o PHP-FPM em modo foreground (-F), mantendo o container rodando
echo "[WP] WordPress is ready"
exec php-fpm83 -F

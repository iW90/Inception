#!/bin/bash

ENV_FILE="srcs/.env"´



# Remove o .env existente, se houver
if [ -f "$ENV_FILE" ]; then
  echo "[ENV] Removing existing $ENV_FILE..."
  rm -f "$ENV_FILE"
fi

echo "[ENV] Generating .env file..."

# Função para ler senha com validação
read_secret() {
  local var_name="$1"
  local prompt="$2"
  local value=""

  while true; do
    read -sp "$prompt: " value
    echo

	# Verifica se a senha está vazia
    if [ -z "$value" ]; then
      echo "⚠️  This field cannot be empty. Please try again."
      continue
    fi

    # Valida se a senha contém apenas caracteres alfanuméricos (a-z, A-Z, 0-9)
    if [[ "$value" =~ ^[a-zA-Z0-9]+$ ]]; then
      eval "$var_name=\"$value\""
      break
    else
      echo "⚠️  Invalid input. Only alphanumeric characters are allowed (a-z, A-Z, 0-9). Please try again."
    fi
  done
}

# Coleta segura de senhas
read_secret WP_DATABASE_PASSWORD      "🔑 WP_DATABASE_PASSWORD"
read_secret WP_DATABASE_ROOT_PASSWORD "🔑 WP_DATABASE_ROOT_PASSWORD"
read_secret WP_ADMIN_PASSWORD         "🔑 WP_ADMIN_PASSWORD"
read_secret WP_USER_PASSWORD          "🔑 WP_USER_PASSWORD"
read_secret FTP_PASSWORD              "🔑 FTP_PASSWORD"
read_secret HEALTH_PASSWORD           "🔑 HEALTH_PASSWORD"

# Valor automático do login
LOGIN=($1)

# Criação do .env
cat <<EOF > "$ENV_FILE"
WP_DATABASE_HOST=mariadb
WP_DATABASE_NAME=wordpress
WP_DATABASE_USER=wp_user
WP_DATABASE_ROOT=root
WP_DATABASE_PASSWORD=$WP_DATABASE_PASSWORD
WP_DATABASE_ROOT_PASSWORD=$WP_DATABASE_ROOT_PASSWORD
WP_URL="http://$LOGIN.42.fr"
WP_TITLE="The $LOGIN's page of wonderful ${LOGIN}derness"
WP_ADMIN_USER=toptier
WP_ADMIN_EMAIL="toptier@example.com"
WP_ADMIN_PASSWORD=$WP_ADMIN_PASSWORD
WP_USER=changer
WP_USER_EMAIL="changer@example.com"
WP_USER_PASSWORD=$WP_USER_PASSWORD
HEALTH_USER=healthchecker
HEALTH_PASS=$HEALTH_PASSWORD
REDIS_HOST=redis
REDIS_PORT=6379
FTP_USER=ftpuser
FTP_PASSWORD=$FTP_PASSWORD
EOF

echo "✅ .env file generated successfully at $ENV_FILE!"
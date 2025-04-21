#!/bin/sh

envsubst '$DOMAIN_NAME' < /etc/nginx/nginx-template.conf > /etc/nginx/nginx.conf

# Inicia o Nginx em primeiro plano (não como daemon), para que o Docker possa manter o container ativo
exec nginx -g 'daemon off;'  # 'daemon off' é necessário no Docker para garantir que o Nginx rode em primeiro plano

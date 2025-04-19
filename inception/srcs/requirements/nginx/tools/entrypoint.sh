#!/bin/sh

# Substitui as variáveis de ambiente dentro do arquivo de template para criar o arquivo de configuração do Nginx
envsubst '$DOMAIN_NAME' < /etc/nginx/nginx-template.conf > /etc/nginx/nginx.conf
# O comando acima vai ler o template de configuração nginx-template.conf,
# substituir a variável $DOMAIN_NAME pelo seu valor atual e salvar o resultado em nginx.conf.

# Inicia o Nginx em primeiro plano (não como daemon), para que o Docker possa manter o container ativo
exec nginx -g 'daemon off;'  # 'daemon off' é necessário no Docker para garantir que o Nginx rode em primeiro plano

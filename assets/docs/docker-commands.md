# CHEAT SHEET: DOCKER

> O trecho `$(...)` presente em alguns comandos é um comando embutido no terminal (mais especificamente, no shell/bash). Ele é executado dentro de outro comando e o resultado substitui `$(...)` antes da execução final.

> `<imagem>` O "modelo" ou "template" usado para criar um container. Não é único, pois pode ser a mesma imagem usada para criar vários containers. Ex.: nginx, mysql:5.7, wordpress.

> `<nome_container>` O nome único dado ao container em execução. Cada container tem um nome único enquanto está ativo. Ex.: meu_container_nginx, container_mariadb_1.

## 🔹 Flags

| Flag | Explicação |
| :--- | :--------- |
| `-a` | `--all` → lista todos, incluindo informações normalmente ocultas. |
| `-q` | `--quiet` → lista apenas os IDs. |
| `-d` | `--detach` → executa em segundo plano (background), deixando o terminal livre. |
| `-i` | `--interactive` → mantém a entrada (stdin) aberta para você poder digitar comandos. |
| `-t` | `--tty` → aloca um terminal "bonitinho", como se você estivesse usando um terminal real. |
| `-p` | `--publish` → mapeia uma porta do host para uma porta do container (expõe a porta do container para o seu host). |

## 🔹 Gerais

| Comando | Explicação |
| :------ | :--------- |
| `docker start <nome_do_container>` | Inicia um novo container. |
| `docker run <imagem>` | Roda um container. |
| `docker stop <imagem>` | Encerra um container. |
| `docker pause <nome_do_container>` | Pausa um container. |
| `docker unpause <nome_do_container>` | Encerra a pausa de um container. |
| `docker restart <imagem>` | Reinicia um container. |
| `docker wait <imagem>` | Bloqueia o terminal até que o container termine sua execução. |

## 🔹 Compose

| Comando | Explicação |
| :------ | :--------- |
| `docker compose ps` | Lista os containers em execução gerenciados pelo Docker Compose. |
| `docker compose up` | Sobe (executa) os containers definidos no docker-compose.yml. |
| `docker compose down` | Derruba (para e remove) todos os containers e redes definidos no Compose. |
| `docker compose restart` | Reinicia todos os serviços definidos no docker-compose.yml. |

## 🔹 Gerenciamento de containers

| Comando | Explicação |
| :------ | :--------- |
| `docker ps` | Lista todos os containers em execução (-a para exibir os que não estão em execução). |
| `docker stop $(docker ps -qa)` | Encerra todos os containers. |
| `docker rm $(docker ps -qa)` | Remove todos os containers. |
| `docker exec -it <nome_container> bash` | Acessa o terminal do container com uma sessão interativa. |
| `docker exec -it <nome_container> mysql -u root -p` | Acessa o banco MariaDB/MySQL dentro do container. |
| `docker restart <nome_container>` | Reinicia um container específico. |
| `docker logs <nome_container>` | Exibe os logs do container. |

## 🔹 Gerenciamento de imagens

| Comando | Explicação |
| :------ | :--------- |
| `docker images` | Lista todas as imagens locais disponíveis (-a para exibir as intermediárias, aquelas criadas durante build em camadas e que podem não ter sido usadas diretamente). |
| `docker rmi -f $(docker images -qa)` | Remove todas as imagens com força. |

## 🔹 Volumes

| Comando | Explicação |
| :------ | :--------- |
| `docker volume ls` | Lista todos os volumes existentes. |
| `docker volume inspect <nome_volume>` | Exibe detalhes de um volume, incluindo o caminho real no sistema de arquivos. |
| `docker volume rm $(docker volume ls -q)` | Remove todos os volumes. ⚠️ Apaga dados persistentes! |

## 🔹 Redes

| Comando | Explicação |
| :------ | :--------- |
| `docker network ls` | Lista todas as redes criadas pelo Docker. |
| `docker network rm $(docker network ls -q)` | Remove todas as redes personalizadas (exceto as padrão). |

## 🔹 Build

| Comando | Explicação |
| :------ | :--------- |
| `docker build` | Constrói uma imagem a partir de um Dockerfile (arquivo Docker) no diretório atual. |
| `docker build https://github.com/docker/rootfs.git#container:docker` | Constrói uma imagem a partir de um repositório GIT remoto. |

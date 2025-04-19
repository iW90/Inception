# SOBRE DOCKER

## Como o Docker e o Docker Compose funcionam

**Docker** é uma plataforma que permite empacotar aplicações e todos os seus ambientes (dependências, bibliotecas, etc.) em containers, que são como "mini computadores isolados".

- Isso facilita rodar a aplicação em qualquer lugar, sem se preocupar com o sistema operacional ou configurações diferentes.

**Docker Compose** é uma ferramenta que permite orquestrar múltiplos containers de uma vez só, usando um arquivo `.yml`.

- Por exemplo: se seu projeto precisa de um banco de dados, um servidor web e uma aplicação, o Compose sobe tudo junto com um único comando `docker compose`.

📦 Resumidamente:

- **Docker**: container individual.
- **Docker Compose**: vários containers trabalhando juntos, definidos em um arquivo.

## A diferença entre uma imagem Docker usada com Docker Compose e sem Docker Compose

Usar uma imagem Docker sem Docker Compose é como rodar o container manualmente com docker run e passar várias opções na linha de comando (como rede, volumes, portas, etc.).

Com o Docker Compose, você define tudo em um arquivo `docker-compose.yml`, o que organiza e simplifica a configuração, principalmente quando há múltiplos serviços envolvidos.

📦 Resumidamente:

- **Sem Compose**: tudo manual
- **Com Compose**: configuração clara, fácil de versionar e reproduzir

## Os benefícios do Docker em comparação com máquinas virtuais (VMs)

Docker é mais leve e rápido que máquinas virtuais. Além disso, ele não emula um sistema operacional, pois compartilha o kernel do host, então o container inicia em segundos, consome menos recursos e ainda isola a aplicação.

VMs precisam de um sistema operacional completo para rodar, ocupam mais memória, mais CPU e demoram mais para iniciar.

📦 Resumidamente:

- **Docker**: rápido, leve, eficiente
- **VM**: pesado, lento, mais difícil de escalar

## A importância da estrutura de diretórios exigida para este projeto

> (disponível no README)

A estrutura de diretórios padronizada (com a pasta `srcs/` na raiz e subpastas para cada serviço) organiza o projeto e facilita:

- Encontrar os arquivos de configuração de cada serviço (como nginx, wordpress, mariadb, etc.)
- Reaproveitar Dockerfiles e volumes
- Manter tudo limpo e modular
- Isso também facilita para outros desenvolvedores entenderem seu projeto rapidamente.
- Organização → clareza → manutenção mais fácil

## Explicação sobre Docker Network

Docker Network é o que permite que os containers conversem entre si, como se estivessem numa mesma rede local.

Quando é utilizado o `docker-compose`, ele já cria uma rede automaticamente e conecta todos os containers nela.

Aí, por exemplo, meu container do WordPress consegue se conectar ao banco de dados (MariaDB) usando só o nome do serviço, tipo mariadb:3306, sem precisar de IP fixo nem nada.

Isso deixa a comunicação entre containers mais segura, mais organizada e bem mais fácil de configurar.

- Analogia: "É como se cada container fosse um computador, e o docker network fosse o roteador que conecta todo mundo dentro da mesma rede privada. Só eles conseguem se enxergar ali dentro, e posso controlar quem fala com quem."

O bridge é o driver de rede padrão no Docker para containers que rodam de forma isolada em uma única máquina (host). Quando você não especifica nenhuma rede no seu docker run ou docker-compose.yml, o Docker automaticamente conecta os containers a essa rede chamada bridge.

> Referência: Usar a seção `networks:` no `docker-compose.yml`.
>	```yml
>	networks:
>	inception:
>		driver: bridge
>		name: inception
>	```

##  O que é um volume no Docker

Um volume é uma forma de armazenar dados de forma persistente fora do sistema de arquivos interno do container.

Em outras palavras: Containers são efêmeros — se você parar ou remover um container, tudo o que está dentro dele some. Mas se você usar um volume, os dados são guardados fora do container, e você não perde mesmo que ele seja destruído e recriado.

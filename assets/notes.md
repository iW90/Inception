# Notas

General guidelines:

• Deve ser feito em uma VM
• Todos os arquivos de configuração devem estar na pasta srcs
• O Makefile deve ficar no root do diretório, e deve configurar toda a aplicação (ou seja, ele precisa construir as imagens Docker usando o arquivo docker-compose.yml).

Estrutura e Requisitos de Containers

    Serviços e Containers:
        O projeto consiste em configurar uma infraestrutura com diferentes serviços rodando em containers.
        Cada serviço deve ter sua própria imagem Docker e cada imagem deve ser nomeada exatamente como o serviço correspondente.
        Containers dedicados: Cada serviço deve rodar em seu próprio container, ou seja, o serviço NGINX não pode compartilhar o container com o WordPress ou o MariaDB.

    Escolha da Base de Imagem:
        Você pode escolher entre as versões estáveis do Alpine ou Debian como base para os containers. O objetivo é garantir que a infraestrutura seja leve e performática.
        Você não pode usar imagens prontas do Docker Hub, exceto as imagens base como Alpine/Debian. Isso significa que você deve escrever seus próprios Dockerfiles para construir as imagens necessárias.

    Serviços Específicos:
        NGINX: Deve estar configurado para suportar apenas TLSv1.2 ou TLSv1.3, garantindo uma comunicação segura.
        WordPress + PHP-FPM: O WordPress precisa ser configurado com PHP-FPM, mas sem NGINX no mesmo container.
        MariaDB: Apenas o banco de dados MariaDB, sem NGINX.
        Volumes:
            Um volume deve ser configurado para armazenar o banco de dados do WordPress.
            Outro volume para os arquivos do site WordPress (conteúdo do site).

    Rede Docker:
        Os containers precisam se comunicar através de uma rede Docker personalizada, que deve ser configurada no arquivo docker-compose.yml.
        Proibido: Usar --link, network: host ou a opção links no Docker Compose. Isso força a criação de uma rede isolada e controlada para a comunicação entre os containers.

    Reinício dos Containers:
        Os containers precisam ser configurados para reiniciar automaticamente em caso de falha ou crash, garantindo que a infraestrutura seja resiliente.

    Entrypoint e Comandos:
        Proibido: Usar hacks como tail -f, sleep infinity, bash, ou qualquer comando que fique em um loop infinito (como while true), pois isso pode afetar a performance e a estabilidade do seu ambiente.
        É importante entender como PID 1 funciona em containers e as melhores práticas para escrever Dockerfiles. O PID 1 deve ser o processo principal do container, e não um processo que fique "esperando" ou "ocioso".

    WordPress Database:
        O banco de dados do WordPress deve ter dois usuários, sendo um deles administrador. O nome do administrador não pode incluir termos como "admin", "Administrator", "admin123", etc.

    Volumes de Dados:
        Seus volumes devem estar localizados na pasta /home/login/data da máquina host. Você deve substituir "login" pelo seu nome de usuário na máquina (por exemplo, "wil").

    Domínio Local:
        O domínio login.42.fr (substitua "login" pelo seu nome de usuário) deve apontar para o IP local onde a infraestrutura do projeto está rodando. Por exemplo, se seu login for "wil", você deve conseguir acessar o projeto através de wil.42.fr.

Outras Regras Importantes

    Proibido usar o tag "latest":
        Não utilize a tag "latest" para as imagens, pois ela pode trazer inconsistências. Use versões específicas para garantir estabilidade.

    Senhas:
        Senhas não podem estar no Dockerfile. Em vez disso, você deve usar variáveis de ambiente para garantir que informações sensíveis não fiquem expostas.
        É recomendado usar um arquivo .env para armazenar essas variáveis de ambiente. O arquivo .env deve estar na raiz da pasta srcs.

    NGINX como Entrypoint:
        O container NGINX deve ser o único ponto de entrada para a sua infraestrutura e deve escutar na porta 443 com TLSv1.2 ou TLSv1.3 configurados.
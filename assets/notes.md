# Notas

## Geral:

- Deve ser feito em uma VM.
- Todos os arquivos de configuração devem estar na pasta `srcs/`.
- O **Makefile** deve ficar no root do diretório, e deve configurar toda a aplicação (ou seja, ele precisa construir as imagens Docker usando o arquivo `docker-compose.yml`).

## Estrutura e Requisitos de Containers

1. Serviços e Containers:

    - O projeto consiste em configurar uma infraestrutura com diferentes serviços rodando em containers.
    - Cada serviço deve ter sua própria imagem Docker e cada imagem deve ser nomeada exatamente como o serviço correspondente.
    - Containers dedicados: Cada serviço deve rodar em seu próprio container, ou seja, o serviço NGINX não pode compartilhar o container com o WordPress ou o MariaDB.

2. Escolha da Base de Imagem:
    
    - Você pode escolher entre as versões estáveis do Alpine ou Debian como base para os containers. O objetivo é garantir que a infraestrutura seja leve e performática.
    - Você não pode usar imagens prontas do Docker Hub, exceto as imagens base como Alpine/Debian. Isso significa que você deve escrever seus próprios Dockerfiles para construir as imagens necessárias.

3. Serviços Específicos:
    
    - **NGINX**: Deve estar configurado para suportar apenas TLSv1.2 ou TLSv1.3, garantindo uma comunicação segura.
    - **WordPress + PHP-FPM**: O WordPress precisa ser configurado com PHP-FPM, mas sem NGINX no mesmo container.
    - **MariaDB**: Apenas o banco de dados MariaDB, sem NGINX.
    - **Volumes**:
        - Um volume deve ser configurado para armazenar o banco de dados do WordPress.
        - Outro volume para os arquivos do site WordPress (conteúdo do site).

4. Rede Docker:

    - Os containers precisam se comunicar através de uma rede Docker personalizada, que deve ser configurada no arquivo `docker-compose.yml`.
    - Proibido usar `--link`, `network: host` ou a opção `links` no Docker Compose. Isso força a criação de uma rede isolada e controlada para a comunicação entre os containers.

5. Reinício dos Containers:

    - Os containers precisam ser configurados para reiniciar automaticamente em caso de falha ou crash, garantindo que a infraestrutura seja resiliente.

6. Entrypoint e Comandos:
    
    - Proibido: Usar hacks como `tail -f`, `sleep infinity`, `bash`, ou qualquer comando que fique em um loop infinito (como `while true`), pois isso pode afetar a performance e a estabilidade do seu ambiente.
    - É importante entender como **PID 1** funciona em containers e as melhores práticas para escrever Dockerfiles. O **PID 1** deve ser o processo principal do container, e não um processo que fique "esperando" ou "ocioso".

7. WordPress Database:
    
    - O banco de dados do WordPress deve ter dois usuários, sendo um deles administrador. O nome do administrador não pode incluir termos como "admin", "Administrator", "admin123", etc.

8. Volumes de Dados:
    
    - Seus volumes devem estar localizados na pasta `/home/login/data` da máquina host. Você deve substituir "login" pelo seu nome de usuário na máquina (por exemplo, "wil").

9. Domínio Local:

    - O domínio `login.42.fr` (substitua "login" pelo seu nome de usuário) deve apontar para o IP local onde a infraestrutura do projeto está rodando. Por exemplo, se seu login for "wil", você deve conseguir acessar o projeto através de `wil.42.fr`.

10. Outras Regras Importantes

    - Proibido usar o tag "latest" para as imagens, pois ela pode trazer inconsistências. Use versões específicas para garantir estabilidade.

    - Senhas não podem estar no Dockerfile. Em vez disso, você deve usar variáveis de ambiente para garantir que informações sensíveis não fiquem expostas. É recomendado usar um arquivo `.env` para armazenar essas variáveis de ambiente. O arquivo `.env` deve estar na root da pasta `srcs/`.

    - O container NGINX deve ser o único Entrypoint para a sua infraestrutura e deve escutar na porta 443 com TLSv1.2 ou TLSv1.3 configurados.


## Estrutura de Diretórios

1. Root
    ```
    $> ls -alR
    total XX
    drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
    drwxrwxrwt 17 wil wil 4096 avril 42 20:42 ..
    -rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Makefile
    drwxrwxr-x 3 wil wil 4096 avril 42 20:42 srcs
    ``` 

2. Srcs
    ```
    ./srcs:
    total XX
    drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
    drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
    -rw-rw-r-- 1 wil wil XXXX avril 42 20:42 docker-compose.yml
    -rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .env
    drwxrwxr-x 5 wil wil 4096 avril 42 20:42 requirements
    ```

3. Requirements
    ```
    ./srcs/requirements:
    total XX
    drwxrwxr-x 5 wil wil 4096 avril 42 20:42 .
    drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
    drwxrwxr-x 4 wil wil 4096 avril 42 20:42 bonus
    drwxrwxr-x 4 wil wil 4096 avril 42 20:42 mariadb
    drwxrwxr-x 4 wil wil 4096 avril 42 20:42 nginx
    drwxrwxr-x 4 wil wil 4096 avril 42 20:42 tools
    drwxrwxr-x 4 wil wil 4096 avril 42 20:42 wordpress
    ```

4. MariaDB
    ```
    ./srcs/requirements/mariadb:
    total XX
    drwxrwxr-x 4 wil wil 4096 avril 42 20:45 .
    drwxrwxr-x 5 wil wil 4096 avril 42 20:42 ..
    drwxrwxr-x 2 wil wil 4096 avril 42 20:42 conf
    -rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Dockerfile
    -rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .dockerignore
    drwxrwxr-x 2 wil wil 4096 avril 42 20:42 tools
    [...]
    ```

5. NGINX
    ```
    ./srcs/requirements/nginx:
    total XX
    drwxrwxr-x 4 wil wil 4096 avril 42 20:42 .
    drwxrwxr-x 5 wil wil 4096 avril 42 20:42 ..
    drwxrwxr-x 2 wil wil 4096 avril 42 20:42 conf
    -rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Dockerfile
    -rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .dockerignore
    drwxrwxr-x 2 wil wil 4096 avril 42 20:42 tools
    [...]
    ```

### .env

Exemplo de Arquivo .env:

Este arquivo deve conter todas as informações sensíveis necessárias para a configuração dos containers ou dos serviços do projeto. Por exemplo:

```
DOMAIN_NAME=wil.42.fr
CERTS_=./path_to_certs
MYSQL_ROOT_PASSWORD=secret_password
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=wordpress_password
```

1. Armazenamento Local de Credenciais:

    - Credenciais, chaves de API, variáveis de ambiente, senhas e outros dados sensíveis devem ser armazenados localmente em um arquivo `.env` em vez de serem hardcoded (escritos diretamente no código).
    O arquivo `.env` é um arquivo de texto simples que armazena as variáveis de ambiente, facilitando a configuração e evitando que as informações sensíveis sejam expostas.

2. Ignorar o Arquivo `.env` no Git:

    - O arquivo `.env` não deve ser compartilhado publicamente. Isso significa que ele deve ser ignorado pelo sistema de controle de versão Git, para garantir que ele não seja enviado para repositórios públicos ou privados, onde poderia ser acessado por outras pessoas. Para garantir isso, você deve adicionar o arquivo `.env` ao arquivo `.gitignore` para impedir que ele seja versionado ou enviado para o repositório Git. Exemplo de entrada no .gitignore:

3. Por Que Isso é Crucial:
    - **Segurança**: Armazenar credenciais diretamente no código pode expô-las a riscos de segurança, especialmente se o repositório for acessado por pessoas não autorizadas.
    - **Facilidade de Configuração**: Utilizar um arquivo .env facilita a personalização das variáveis para diferentes ambientes (por exemplo, desenvolvimento, teste, produção), sem necessidade de alterar o código-fonte.
    - **Evitar Falhas no Projeto**: O projeto pode ser reprovado se as credenciais forem publicadas ou mal configuradas. Portanto, é essencial seguir essas práticas de segurança.


---

## Bônus

Requisitos para a Parte Bônus:

1. Redis Cache para o WordPress:
    - Você deve configurar um container Redis que será usado para gerenciar o cache do seu site WordPress. Isso ajudará a melhorar o desempenho do WordPress ao armazenar dados em cache e reduzir o tempo de resposta das páginas.
    - Volume dedicado pode ser necessário, dependendo de como o Redis for configurado.
    - Exemplo de configuração no docker-compose.yml para Redis:

    ```yml
    redis:
        image: redis:latest
        volumes:
        - redis_data:/data
        networks:
        - my_network
    ```

    - Você também precisará configurar o WordPress para usar o Redis como cache, o que pode ser feito por meio de plugins ou configurações no arquivo wp-config.php.

2. Servidor FTP:

    - Um servidor FTP deve ser configurado dentro de um container e deverá apontar para o volume do site WordPress para permitir a transferência de arquivos entre o servidor e o seu computador.
    - Você pode utilizar imagens prontas de servidores FTP como o vsftpd ou configurar um Dockerfile para criar o seu próprio.
    - Exemplo de configuração no docker-compose.yml para o FTP:

    ```yml
    ftp:
      image: fauria/vsftpd
      environment:
        - FTP_USER=youruser
        - FTP_PASS=yourpassword
      volumes:
        - wordpress_data:/var/www/html
      ports:
        - "21:21"
      networks:
        - my_network
    ```

3. Criação de um Site Estático:

    - O bônus também inclui a criação de um site estático simples, que pode ser um site de portfólio ou currículo. Este site deve ser criado com qualquer tecnologia que não seja PHP, como HTML, CSS e JavaScript.
    - Este site pode ser servido por um container NGINX.
    - Exemplo de configuração no docker-compose.yml para o site estático:

    ```yml
    static_website:
      image: nginx:latest
      volumes:
        - ./static_site:/usr/share/nginx/html
      ports:
        - "8080:80"
      networks:
        - my_network
    ```

4. Configuração do Adminer:

    - Adminer é uma ferramenta de gerenciamento de banco de dados que pode ser usada para interagir com o banco de dados MariaDB de forma visual.
    - Você pode configurar o Adminer em um container separado, permitindo acessá-lo pela web.
    - Exemplo de configuração no docker-compose.yml para o Adminer:

    ```yml
    adminer:
        image: adminer
        ports:
        - "8081:8080"
        networks:
        - my_network
    ```

6. Serviço Adicional de Sua Escolha:

    - Você pode adicionar um serviço extra de sua escolha. Esse serviço pode ser algo que você considere útil ou interessante para a sua infraestrutura.
    - Durante a defesa do projeto, você terá que justificar a escolha desse serviço e como ele contribui para o ambiente ou projeto como um todo.

### Requisitos Adicionais:

- Abrir Portas Adicionais:
    - Se for necessário para a comunicação entre os serviços ou para o acesso aos novos serviços bônus, você poderá abrir portas adicionais no arquivo docker-compose.yml. Por exemplo, para o serviço FTP, a porta 21 foi mapeada, e para o Adminer, a porta 8081 foi usada.
    - Lembre-se de que a configuração de portas adicionais deve ser feita de forma cuidadosa para evitar conflitos ou problemas de segurança.

- Volume Dedicado:
    - Para alguns serviços, como o Redis e o FTP, pode ser necessário configurar volumes dedicados, para persistir dados importantes como cache ou arquivos transferidos.

### Exemplo de Estrutura de Diretórios Atualizada com a Parte Bônus:

```sh
$> ls -alR
total XX
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
drwxrwxrwt 17 wil wil 4096 avril 42 20:42 ..
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Makefile
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 srcs
./srcs:
total XX
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 docker-compose.yml
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .env
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 requirements
./srcs/requirements:
total XX
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 mariadb
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 nginx
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 tools
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 wordpress
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 redis
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 ftp
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 adminer
```

Esta estrutura atualizada mostra que os diretórios de serviço bônus como redis, ftp, adminer, etc., foram adicionados à pasta requirements. Cada um desses serviços deverá ter seu próprio Dockerfile e outras configurações necessárias.

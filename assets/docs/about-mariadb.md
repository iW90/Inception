# SOBRE MARIADB

O MariaDB é um sistema de gerenciamento de banco de dados (SGDB), open-source, baseado no MySQL, muito usado para armazenar dados em aplicações web.

No contexto de containers Docker, o MariaDB geralmente é usado em conjunto com outras tecnologias, como WordPress, para fornecer um banco de dados onde o site armazena suas informações.

>> Curiosidade: O nome MariaDB é originado de Maria Widenius, filha de um dos principais desenvolvedores do projeto, Mikael Widenius. Mikael é um dos criadores do MySQL. O nome "MariaDB" é uma combinação do nome de sua filha, Maria, e a herança do MySQL, já que MariaDB é um fork do MySQL, ou seja, uma versão derivada e compatível com ele.

## Login

- O container deve estar em execução
- Você pode acessar o terminal do MariaDB rodando dentro do container com o comando:
	- `docker exec -it nome_do_container_mariadb mysql -u root -p`
	- O `-u` root significa que você está tentando fazer login com o usuário root (admin do banco de dados).
	- Se você não configurou uma senha, pode ser que a senha seja em branco ou definida por variáveis de ambiente no seu arquivo de configuração.
- Depois de fazer login, você verá o prompt do MariaDB: `MariaDB [(none)]>`
	- Agora você pode rodar comandos SQL, como listar os bancos de dados:
	- `SHOW DATABASES;`

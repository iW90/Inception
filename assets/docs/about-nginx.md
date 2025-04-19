# SOBRE NGINX

É como se fosse um "gateway" da sua aplicação web.

Quando alguém tenta acessar seu site (tipo digitando `login.42.fr` no navegador), esse pedido chega primeiro no NGINX. Ele dá uma olhada no pedido e decide o que fazer com ele.

## Funções

- **Servidor web**: Ele pode servir arquivos diretamente (HTML, imagens, etc.)
- **Proxy reverso**: Se o seu site tem um backend (tipo PHP, Node.js, etc.), o NGINX recebe o pedido e passa ele pro backend, e depois entrega a resposta de volta pro usuário.
- **Balanceamento de carga**: Se você tem várias instâncias do seu app rodando, o NGINX distribui os acessos entre elas, pra não sobrecarregar.
- **HTTPS/SSL**: Ele cuida da criptografia da conexão, usando certificados SSL/TLS — tipo aquele cadeadinho no navegador.
- **Redirecionamentos e bloqueios**: Quer forçar HTTPS? Bloquear acessos? Redirecionar de uma URL pra outra? NGINX faz isso também.

## Vantagens

- Leve e rápido — aguenta muito tráfego sem quebrar
- Fácil de usar com Docker
- Bastante configurável

## Bloquear porta 80 (HTTP) com NGINX

```yml
ports:
	- "443:443"   # Apenas HTTPS
```

##  O que é um proxy reverso?

Um proxy reverso é um servidor que recebe as requisições dos clientes (por exemplo, de navegadores) e as repassa para outro servidor que vai realmente processar a resposta — como o WordPress rodando em outro container. É basicamente uma camada intermediária que recebe requisições dos clientes (como navegadores) e depois repassa para outro servidor ou serviço resposável por processar a requisição.

A razão de ser chamado de "proxy reverso" é justamente pela inversão do papel em relação ao proxy tradicional.

📌 Proxy tradicional (ou direto):

- O cliente se conecta ao proxy.
- O proxy repassa as requisições para o servidor de destino.
- O cliente sabe quem é o servidor final e está se conectando a ele via proxy.

> Exemplo: Um usuário acessando um site através de uma rede corporativa, onde o tráfego passa por um proxy para segurança ou filtragem.

📌 Proxy reverso:

- O cliente se conecta ao proxy, mas o cliente não sabe qual é o servidor de destino real.
- O proxy é quem decide para qual servidor interno (por exemplo, o WordPress, o banco de dados, etc.) a requisição deve ser enviada.
- O cliente vê apenas o proxy reverso como o "ponto final" — ele não tem acesso direto ao servidor de backend.

> Exemplo: Um site acessado via HTTPS (o cliente vê apenas o domínio e o certificado SSL), mas o proxy (Nginx) repassa a requisição para o backend do WordPress.

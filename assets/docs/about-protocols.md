# SOBRE PROTOCOLOS DE SEGURANÇA

## SOBRE SSL

SSL significa Secure Sockets Layer. Foi o protocolo original de segurança criado pra proteger a comunicação entre o navegador e o servidor na internet — ou seja, pra garantir que tudo que você envia e recebe de um site é criptografado.

É tipo uma carteirinha digital que diz: "Oi, eu sou o site login.42.fr e aqui está a prova de que sou eu mesmo."

Mesmo que você use um certificado self-signed (autoassinado), ele ainda fornece criptografia — só que o navegador vai mostrar um aviso dizendo: "⚠️ Eu não conheço esse emissor."

Mas ainda assim, a conexão estará segura com SSL/TLS.

Pode ser gerado via:
- `openssl` (é a forma clássica, usada muito em ambientes controlados, como em testes com Docker, WordPress, NGINX, etc., mas não é reconhecido pelo navegador).
- `mkcert` (para desenvolvimento local, cria certificados autoassinados, mas confiáveis localmente porque instala uma autoridade certificadora local (CA)).

## SOBRE TLS

TLS (Transport Layer Security) é um protocolo de segurança que protege a comunicação entre o navegador e o servidor — é o que dá origem ao cadeado no navegador quando você acessa um site com https://.

Quando você acessa https://login.42.fr, o TLS é o que:

- Criptografa: os dados que você envia e recebe
- Integridade: Garante que ninguém pode interceptar ou alterar essas informações
- Autenticação: Confirma que o servidor é quem ele diz ser (por meio do certificado SSL)

### Versões 1.2 e 1.3

- TLS 1.2 foi lançado em 2008 e ainda é a versão mais usada hoje em produção.
- TLS 1.3 é mais nova (de 2018), mais rápida e mais segura — removeu várias falhas antigas.

> A maioria dos navegadores e servidores hoje suporta as duas, e outras versões têm falhas de segurança conhecidas.


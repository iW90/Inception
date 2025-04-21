# SOBRE FTP

É um protocolo de transferência de arquivos entre computadores, geralmente entre um cliente local (como FileZilla) e um servidor remoto, como seu container ou servidor Linux.

Com ele, você pode:

- Enviar e baixar arquivos do servidor (ex: arquivos do WordPress, imagens, logs etc)
- Conectar seu projeto a um cliente como FileZilla, Cyberduck, WinSCP
- Dar acesso remoto para times ou clientes sem SSH

No entanto, hoje temos alternativas mais seguras, como:

| Protocolo | Segurança | Recomendado para |
| :-------- | :-------- | : -------------- |
| SFTP | 🔒 Usa SSH (porta 22) | Ambientes modernos e seguros |
| FTPS | 🔐 FTP com TLS | Sites que exigem compatibilidade com clientes FTP legados |
| WebDAV | 🌐 HTTPS + sistema de arquivos remoto | Integrações com sistemas como Nextcloud, OwnCloud, etc |

## Como acessar

No terminal:

- `ftp inwagner.42.fr`
- `passive`
- `put <relative_path_to_file>`

Depois você pode visualizar o arquivo em:

- Link: https://inwagner.42.fr/site/ftp/

# SOBRE REDIS

É uma database in memory, rápido e leve, usado principalmente para:

- Cache
- Fila de mensagens
- Armazenamento de sessões
- Armazenamento de dados temporários (key-value)

## Como acessar

Abra o Inspector (`F12`) onde o comentário já aparece:

> "Performance optimized by Redis Object Cache. Learn more: https://wprediscache.com Retrieved 633 objects (130 KB) from Redis using Predis (v2.1.2)."

- `docker exec -it wordpress sh`
- `wp redis status`

O terminal exibe várias informações, dentre elas "Status: Connected".

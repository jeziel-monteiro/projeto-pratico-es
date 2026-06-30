# Porto Certo Backend

Backend da aplicacao Porto Certo. Esta API conecta o app Flutter ao banco PostgreSQL e concentra as regras do MVP do viajante: perfil, busca de viagens fluviais, paradas, reservas, bilhetes, pagamentos homologados, favoritos, avaliacoes e notificacoes.

Base da API em desenvolvimento:

```text
http://localhost:3000/api/v1
```

## Tecnologias

- Node.js
- TypeScript
- Express
- Prisma ORM
- PostgreSQL
- Firebase Admin SDK
- Zod para validacao

## O Que Precisa Instalar

Obrigatorio:

- Node.js 20 ou superior
- npm
- PostgreSQL 16 ou Docker
- Flutter configurado, caso va testar o app junto com a API

Recomendado:

- pgAdmin 4 para visualizar o banco
- Firebase Authentication habilitado no projeto Firebase
- Firebase Admin SDK somente para ambiente com autenticacao real por token
- Conta no Resend, SendGrid ou servico equivalente caso va enviar e-mails reais. O MVP esta preparado para Resend.

## Estrutura Principal

```text
TP4/backend
├── prisma/
│   ├── schema.prisma
│   ├── seed.ts
│   └── migrations/
├── src/
│   ├── app.ts
│   ├── server.ts
│   ├── config/
│   ├── database/
│   ├── http/
│   ├── modules/
│   └── routes/
├── docker-compose.yml
├── package.json
└── .env.example
```

Modulos principais:

- `travelers`: cadastro, perfil e preferencias do viajante.
- `ports`: portos disponiveis.
- `trips`: busca de viagens, paradas, rastreio e avaliacoes.
- `bookings`: reserva, bilhete, pagamento homologado e cancelamento.
- `favorites`: favoritos do viajante.
- `notifications`: notificacoes operacionais e e-mail de confirmacao de bilhete.
- `auth`: middleware de autenticacao Firebase ou autenticacao local de desenvolvimento.

## Configuracao Inicial

Entre na pasta do backend:

```bash
cd TP4/backend
```

Instale as dependencias:

```bash
npm install
```

Copie o arquivo de ambiente:

```bash
cp .env.example .env
```

O arquivo `.env` e local e nao deve ser commitado.

## Variaveis De Ambiente

Exemplo com Docker:

```env
NODE_ENV=development
PORT=3000
CORS_ORIGIN=*
DATABASE_URL=postgresql://porto_certo:porto_certo@localhost:5432/porto_certo_dev?schema=public
ALLOW_DEV_AUTH=true
FIREBASE_PROJECT_ID=
FIREBASE_CLIENT_EMAIL=
FIREBASE_PRIVATE_KEY=
EMAIL_NOTIFICATIONS_ENABLED=false
EMAIL_FROM="Porto Certo <noreply@portocerto.local>"
EMAIL_REPLY_TO=
RESEND_API_KEY=
```

Exemplo usando PostgreSQL local criado em `.postgres-data` na porta `55432`:

```env
NODE_ENV=development
PORT=3000
CORS_ORIGIN=*
DATABASE_URL=postgresql://jeziel@localhost:55432/porto_certo_dev?schema=public
ALLOW_DEV_AUTH=true
FIREBASE_PROJECT_ID=
FIREBASE_CLIENT_EMAIL=
FIREBASE_PRIVATE_KEY=
EMAIL_NOTIFICATIONS_ENABLED=false
EMAIL_FROM="Porto Certo <noreply@portocerto.local>"
EMAIL_REPLY_TO=
RESEND_API_KEY=
```

Sobre `ALLOW_DEV_AUTH`:

- `true`: permite testar localmente usando headers como `x-dev-firebase-uid`.
- `false`: exige `Authorization: Bearer <Firebase ID Token>`.

Para desenvolvimento local com o app no celular, use:

```env
ALLOW_DEV_AUTH=true
```

Para producao ou ambiente mais restrito, use:

```env
ALLOW_DEV_AUTH=false
```

E configure:

```env
FIREBASE_PROJECT_ID=
FIREBASE_CLIENT_EMAIL=
FIREBASE_PRIVATE_KEY=
```

### Notificacao De Bilhete Por E-mail

Quando uma reserva e criada em `POST /api/v1/bookings`, o backend emite o bilhete e dispara uma confirmacao por e-mail para o usuario autenticado. Esse envio acontece depois da transacao da compra; se o e-mail falhar, a reserva continua confirmada.

Por padrao, o envio real fica desligado:

```env
EMAIL_NOTIFICATIONS_ENABLED=false
```

Para enviar e-mail real via Resend:

```env
EMAIL_NOTIFICATIONS_ENABLED=true
EMAIL_FROM="Porto Certo <bilhetes@seudominio.com>"
EMAIL_REPLY_TO=atendimento@seudominio.com
RESEND_API_KEY=sua_chave_do_resend
```

Observacoes:

- nunca commite `RESEND_API_KEY` no repositorio;
- em desenvolvimento, deixe `EMAIL_NOTIFICATIONS_ENABLED=false` se quiser testar a compra sem envio externo;
- o remetente real precisa estar autorizado no provedor de e-mail.

## Opção 1: Rodar PostgreSQL Com Docker

Suba o banco:

```bash
docker compose up -d
```

Confira se o container subiu:

```bash
docker compose ps
```

O banco criado pelo `docker-compose.yml` usa:

```text
Host: localhost
Porta: 5432
Database: porto_certo_dev
Usuario: porto_certo
Senha: porto_certo
```

No `.env`, deixe:

```env
DATABASE_URL=postgresql://porto_certo:porto_certo@localhost:5432/porto_certo_dev?schema=public
```

## Opção 2: Rodar PostgreSQL Local Sem Docker

Este projeto tambem tem scripts para uma instancia PostgreSQL local dentro da pasta `.postgres-data`.

Inicializar a pasta do banco, apenas na primeira vez:

```bash
npm run db:init:local
```

Iniciar o banco:

```bash
npm run db:start:local
```

Ver status:

```bash
npm run db:status:local
```

Parar o banco:

```bash
npm run db:stop:local
```

Essa opcao usa porta `55432`. No `.env`, use uma URL como:

```env
DATABASE_URL=postgresql://jeziel@localhost:55432/porto_certo_dev?schema=public
```

Se o seu usuario local do Linux for outro, ajuste o usuario da URL.

## Banco, Migrations e Seed

Gerar Prisma Client:

```bash
npm run prisma:generate
```

Rodar migrations:

```bash
npm run prisma:migrate
```

Popular dados iniciais:

```bash
npm run db:seed
```

O seed cria:

- usuarios e perfis base;
- portos do Amazonas, Para e Amapa;
- embarcacoes;
- viagens fluviais;
- paradas intermediarias;
- posicoes de rastreio;
- avaliacoes;
- notificacoes.

Rotas representativas do seed:

- Manaus/AM -> Santarem/PA
- Manaus/AM -> Parintins/AM
- Parintins/AM -> Santarem/PA
- Santarem/PA -> Belem/PA
- Santarem/PA -> Santana/AP, atendimento operacional a Macapa
- Belem/PA -> Santana/AP, atendimento operacional a Macapa

## Rodar a API

Modo desenvolvimento:

```bash
npm run dev
```

Build TypeScript:

```bash
npm run build
```

Rodar build compilado:

```bash
npm run start
```

Health check:

```bash
curl http://localhost:3000/api/v1/health
```

Health check com banco:

```bash
curl http://localhost:3000/api/v1/health/db
```

## Verificar No pgAdmin 4

Se estiver usando Docker:

```text
Host: localhost
Porta: 5432
Database: porto_certo_dev
Usuario: porto_certo
Senha: porto_certo
```

Se estiver usando PostgreSQL local pela pasta `.postgres-data`:

```text
Host: localhost
Porta: 55432
Database: porto_certo_dev
Usuario: seu_usuario_local
Senha: vazio
```

No pgAdmin:

1. Clique com botao direito em `Servers`.
2. Clique em `Register > Server`.
3. Em `General`, use o nome `Porto Certo Local`.
4. Em `Connection`, preencha host, porta, database, usuario e senha.
5. Abra `Databases > porto_certo_dev > Schemas > public > Tables`.

Tabelas principais:

```text
users
traveler_profiles
owner_profiles
ports
vessels
trips
trip_stops
bookings
tickets
payments
favorites
reviews
notifications
trip_positions
```

Consulta util:

```sql
SELECT
  b.id AS booking_id,
  b.status AS booking_status,
  b."passengerName",
  b."passengerCpf",
  b."totalAmount",
  t.code AS ticket_code,
  t.status AS ticket_status,
  p.method AS payment_method,
  p.status AS payment_status,
  b."createdAt"
FROM bookings b
LEFT JOIN tickets t ON t."bookingId" = b.id
LEFT JOIN payments p ON p."bookingId" = b.id
ORDER BY b."createdAt" DESC;
```

## Autenticacao

Em desenvolvimento local, com `ALLOW_DEV_AUTH=true`, e possivel chamar endpoints autenticados usando headers:

```text
x-dev-firebase-uid: dev-viajante-001
x-dev-email: viajante.teste@portocerto.com
x-dev-name: Viajante Teste
```

Em producao ou com `ALLOW_DEV_AUTH=false`, use:

```text
Authorization: Bearer <Firebase ID Token>
```

## Endpoints Principais

### Health

```bash
curl http://localhost:3000/api/v1/health
curl http://localhost:3000/api/v1/health/db
```

### Portos

```bash
curl http://localhost:3000/api/v1/ports
```

### Perfil do viajante

Criar perfil:

```bash
curl -X POST http://localhost:3000/api/v1/travelers \
  -H "content-type: application/json" \
  -H "x-dev-firebase-uid: dev-viajante-001" \
  -H "x-dev-email: viajante.teste@portocerto.com" \
  -d '{
    "fullName": "Viajante Teste",
    "cpf": "12345678909",
    "email": "viajante.teste@portocerto.com",
    "phone": "92999999999",
    "highContrast": false
  }'
```

Buscar perfil:

```bash
curl http://localhost:3000/api/v1/travelers/me \
  -H "x-dev-firebase-uid: dev-viajante-001"
```

Atualizar preferencia de acessibilidade:

```bash
curl -X PATCH http://localhost:3000/api/v1/travelers/me/preferences \
  -H "content-type: application/json" \
  -H "x-dev-firebase-uid: dev-viajante-001" \
  -d '{"highContrast":true}'
```

### Busca de viagens

```bash
curl "http://localhost:3000/api/v1/trips/search?origin=Manaus&destination=Santarem&date=2026-07-04"
```

Buscar viagem por ID:

```bash
curl http://localhost:3000/api/v1/trips/TRIP_ID
```

Rastreio:

```bash
curl http://localhost:3000/api/v1/trips/TRIP_ID/tracking
```

Avaliacoes:

```bash
curl http://localhost:3000/api/v1/trips/TRIP_ID/reviews
```

### Favoritos

Listar favoritos:

```bash
curl http://localhost:3000/api/v1/favorites/me \
  -H "x-dev-firebase-uid: dev-viajante-001"
```

Adicionar favorito:

```bash
curl -X POST http://localhost:3000/api/v1/favorites/TRIP_ID \
  -H "x-dev-firebase-uid: dev-viajante-001"
```

Remover favorito:

```bash
curl -X DELETE http://localhost:3000/api/v1/favorites/TRIP_ID \
  -H "x-dev-firebase-uid: dev-viajante-001"
```

### Reservas, bilhetes e pagamentos

Criar reserva:

```bash
curl -X POST http://localhost:3000/api/v1/bookings \
  -H "content-type: application/json" \
  -H "x-dev-firebase-uid: dev-viajante-001" \
  -d '{
    "tripId": "TRIP_ID",
    "originStopId": "ORIGIN_STOP_ID",
    "destinationStopId": "DESTINATION_STOP_ID",
    "passengerName": "Viajante Teste",
    "passengerCpf": "12345678909",
    "accommodationType": "HAMMOCK",
    "paymentMethod": "PIX"
  }'
```

Listar minhas reservas:

```bash
curl http://localhost:3000/api/v1/bookings/me \
  -H "x-dev-firebase-uid: dev-viajante-001"
```

Buscar uma reserva:

```bash
curl http://localhost:3000/api/v1/bookings/BOOKING_ID \
  -H "x-dev-firebase-uid: dev-viajante-001"
```

Cancelar reserva:

```bash
curl -X POST http://localhost:3000/api/v1/bookings/BOOKING_ID/cancel \
  -H "x-dev-firebase-uid: dev-viajante-001"
```

### Notificacoes

```bash
curl http://localhost:3000/api/v1/notifications \
  -H "x-dev-firebase-uid: dev-viajante-001"
```

## Testar No Celular Via USB

O backend precisa estar rodando no computador:

```bash
cd TP4/backend
npm run dev
```

Descubra o IP local do computador:

```bash
hostname -I
```

No outro terminal, rode o app Flutter usando o IP do computador:

```bash
cd TP4
flutter run -d CPH2737 \
  --dart-define=PORTO_CERTO_API_BASE_URL=http://SEU_IP_LOCAL:3000/api/v1 \
  --dart-define=PORTO_CERTO_USE_DEV_AUTH=true
```

Exemplo:

```bash
flutter run -d CPH2737 \
  --dart-define=PORTO_CERTO_API_BASE_URL=http://192.168.1.50:3000/api/v1 \
  --dart-define=PORTO_CERTO_USE_DEV_AUTH=true
```

Importante: no celular, `localhost` aponta para o proprio celular. Use sempre o IP local do computador.

## Comandos Uteis

```bash
npm install
npm run db:start:local
npm run db:status:local
npm run prisma:migrate
npm run db:seed
npm run dev
npm run build
npm run prisma:studio
```

## Problemas Comuns

### Erro de conexao com banco

Verifique se o PostgreSQL esta rodando:

```bash
npm run db:status:local
```

Ou, se estiver usando Docker:

```bash
docker compose ps
```

### App no celular nao conecta na API

Use o IP local do computador no `PORTO_CERTO_API_BASE_URL`, nao `localhost`.

### Cadastro criou usuario no Firebase, mas falhou no backend

Se o perfil nao foi criado no PostgreSQL por erro de rede/API, remova o usuario no Firebase Authentication e tente novamente apos corrigir o backend.

### Prisma Client desatualizado

Rode:

```bash
npm run prisma:generate
```

### Banco sem dados iniciais

Rode:

```bash
npm run db:seed
```

## Seguranca

Nao versionar:

- `.env`
- `.postgres-data/`
- credenciais do Firebase Admin SDK
- `google-services.json` real do app Flutter
- chaves privadas

O backend ja possui `.gitignore` para esses arquivos. Antes de commitar, confira:

```bash
git status --short
```

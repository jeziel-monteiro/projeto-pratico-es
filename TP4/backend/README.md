# Porto Certo Backend

API backend do Porto Certo responsável por intermediar o app Flutter e o banco PostgreSQL.

## Stack

- Node.js
- TypeScript
- Express
- Prisma ORM
- PostgreSQL

## Desenvolvimento Local

### Com Docker

1. Copie o arquivo de ambiente:

```bash
cp .env.example .env
```

2. Suba o PostgreSQL local:

```bash
docker compose up -d
```

3. Instale as dependências:

```bash
npm install
```

4. Rode as migrations e inicie a API:

```bash
npm run prisma:migrate
npm run db:seed
npm run dev
```

Por padrão, a API fica em:

```text
http://localhost:3000/api/v1
```

### Sem Docker

Nesta máquina, o Docker não está instalado. Para desenvolvimento local sem Docker, foi criada uma instância PostgreSQL dentro da pasta `.postgres-data`, usando a porta `55432`.

Comandos úteis:

```bash
npm run db:start:local
npm run db:status:local
npm run db:stop:local
```

O `.env` local usa:

```text
DATABASE_URL=postgresql://jeziel@localhost:55432/porto_certo_dev?schema=public
```

Para testar o app no celular durante o desenvolvimento local, mantenha também:

```text
ALLOW_DEV_AUTH=true
```

Assim o app pode autenticar no Firebase pelo celular e criar o perfil no backend local usando os headers de desenvolvimento. Para produção, use `ALLOW_DEV_AUTH=false` e configure `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL` e `FIREBASE_PRIVATE_KEY`.

## Teste no Celular via USB

No celular, `localhost` aponta para o próprio aparelho, não para o computador. Por isso, ao rodar o Flutter no dispositivo físico, use o IP local da máquina onde a API está rodando.

1. Descubra o IP local do computador:

```bash
hostname -I
```

Use o primeiro IP da rede local, por exemplo `192.168.1.50`.

2. Inicie o backend:

```bash
npm run db:start:local
npm run dev
```

3. Rode o app apontando para a API do computador:

```bash
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

Se o cadastro criar o usuário no Firebase, mas falhar antes de criar o perfil no PostgreSQL, remova esse usuário no Firebase Authentication e tente novamente após corrigir o endereço da API.

## Endpoints Iniciais

Com `ALLOW_DEV_AUTH=true`, os endpoints aceitam o header `x-dev-firebase-uid` para testes locais. Em produção, use `Authorization: Bearer <Firebase ID Token>`.

```bash
curl -X POST http://localhost:3000/api/v1/travelers \
  -H "content-type: application/json" \
  -H "x-dev-firebase-uid: dev-viajante-001" \
  -d '{"fullName":"Viajante Teste","cpf":"12345678909","email":"viajante.teste@portocerto.com"}'
```

```bash
curl http://localhost:3000/api/v1/travelers/me \
  -H "x-dev-firebase-uid: dev-viajante-001"
```

## Busca de Viagens

O seed inicial cria uma malha fluvial representativa envolvendo Amazonas, Pará e Macapá/AP, usando Santana/AP como porto operacional de atendimento a Macapá.

Rotas de exemplo:

- Manaus/AM -> Santarem/PA
- Manaus/AM -> Parintins/AM
- Parintins/AM -> Santarem/PA
- Santarem/PA -> Belem/PA
- Santarem/PA -> Santana/Macapa/AP
- Belem/PA -> Santana/Macapa/AP

Endpoints:

```bash
curl http://localhost:3000/api/v1/ports
```

```bash
curl "http://localhost:3000/api/v1/trips/search?origin=Manaus&destination=Santarem&date=2026-07-04"
```

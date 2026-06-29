# Porto Certo TP4

Aplicativo Flutter do viajante para o sistema Porto Certo.

## Arquitetura Atual

O aplicativo mobile não acessa diretamente o banco principal. A escolha arquitetural atual é:

```text
Flutter App -> API Backend Porto Certo -> PostgreSQL
```

O Firebase permanece no projeto para autenticação e serviços auxiliares, mas o Firestore não é mais usado como banco de dados principal.

## Desenvolvimento

```bash
flutter pub get
flutter run
```

Para executar no dispositivo Android detectado:

```bash
flutter run -d CPH2737
```

Quando a API backend local estiver rodando, informe a URL com `--dart-define`.
Em celular físico, use o IP da máquina na mesma rede:

```bash
flutter run -d CPH2737 \
  --dart-define=PORTO_CERTO_API_BASE_URL=http://SEU_IP_LOCAL:3000/api/v1 \
  --dart-define=PORTO_CERTO_USE_DEV_AUTH=true
```

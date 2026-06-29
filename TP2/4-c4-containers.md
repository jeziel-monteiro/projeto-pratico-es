# Visão Geral do Diagrama de Containers

<div align="justify">

O Diagrama de Containers é o segundo nível do modelo C4 e apresenta a arquitetura interna do sistema. Ele mostra os principais containers da aplicação, suas responsabilidades, as tecnologias utilizadas e a forma como se comunicam entre si e com sistemas externos. Essa visão permite compreender a organização da solução e o fluxo de informações entre seus componentes.


</div>

# Diagrama de Containers

<img width="16384" height="10094" alt="Untitled Diagram drawio (8)" src="https://github.com/user-attachments/assets/753fb0e2-1a1a-4e6d-8d23-e08e2a16d1fe" />

## Containers do Sistema

| Container                            | Tecnologia                     | Responsabilidade                                                                                                                                       |
| :------------------------------------: | :------------------------------: | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| App Mobile do Viajante               | Flutter (Dart)                 | Permite ao viajante cadastrar-se, buscar viagens, comprar passagens, consultar bilhetes, acompanhar embarcações em tempo real e utilizar recursos de acessibilidade. |
| Cache Local do Dispositivo           | Persistência local do app / SQLite | Armazena bilhetes digitais, favoritos e preferências do usuário para acesso offline e melhor experiência de uso.                                       |
| Painel Web/App do Proprietário       | Flutter Web (Dart)             | Permite ao proprietário cadastrar embarcações, gerenciar viagens, enviar notificações, acompanhar faturamento e operar a frota.                        |
| API Backend Porto Certo              | Render / Node.js / TypeScript | Centraliza as regras de negócio da plataforma, gerencia cadastro de usuários, viagens, reservas, pagamentos, notificações, webhooks e integrações externas. |
| Banco de Dados Principal             | PostgreSQL       | Armazena dados estruturados da plataforma em tabelas relacionais, incluindo usuários, dados de cadastro, embarcações, viagens, reservas, pagamentos e notificações. |
| Armazenamento de Arquivos            | Firebase Cloud Storage         | Armazena fotos das embarcações, bilhetes eletrônicos em PDF, boletos e demais documentos utilizados pelo sistema.                                      |
| Gateway de Pagamento                 | Mercado Pago                   | Processa pagamentos via cartão, PIX e boleto, realizando validações, compensações e operações de estorno.                                              |
| Serviço de Mensageria                | Firebase Cloud Messaging (FCM) | Envia notificações push e comunicações eletrônicas aos usuários sobre compras, alterações de viagens e avisos operacionais.                            |
| Serviço de Localização em Tempo Real | Mapbox                         | Fornece rastreamento das embarcações, atualização de posição geográfica e cálculo do tempo estimado de chegada (ETA).                                  |
| Serviço de Autenticação              | Firebase Authentication         | Realiza autenticação de usuários, validação de identidade e controle de acesso à plataforma.                                                           |

## Ligação dos Componentes

<div align="justify">

### Viajante → App Mobile do Viajante:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/fcf03880-65ad-4379-ba0f-7b71cb432f37" />
</div>

O Viajante interage com o aplicativo para cadastrar-se, buscar viagens, reservar passagens, realizar pagamentos, acompanhar embarcações em tempo real e acessar bilhetes digitais.

<br>

### App Mobile do Viajante → Cache Local do Dispositivo:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/bdcbdf12-0515-45e0-ad11-386eb46b13ae" />
</div>


O aplicativo armazena localmente bilhetes digitais, favoritos e preferências de acessibilidade por meio de uma camada de cache local no dispositivo, permitindo o uso offline de funcionalidades essenciais.

<br>

### App Mobile do Viajante → API Backend Porto Certo:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/4ebf9f6b-b1ed-421a-9efd-d90a71ad8daf" />
</div>

O aplicativo envia requisições para realizar cadastro, consultar viagens, criar reservas, processar compras, acessar bilhetes e obter informações atualizadas da plataforma.

<br> 

### App Mobile do Viajante → Serviço de Autenticação:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/297106c2-e5aa-40c5-8717-02dbdc878e00" />
</div>

O aplicativo utiliza o serviço de autenticação para validar a identidade do viajante e controlar o acesso às funcionalidades da plataforma.

<br>

### Proprietário → Painel Web/App do Proprietário:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/9746dd23-b8bd-47bb-b457-9326efbc67c0" />
</div>

O Proprietário utiliza o painel para cadastrar embarcações, criar viagens, iniciar e encerrar trajetos, emitir notificações e consultar faturamento.

<br>

### Painel Web/App do Proprietário → API Backend Porto Certo:
O painel envia comandos administrativos para gerenciar embarcações, viagens, passageiros, notificações, operações da frota e dados financeiros.

### Painel Web/App do Proprietário → Serviço de Autenticação:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/0fdb9903-2cff-4376-a89c-c1b6160a7149" />
</div>

O painel utiliza o serviço de autenticação para validar a identidade do proprietário e controlar o acesso às funcionalidades administrativas da plataforma.

<br>

### API Backend Porto Certo → Banco de Dados Principal:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/14a6f2df-a3e7-4ad0-b5f1-ab63aff66745" />
</div>

A API lê e grava dados estruturados do sistema no PostgreSQL, como usuários, dados de cadastro, embarcações, viagens, reservas, pagamentos, notificações e histórico operacional.

<br>

### API Backend Porto Certo → Armazenamento de Arquivos:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/f3531ab8-1e17-4f6e-9c4b-7f0420324e4e" />
</div>

A API armazena e recupera fotos de embarcações, bilhetes eletrônicos em PDF, boletos bancários e documentos da plataforma no Firebase Cloud Storage.

<br>

### API Backend Porto Certo → Gateway de Pagamento:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/729171ed-5dbf-4525-a54d-57efb4298b7e" />
</div>

A API envia dados de pagamento para processamento de cartão, PIX e boleto, recebendo confirmações, falhas, compensações e estornos.

<br>

### API Backend Porto Certo → Serviço de Mensageria:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/af310d73-731c-4fc2-b1e5-70773cb05880" />
</div>

A API aciona o serviço externo para enviar e-mails e notificações push sobre compras, bilhetes, alterações de viagem, cancelamentos e alertas operacionais.

<br>

### API Backend Porto Certo → Serviço de Localização em Tempo Real:

<div align="center">
  <img width="400" alt="viajante" src="https://github.com/user-attachments/assets/17bd18e0-a1d6-4bdd-bb8e-de04985fe80b" />
</div>

A API utiliza o serviço externo para gerenciar rastreamento, coordenadas das embarcações, exibição do mapa e cálculo do ETA em tempo real.


</div>



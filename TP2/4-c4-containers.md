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
| Cache Local do Dispositivo           | Persistência offline do Firebase Cloud Firestore | Armazena bilhetes digitais, favoritos e preferências do usuário para acesso offline e melhor experiência de uso.                                       |
| Painel Web/App do Proprietário       | Flutter Web (Dart)             | Permite ao proprietário cadastrar embarcações, gerenciar viagens, enviar notificações, acompanhar faturamento e operar a frota.                        |
| API Backend Porto Certo              | Render / Firebase Cloud Functions | Centraliza as regras de negócio da plataforma, gerencia cadastro de usuários, viagens, reservas, pagamentos, notificações, webhooks e integrações externas. |
| Banco de Dados Principal             | Firebase Cloud Firestore       | Armazena dados estruturados da plataforma em coleções NoSQL, incluindo usuários, dados de cadastro, embarcações, viagens, reservas, pagamentos e notificações. |
| Armazenamento de Arquivos            | Firebase Cloud Storage         | Armazena fotos das embarcações, bilhetes eletrônicos em PDF, boletos e demais documentos utilizados pelo sistema.                                      |
| Gateway de Pagamento                 | Mercado Pago                   | Processa pagamentos via cartão, PIX e boleto, realizando validações, compensações e operações de estorno.                                              |
| Serviço de Mensageria                | Firebase Cloud Messaging (FCM) | Envia notificações push e comunicações eletrônicas aos usuários sobre compras, alterações de viagens e avisos operacionais.                            |
| Serviço de Localização em Tempo Real | Mapbox                         | Fornece rastreamento das embarcações, atualização de posição geográfica e cálculo do tempo estimado de chegada (ETA).                                  |
| Serviço de Autenticação              | Firebase Authentication         | Realiza autenticação de usuários, validação de identidade e controle de acesso à plataforma.                                                           |

## Ligação dos Componentes

<div align="justify">

### Viajante → App Mobile do Viajante:
O Viajante interage com o aplicativo para cadastrar-se, buscar viagens, reservar passagens, realizar pagamentos, acompanhar embarcações em tempo real e acessar bilhetes digitais.

### App Mobile do Viajante → Cache Local do Dispositivo:
O aplicativo armazena localmente bilhetes digitais, favoritos e preferências de acessibilidade por meio da persistência offline do Firebase Cloud Firestore, permitindo o uso offline de funcionalidades essenciais.

### App Mobile do Viajante → API Backend Porto Certo:
O aplicativo envia requisições para realizar cadastro, consultar viagens, criar reservas, processar compras, acessar bilhetes e obter informações atualizadas da plataforma.

### App Mobile do Viajante → Serviço de Autenticação:
O aplicativo utiliza o serviço de autenticação para validar a identidade do viajante e controlar o acesso às funcionalidades da plataforma.

### Proprietário → Painel Web/App do Proprietário:
O Proprietário utiliza o painel para cadastrar embarcações, criar viagens, iniciar e encerrar trajetos, emitir notificações e consultar faturamento.

### Painel Web/App do Proprietário → API Backend Porto Certo:
O painel envia comandos administrativos para gerenciar embarcações, viagens, passageiros, notificações, operações da frota e dados financeiros.

### Painel Web/App do Proprietário → Serviço de Autenticação:
O painel utiliza o serviço de autenticação para validar a identidade do proprietário e controlar o acesso às funcionalidades administrativas da plataforma.

### API Backend Porto Certo → Banco de Dados Principal:
A API lê e grava dados estruturados do sistema no Firebase Cloud Firestore, como usuários, dados de cadastro, embarcações, viagens, reservas, pagamentos, notificações e histórico operacional.

### API Backend Porto Certo → Armazenamento de Arquivos:
A API armazena e recupera fotos de embarcações, bilhetes eletrônicos em PDF, boletos bancários e documentos da plataforma no Firebase Cloud Storage.

### API Backend Porto Certo → Gateway de Pagamento:
A API envia dados de pagamento para processamento de cartão, PIX e boleto, recebendo confirmações, falhas, compensações e estornos.

### API Backend Porto Certo → Serviço de Mensageria:
A API aciona o serviço externo para enviar e-mails e notificações push sobre compras, bilhetes, alterações de viagem, cancelamentos e alertas operacionais.

### API Backend Porto Certo → Serviço de Localização em Tempo Real:
A API utiliza o serviço externo para gerenciar rastreamento, coordenadas das embarcações, exibição do mapa e cálculo do ETA em tempo real.

</div>



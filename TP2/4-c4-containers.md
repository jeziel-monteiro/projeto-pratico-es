# Introdução

<div align="justify">
  
O Diagrama de Containers é o segundo nível do modelo C4 e apresenta a arquitetura interna do sistema. Ele mostra os principais containers da aplicação, suas responsabilidades, tecnologias utilizadas e a forma como se comunicam entre si e com sistemas externos. Essa visão permite compreender a organização da solução e o fluxo de informações entre seus componentes.

</div>

# Diagrama de Containers

<img width="16384" height="10263" alt="Untitled Diagram drawio (6)" src="https://github.com/user-attachments/assets/ad278033-ed89-4237-9b48-8fb9991fbba6" />

## Containers do Sistema

| Container                            | Tecnologia                     | Responsabilidade                                                                                                                                       |
| :------------------------------------: | :------------------------------: | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| App Mobile do Viajante               | Flutter (Dart)                 | Permite ao viajante buscar viagens, comprar passagens, consultar bilhetes, acompanhar embarcações em tempo real e utilizar recursos de acessibilidade. |
| Cache Local do Dispositivo           | SQLite                         | Armazena bilhetes digitais, favoritos e preferências do usuário para acesso offline e melhor experiência de uso.                                       |
| Painel Web/App do Proprietário       | Flutter Web (Dart)             | Permite ao proprietário cadastrar embarcações, gerenciar viagens, enviar notificações, acompanhar faturamento e operar a frota.                        |
| API Backend Porto Certo              | Node.js com NestJS             | Centraliza as regras de negócio da plataforma, gerencia viagens, reservas, pagamentos, notificações, usuários e integrações externas.                  |
| Banco de Dados Principal             | PostgreSQL                     | Armazena dados estruturados da plataforma, incluindo usuários, embarcações, viagens, reservas, pagamentos e notificações.                              |
| Armazenamento de Arquivos            | AWS S3                         | Armazena fotos das embarcações, bilhetes eletrônicos em PDF, boletos e demais documentos utilizados pelo sistema.                                      |
| Gateway de Pagamento                 | Mercado Pago                   | Processa pagamentos via cartão, PIX e boleto, realizando validações, compensações e operações de estorno.                                              |
| Serviço de Mensageria                | Firebase Cloud Messaging (FCM) | Envia notificações push e comunicações eletrônicas aos usuários sobre compras, alterações de viagens e avisos operacionais.                            |
| Serviço de Localização em Tempo Real | Mapbox                         | Fornece rastreamento das embarcações, atualização de posição geográfica e cálculo do tempo estimado de chegada (ETA).                                  |

## Ligação dos Componentes

<div align="justify">

### Viajante → App Mobile do Viajante:
O Viajante interage com o aplicativo para buscar viagens, reservar passagens, realizar pagamentos, acompanhar embarcações em tempo real e acessar bilhetes digitais.

### App Mobile do Viajante → Cache Local do Dispositivo:
O aplicativo armazena localmente bilhetes digitais, favoritos e preferências de acessibilidade, permitindo o uso offline de funcionalidades essenciais.

### App Mobile do Viajante → API Backend Porto Certo:
O aplicativo envia requisições para consultar viagens, criar reservas, processar compras, acessar bilhetes e obter informações atualizadas da plataforma.

### Proprietário → Painel Web/App do Proprietário:
O Proprietário utiliza o painel para cadastrar embarcações, criar viagens, iniciar e encerrar trajetos, emitir notificações e consultar faturamento.

### Painel Web/App do Proprietário → API Backend Porto Certo:
O painel envia comandos administrativos para gerenciar embarcações, viagens, passageiros, notificações, operações da frota e dados financeiros.

### API Backend Porto Certo → Banco de Dados Principal:
A API lê e grava dados estruturados do sistema, como usuários, embarcações, viagens, reservas, pagamentos, notificações e histórico operacional.

### API Backend Porto Certo → Armazenamento de Arquivos:
A API armazena e recupera fotos de embarcações, bilhetes eletrônicos em PDF, boletos bancários e documentos da plataforma.

### API Backend Porto Certo → Gateway de Pagamento:
A API envia dados de pagamento para processamento de cartão, PIX e boleto, recebendo confirmações, falhas, compensações e estornos.

### API Backend Porto Certo → Serviço de Mensageria:
A API aciona o serviço externo para enviar e-mails e notificações push sobre compras, bilhetes, alterações de viagem, cancelamentos e alertas operacionais.

### API Backend Porto Certo → Serviço de Localização em Tempo Real:
A API utiliza o serviço externo para gerenciar rastreamento, coordenadas das embarcações, exibição do mapa e cálculo do ETA em tempo real.

</div>

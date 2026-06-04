# Teck Stack
## Sobre o Teck Stack

<div align="justify">

O Tech Stack, ou pilha tecnológica, compreende o conjunto de tecnologias, como linguagens de programação, frameworks, bancos de dados e serviços, que formam a estrutura técnica de um produto digital. Essa composição determina a maneira como uma aplicação é desenvolvida, hospedada, operada e escalada, configurando-se como um dos pilares essenciais de qualquer projeto de software. Consequentemente, o Tech Stack impacta diretamente aspectos cruciais do sistema, incluindo performance, segurança, manutenção, velocidade de entrega e a capacidade de adaptação às novas demandas do mercado.

Para garantir eficiência e organização, a pilha tecnológica é comumente estruturada em diferentes camadas funcionais. Essa divisão engloba o front-end, responsável pela interface e pela experiência do usuário, o back-end, encarregado da lógica de negócio e das APIs, o banco de dados, destinado ao armazenamento das informações, a infraestrutura, que provê o suporte operacional da aplicação, e os serviços auxiliares, voltados para processos como autenticação, analytics, storage e monitoramento. Essa segregação estrutural é fundamental para facilitar a manutenção contínua, a escalabilidade e a integração entre os subsistemas.

## Modelo Visual do Sistema

## Tabela de Ferramentas e Tecnologias

### Passageiro (Aplicativo Móvel)

| Tecnologia | Camada | Justificativa |
| :--- | :--- | :--- |
| **Flutter (Dart)** | Frontend Mobile | Permite o desenvolvimento nativo para Android e iOS com um único código-base, entregando alta performance. |
| **SQLite** | Armazenamento Local (Cache) | Atua na persistência de dados essenciais diretamente no dispositivo móvel, permitindo que o usuário consulte dados sem cobertura de internet. |
| **Node.js com NestJS** | Backend (Servidor) | Processa as requisições de enviados pelo aplicativo móvel. |
| **PostgreSQL** | Banco de Dados Relacional | Centraliza o armazenamento de dados estruturados em tempo real e o histórico transacional. |
| **Firebase Authentication** | Autenticação | Controla o acesso seguro e mantém o estado da sessão ativo no aplicativo móvel de forma persistente. |
| **Firebase Cloud Messaging (FCM)** | Notificações Push | Recebe alertas automáticos vindos do servidor e os exibe instantaneamente na tela do smartphone do passageiro. |
| **Mercado Pago** | Processamento de Pagamentos | Viabiliza a integração direta com métodos de pagamento no aplicativo, processando transações via Pix, boleto ou cartão de crédito. |
| **Mapbox** | Mapas e Geolocalização | Renderiza o mapa interativo no aplicativo móvel, permitindo o acompanhamento geográfico e o cálculo do tempo estimado. |
| **AWS ECS (Fargate)** | Hospedagem Cloud | Garante o funcionamento estável do servidor da API que abastece o aplicativo móvel, escalando os recursos automaticamente. |
| **GitHub Actions e Fastlane** | CI/CD e Automação | Automatiza a execução de testes no código e realiza o envio automatizado das novas versões do aplicativo para as lojas virtuais. |

### Proprietário (Sistema Web)

| Tecnologia | Camada | Justificativa |
| :--- | :--- | :--- |
| **Flutter (Dart)** | Frontend Web | Viabiliza a construção do painel administrativo para navegadores utilizando a mesma linguagem do aplicativo mobile. |
| **Node.js com NestJS** | Backend (Servidor) | Recebe os comandos estruturados enviados pelo navegador do proprietário. |
| **PostgreSQL** | Banco de Dados Relacional | Gerencia e organiza as tabelas de faturamento bruto e líquido, os dados cadastrais e as escalas de horários. |
| **Firebase Authentication** | Autenticação | Fornece a validação de identidade e o controle de acesso do proprietário ao painel administrativo web de maneira unificada com o ecossistema mobile. |
| **Firebase Cloud Messaging (FCM)** | Central de Comunicação | Serve de ponte técnica para que o proprietário, através do painel web, dispare mensagens informativas e alertas operacionais em massa para todos os passageiros vinculados a uma rota específica. |
| **Mercado Pago** | Dashboard Financeiro | Fornece os dados transacionais de pagamentos e estornos processados para alimentar o painel de controle financeiro do proprietário com os cálculos de valores líquidos a receber. |
| **AWS ECS (Fargate)** | Hospedagem Cloud | Fornece a infraestrutura em nuvem para manter o painel administrativo web acessível continuamente para os operadores de transporte. |
| **AWS S3** | Armazenamento de Arquivos | Armazena de forma isolada e segura os documentos legais de navegação e as fotos das embarcações enviadas pelos proprietários através dos formulários web. |
| **GitHub Actions** | CI/CD e Automação | Realiza a compilação e a publicação automática do sistema web na infraestrutura de nuvem a cada atualização de código aprovada no repositório. |
| **Sentry** | Observabilidade | Captura falhas de execução, quebras de layout ou erros de comunicação com a API diretamente no navegador do proprietário, agilizando correções pela equipe técnica. |

### Tecnologias transversais

| Tecnologia | Camada | Justificativa |
| :--- | :--- | :--- |
| **RESTful e Swagger** | API e Documentação | O padrão RESTful assegura o processamento padronizado das requisições de ambos os clientes. O Swagger automatiza a documentação dos endpoints, garantindo uma integração transparente entre a equipe. |
| **Git e GitHub** | Controle de Versão | Atuam como o sistema base de versionamento, permitindo o trabalho colaborativo simultâneo, a revisão de código por pares e o rastreio seguro de todo o histórico de alterações da plataforma. |
| **Docker** | Conteneirização de Ambiente | Empacota a API do servidor e suas dependências em contêineres padronizados, garantindo que o código rode de maneira idêntica nas máquinas locais dos desenvolvedores e na nuvem. |
| **Postman** | Testes de Integração (API) | Facilita a simulação, o teste e a validação dos endpoints RESTful durante o desenvolvimento, servindo como uma ponte prática para o consumo de dados. |
| **TLS 1.3 e AES-256** | Segurança e Conformidade | Assegura a proteção rigorosa de dados sensíveis em trânsito e em repouso no banco de dados. Essencial para manter a conformidade do ecossistema com a LGPD. |
| **GitHub Projects** | Gestão de Tarefas | Centraliza a operação ágil da equipe de desenvolvimento, conectando os requisitos de negócio e o quadro de tarefas diretamente aos códigos e atualizações do repositório. |

</div>

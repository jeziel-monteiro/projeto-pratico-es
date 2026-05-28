# Teck Stack
## Sobre o Teck Stack

<div align="justify">

O Tech Stack, ou pilha tecnológica, compreende o conjunto de tecnologias, como linguagens de programação, frameworks, bancos de dados e serviços, que formam a estrutura técnica de um produto digital. Essa composição determina a maneira como uma aplicação é desenvolvida, hospedada, operada e escalada, configurando-se como um dos pilares essenciais de qualquer projeto de software. Consequentemente, o Tech Stack impacta diretamente aspectos cruciais do sistema, incluindo performance, segurança, manutenção, velocidade de entrega e a capacidade de adaptação às novas demandas do mercado.

Para garantir eficiência e organização, a pilha tecnológica é comumente estruturada em diferentes camadas funcionais. Essa divisão engloba o front-end, responsável pela interface e pela experiência do usuário, o back-end, encarregado da lógica de negócio e das APIs, o banco de dados, destinado ao armazenamento das informações, a infraestrutura, que provê o suporte operacional da aplicação, e os serviços auxiliares, voltados para processos como autenticação, analytics, storage e monitoramento. Essa segregação estrutural é fundamental para facilitar a manutenção contínua, a escalabilidade e a integração entre os subsistemas.

## Modelo Visual do Sistema

## Tabela de Tecnologias e Ferramentas

| Nome da Tecnologia | Camada | Justificativa de Uso |
| :--- | :--- | :--- |
| **Flutter (Dart)** | Frontend (Mobile) | Reduz o tempo e custo de desenvolvimento ao utilizar um único código-base nativo, Android e iOS. Apresenta alta performance na renderização de interfaces complexas. |
| **Isar Database** | Armazenamento Local (Offline) | Banco de dados NoSQL ultrarrápido, ideal para armazenar a fila de eventos locais, permitindo a sincronização posterior com o servidor. |
| **Bloc** | Gerenciamento de Estado | Padrão arquitetural corporativo que separa estritamente a interface da lógica de negócios. Baseia-se em eventos e estados, alinhando-se perfeitamente à lógica de Event Sourcing. |
| **Node.js + NestJS** | Backend (Lógica e Serviços) | Oferece uma arquitetura modular e TypeScript. O NestJS possui módulos nativos que padronizam e aceleram a implementação do padrão CQRS. |
| **RESTful + Swagger** | API (Padrão e Documentação) | O padrão RESTful assegura o processamento confiável das transações. O Swagger padroniza e automatiza a documentação dos endpoints, garantindo integração transparente. |
| **PostgreSQL** | Banco de Dados (Escrita) | Atua como banco relacional focado na integridade transacional, armazenando a corrente imutável de eventos, Event Sourcing, com eficiência utilizando colunas JSONB. |
| **MongoDB** | Banco de Dados (Leitura) | Banco NoSQL que proporciona indexação vertiginosa, entregando o catálogo de viagens de forma instantânea sem sobrecarregar o banco principal de transações. |
| **AWS SQS / SNS** | Mensageria Interna (Backend) | Espinha dorsal do padrão CQRS que interliga os bancos de dados. Propaga eventos de forma assíncrona sem a necessidade de gerenciar servidores dedicados. |
| **Firebase Authentication** | Autenticação e Autorização | Fornece segurança consolidada, simplifica a gestão de tokens de acesso e possui integração nativa, rápida e gratuita com o Flutter. |
| **Firebase Cloud Messaging** | Mensageria Externa (Push) | Serviço responsável por interagir diretamente com o usuário final, disparando alertas nos smartphones dos passageiros inscritos em tópicos de viagens. |
| **Mercado Pago** | Processamento de Pagamentos | Gateway com infraestrutura robusta para o mercado. Oferece suporte instantâneo ao Pix, fluxos de estorno e divisão de pagamentos para a retenção da taxa da plataforma. |
| **Mapbox** | Mapas e Geolocalização | Apresenta superioridade técnica na renderização e na capacidade de cache de mapas para uso offline. |
| **TLS 1.3 + AES-256** | Segurança e Conformidade | Assegura a proteção rigorosa de dados em trânsito e em repouso. Essencial para garantir a conformidade do sistema com as diretrizes da LGPD. |
| **AWS ECS (Fargate) + S3** | Infraestrutura Cloud | Modelo serverless que escala automaticamente a infraestrutura em picos de tráfego e fornece armazenamento durável para mídias e documentos das embarcações. |
| **GitHub Actions + Fastlane** | CI/CD (Automação de Deploy) | Automatiza testes e o deploy do backend na AWS nativamente. Agiliza a submissão simultânea de atualizações nas lojas de aplicativos. |
| **GitHub Projects + Sentry** | Gestão e Observabilidade | Centraliza a operação ágil conectando requisitos de negócio ao código-fonte e captura em tempo real erros silenciosos ou falhas de conectividade no aplicativo. |


</div>

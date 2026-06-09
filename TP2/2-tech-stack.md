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
| **Flutter (Dart)** | Frontend Mobile | Permite o desenvolvimento nativo para Android e iOS com um único código-base, entregando alta performance na renderização da interface do usuário. |
| **Firebase Cloud Firestore** | Banco de Dados e Cache Local | Armazena os dados em coleções NoSQL, utilizando o recurso nativo de persistência offline para permitir a consulta de informações mesmo em locais sem conectividade com a internet. |
| **Firebase Authentication** | Autenticação | Controla o acesso seguro e mantém o estado da sessão do usuário ativo no aplicativo móvel de forma persistente e integrada. |
| **Firebase Cloud Messaging** | Notificações Push | Recebe alertas automáticos vindos do servidor e os exibe instantaneamente na tela do smartphone, mantendo o usuário atualizado em tempo real. |
| **Mercado Pago** | Processamento de Pagamentos | Viabiliza a integração direta com métodos de pagamento no aplicativo, processando transações financeiras de forma segura e padronizada. |
| **Mapbox** | Mapas e Geolocalização | Renderiza o mapa interativo no aplicativo móvel, entregando funcionalidades avançadas de geolocalização e suporte a visualização otimizada. |
| **GitHub Actions e Fastlane** | CI/CD e Automação | Automatiza a execução de testes no código e realiza o envio automatizado das novas versões do aplicativo para as lojas virtuais. |

### Proprietário (Sistema Web)

| Tecnologia | Camada | Justificativa |
| :--- | :--- | :--- |
| **Flutter (Dart)** | Frontend Web | Viabiliza a construção do painel administrativo para navegadores utilizando a mesma linguagem do aplicativo mobile, facilitando o desenvolvimento de interfaces de gestão. |
| **Render** | Hospagem Web e Servidor | Hospeda a plataforma web e fornece o ambiente de servidores em nuvem contínuo necessário para a execução de integrações de back-end, como o recebimento de webhooks. |
| **Firebase Cloud Firestore** | Banco de Dados NoSQL | Centraliza os dados estruturados e registros operacionais em uma arquitetura escalável e distribuída em tempo real. |
| **Firebase Authentication** | Autenticação | Fornece a validação de identidade e o controle de acesso ao painel administrativo web de maneira unificada com o ecossistema mobile. |
| **Firebase Cloud Messaging** | Central de Comunicação | Serve de ponte técnica para o disparo de mensagens informativas e alertas operacionais em massa para os usuários da plataforma. |
| **Firebase Cloud Storage** | Armazenamento de Arquivos | Armazena de forma isolada e segura os documentos e arquivos de mídia necessários para a operação do sistema. |
| **Mercado Pago** | Dashboard Financeiro | Fornece os dados transacionais e de estornos processados para alimentar as ferramentas de controle financeiro da plataforma. |
| **Firebase Crashlytics** | Observabilidade | Captura falhas de execução ou erros de lógica em tempo real tanto na plataforma web quanto no aplicativo móvel, centralizando os relatórios de erros. |
| **GitHub Actions** | CI/CD e Automação | Realiza a compilação e a publicação automática do sistema web na infraestrutura de nuvem a cada atualização de código aprovada no repositório. |

### Tecnologias Transversais

| Tecnologia | Camada | Justificativa |
| :--- | :--- | :--- |
| **Git e GitHub** | Controle de Versão | Atuam como o sistema base de versionamento, permitindo o trabalho colaborativo simultâneo, a revisão de código por pares e o rastreio seguro de todo o histórico de alterações. |
| **GitHub Projects** | Gestão de Tarefas | Centraliza a operação ágil da equipe de desenvolvimento, conectando os requisitos técnicos e o quadro de tarefas diretamente aos códigos e atualizações do repositório. |

</div>

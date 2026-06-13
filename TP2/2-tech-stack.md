# Teck Stack
## Sobre o Teck Stack

<div align="justify">

O Tech Stack, ou pilha tecnológica, compreende o conjunto de tecnologias, como linguagens de programação, frameworks, bancos de dados e serviços, que formam a estrutura técnica de um produto digital. Essa composição determina a maneira como uma aplicação é desenvolvida, hospedada, operada e escalada, configurando-se como um dos pilares essenciais de qualquer projeto de software. Consequentemente, o Tech Stack impacta diretamente aspectos cruciais do sistema, incluindo performance, segurança, manutenção, velocidade de entrega e a capacidade de adaptação às novas demandas do mercado.

Para garantir eficiência e organização, a pilha tecnológica é comumente estruturada em diferentes camadas funcionais. Essa divisão engloba o front-end, responsável pela interface e pela experiência do usuário, o back-end, encarregado da lógica de negócio e das APIs, o banco de dados, destinado ao armazenamento das informações, a infraestrutura, que provê o suporte operacional da aplicação, e os serviços auxiliares, voltados para processos como autenticação, analytics, storage e monitoramento. Essa segregação estrutural é fundamental para facilitar a manutenção contínua, a escalabilidade e a integração entre os subsistemas.

## Modelo Visual do Sistema

<img width="9602" height="2662" alt="mapa visual" src="https://github.com/user-attachments/assets/27fce476-06de-441a-808e-eb512a9c8411" />

## Integração entre as Tecnologias

### Front-End 

* **Flutter (Dart):** Atua como o framework principal de desenvolvimento das interfaces visuais. No sistema, a tecnologia é responsável por renderizar tanto o aplicativo móvel dos passageiros quanto o painel administrativo web dos proprietários.

### Back-End e Banco de Dados 

* **Render:** Funciona como o provedor de hospedagem em nuvem para serviços de back-end. Na plataforma, ele abriga o servidor responsável por gerenciar integrações externas contínuas de forma isolada, atuando principalmente na escuta e processamento seguro dos avisos de pagamento enviados pelo gateway financeiro.
* **Firebase Cloud Firestore:** É o banco de dados NoSQL estruturado em documentos e coleções. Ele centraliza todas as informações dinâmicas da operação, como perfis de usuários, cadastros de frotas, rotas e registros de viagens. Fornece também o recurso de persistência offline nativo, garantindo que os passageiros acessem seus bilhetes digitais no celular mesmo em áreas portuárias sem conexão à internet.

### Segurança e Armazenamento

* **Firebase Authentication:** Opera como o gerenciador de identidades e controle de acessos. Garante a segurança arquitetural da plataforma ao validar a identidade dos viajantes no aplicativo e dos proprietários no sistema web, emitindo tokens de acesso e protegendo os dados sensíveis contra acessos não autorizados.
* **Firebase Cloud Storage:** Serve como o repositório em nuvem de arquivos estáticos e mídias pesadas. No escopo do projeto, a ferramenta é utilizada para armazenar de forma isolada as fotografias das embarcações e os documentos legais enviados pelos armadores por meio do painel de controle web.

### Comunicação e Serviços Externos

* **Firebase Cloud Messaging (FCM):** É o motor de entrega de mensagens instantâneas de sistema. O sistema utiliza esta ferramenta para disparar notificações Push diretamente para os smartphones dos passageiros, garantindo a entrega em tempo real de alertas sobre confirmações de compra, horários de embarque ou alterações imprevistas nas rotas.
* **Mercado Pago:** Atua como o gateway financeiro terceirizado. Participa do ecossistema assumindo o ambiente seguro de checkout e processando as transações via Pix, boleto ou cartão de crédito. Além de realizar a cobrança, envia os dados de conciliação financeira para alimentar o dashboard de faturamento dos proprietários.
* **Mapbox:** Fornece o serviço de inteligência geográfica e renderização visual de mapas. No aplicativo móvel, é acionado para exibir a malha hidroviária, plotar os trajetos exatos das embarcações em tempo real e fornecer estimativas de chegada, melhorando a previsibilidade logística para o viajante.

### Observabilidade e Qualidade

* **Firebase Crashlytics:** Opera como a ferramenta de telemetria e monitoramento de estabilidade. Trabalha nos bastidores registrando falhas fatais, quebras de interface e erros lógicos que ocorram nos dispositivos dos usuários finais, gerando relatórios consolidados que orientam a equipe técnica nas manutenções corretivas.

### CI/CD (Automação de Entregas)

* **GitHub Actions:** Funciona como o orquestrador de integração e entrega contínua em nuvem. A ferramenta compila, testa e publica automaticamente a versão mais recente do sistema web no ambiente de produção a cada nova atualização validada no repositório.
* **Fastlane:** Atua como a ferramenta de automação voltada especificamente para o ecossistema móvel. Trabalhando em conjunto com o GitHub Actions, empacota o código do aplicativo Flutter e envia as novas versões e atualizações de forma autônoma diretamente para as lojas virtuais.

### Gestão Global e Versionamento

* **Git:** É o sistema estrutural de controle de versão. Rastreia detalhadamente todas as alterações feitas no código-fonte da plataforma, permitindo a reversão de arquivos para versões anteriores e o trabalho simultâneo e isolado de múltiplos desenvolvedores.
* **GitHub:** É a plataforma de hospedagem do código em nuvem. Centraliza os repositórios do projeto, viabilizando as revisões de código por pares e mantendo o histórico de desenvolvimento seguro e acessível.
* **GitHub Projects:** Atua como a ferramenta de gestão ágil acoplada ao repositório. Organiza o fluxo produtivo por meio de quadros de tarefas, conectando as necessidades de negócio, relatórios de bugs e novos requisitos arquiteturais diretamente às linhas de código em desenvolvimento.

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

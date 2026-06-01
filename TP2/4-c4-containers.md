# Introdução

<div align="justify">
  
O Diagrama de Containers faz parte do modelo C4 (Context, Containers, Components e Code), sendo responsável por representar a arquitetura de alto nível interna de um sistema de software. Após a definição do Diagrama de Contexto - que mostra os usuários e sistemas externos que interagem com a plataforma - o Diagrama de Containers detalha como o sistema é dividido internamente em aplicações, serviços, bancos de dados e integrações.

No modelo C4, um “container” não representa necessariamente um container Docker, mas sim uma unidade executável ou implantável do sistema, como aplicações web, aplicativos móveis, APIs, bancos de dados, sistemas de armazenamento ou serviços externos integrados.

O objetivo principal do Diagrama de Containers é demonstrar:
- como os principais módulos do sistema se comunicam;
- onde as regras de negócio são executadas;
- quais tecnologias podem ser utilizadas;
- como ocorre a separação de responsabilidades;
- quais integrações externas existem;
- e como os dados circulam dentro da arquitetura.

No sistema Porto Certo, o Diagrama de Containers foi elaborado com base nas 15 histórias de usuário refinadas, contemplando funcionalidades como:
- busca e compra de passagens;
- pagamentos via PIX, boleto e cartão;
- rastreamento de embarcações em tempo real;
- armazenamento offline de bilhetes;
- acessibilidade;
- notificações em massa;
- cadastro de embarcações e viagens;
- gerenciamento financeiro;
- emissão de bilhetes digitais.

A arquitetura foi organizada de forma modular, separando claramente:
- interfaces dos usuários;
- backend central;
- armazenamento de dados;
- serviços externos;
- mecanismos de cache offline;
- e serviços de comunicação em tempo real.

# Diagrama de Containers - Sistema Porto Certo

<img width="26384" height="22436" alt="image" src="https://github.com/user-attachments/assets/7a390fad-f9d4-42a9-abb0-2b96b24e86fe" />

# Explicação Detalhada do Diagrama de Containers

O Diagrama de Containers do sistema Porto Certo representa a divisão interna da arquitetura da plataforma, demonstrando como as aplicações, serviços, banco de dados, armazenamento e integrações externas se comunicam para atender às funcionalidades descritas nas 15 histórias de usuário.

No modelo C4, o Diagrama de Containers possui o objetivo de mostrar os principais blocos executáveis do sistema, suas responsabilidades, tecnologias e relações de comunicação. Diferente do Diagrama de Contexto — que mostra apenas usuários e sistemas externos — o Diagrama de Containers detalha a estrutura interna da solução.

A arquitetura do Porto Certo foi organizada de forma modular para separar:
- interfaces dos usuários;
- regras de negócio;
- armazenamento de dados;
- serviços externos;
- comunicação em tempo real;
- persistência offline.

Essa separação reduz o acoplamento entre partes do sistema e facilita manutenção, escalabilidade, segurança e evolução futura da plataforma.

---

# Atores Principais do Sistema

O sistema possui dois atores principais:

## Viajante

O Viajante representa o usuário final da plataforma, responsável por:
- buscar viagens;
- consultar embarcações;
- comprar passagens;
- acompanhar viagens;
- acessar bilhetes digitais;
- utilizar recursos de acessibilidade.

Esse ator interage exclusivamente com o App Mobile do Viajante.

---

## Proprietário

O Proprietário representa o fornecedor do serviço fluvial e o responsável pelas embarcações e viagens cadastradas na plataforma.

Esse ator utiliza o Painel Web/App do Proprietário para:
- cadastrar embarcações;
- cadastrar viagens;
- iniciar e encerrar viagens;
- enviar notificações;
- consultar faturamento;
- gerenciar operações.

---

# Containers Internos do Sistema

# 1. App Mobile do Viajante

O App Mobile do Viajante é a principal interface utilizada pelos passageiros da plataforma.

Esse container é responsável pelas funcionalidades presentes nas seguintes histórias:
- US01 — Busca de viagens;
- US02 — Compra de passagens;
- US05 — Rastreamento em tempo real;
- US06 — Alto contraste;
- US07 — Formas de pagamento;
- US08 — Acessibilidade;
- US10 — Perfil de embarcações;
- US12 — Tutorial interativo;
- US13 — Cancelamento de passagens;
- US15 — Bilhetes offline.

O aplicativo permite:
- pesquisar viagens;
- visualizar embarcações;
- reservar assentos;
- realizar pagamentos;
- consultar bilhetes;
- acompanhar localização da embarcação;
- acessar funcionalidades offline;
- utilizar recursos de acessibilidade.

A comunicação principal do aplicativo ocorre com a API Backend Porto Certo.

Além disso, o aplicativo recebe dados do Serviço de Localização em Tempo Real para exibir:
- posição da embarcação;
- deslocamento no mapa;
- ETA (tempo estimado de chegada).

O aplicativo também se comunica com o Cache Local do Dispositivo para armazenar:
- bilhetes digitais;
- dados temporários;
- preferências visuais;
- informações offline.

Tecnologia:
- Flutter.

---

# 2. Painel Web/App do Proprietário

O Painel Web/App do Proprietário representa a interface administrativa da plataforma.

Esse container atende principalmente:
- US03 — Cadastro de embarcações;
- US04 — Notificações em massa;
- US09 — Cadastro de viagens;
- US11 — Dashboard financeiro;
- US14 — Iniciar e encerrar viagens.

Por meio desse painel, o proprietário consegue:
- cadastrar embarcações;
- cadastrar rotas e viagens;
- iniciar viagens;
- encerrar viagens;
- enviar notificações;
- consultar faturamento;
- acompanhar operações.

O painel envia todas as requisições para a API Backend Porto Certo, que executa as validações e regras de negócio.

O painel não possui acesso direto:
- ao banco de dados;
- ao gateway de pagamento;
- ao serviço de localização;
- aos serviços externos.

Essa decisão arquitetural aumenta a segurança e reduz acoplamento.

Tecnologia:
- React;
- PWA.

---

# 3. API Backend Porto Certo

A API Backend Porto Certo é o núcleo central da arquitetura.

Esse container concentra praticamente todas as regras de negócio da plataforma.

Ele atende diretamente todas as histórias do sistema, principalmente:
- controle de reservas;
- validação de assentos;
- autenticação;
- pagamentos;
- notificações;
- rastreamento;
- faturamento;
- geração de bilhetes;
- cancelamentos.

O Backend é responsável por:
- autenticar usuários;
- controlar permissões;
- validar disponibilidade;
- processar reservas;
- controlar status das viagens;
- processar pagamentos;
- solicitar estornos;
- gerar bilhetes;
- integrar serviços externos;
- controlar rastreamento em tempo real;
- enviar notificações;
- realizar cálculos financeiros.

A centralização das regras no Backend impede que validações importantes fiquem espalhadas entre aplicativos clientes.

Essa decisão é fundamental para:
- integridade dos dados;
- segurança;
- consistência das operações;
- controle financeiro.

O Backend se comunica com:
- Banco de Dados Principal;
- Gateway de Pagamento;
- Serviço de Mensageria;
- Serviço de Localização em Tempo Real;
- Armazenamento de Arquivos.

Tecnologias sugeridas:
- Node.js com NestJS;
  
---

# 4. Banco de Dados Principal

O Banco de Dados Principal é responsável pelo armazenamento persistente das informações da plataforma.

Esse container armazena:
- usuários;
- embarcações;
- viagens;
- reservas;
- pagamentos;
- notificações;
- rotas;
- faturamento;
- preferências.

Ele atende praticamente todas as histórias de usuário, pois concentra os dados operacionais do sistema.

O acesso ao banco é realizado exclusivamente pela API Backend Porto Certo.

Essa decisão evita:
- acessos indevidos;
- inconsistências;
- exposição direta dos dados.

Tecnologia:
- PostgreSQL;

---

# 5. Cache Local do Dispositivo

O Cache Local do Dispositivo é responsável pelo armazenamento offline do aplicativo móvel.

Esse container atende principalmente:
- US02 — Bilhete offline após compra;
- US06 — Persistência do alto contraste;
- US15 — Bilhetes acessíveis sem internet.

O cache armazena:
- bilhetes digitais;
- metadados de PDFs;
- preferências visuais;
- dados recentes;
- informações temporárias.

Sua existência é essencial porque os requisitos exigem funcionamento parcial do aplicativo sem conexão com a internet.

Isso permite que o viajante:
- visualize bilhetes;
- apresente documentos;
- utilize acessibilidade;
- consulte informações salvas;

mesmo offline.

Tecnologia:
- SQLite;
  
---

# 6. Armazenamento de Arquivos

O Armazenamento de Arquivos é responsável pelo armazenamento de arquivos binários da plataforma.

Esse container atende:
- US02 — Bilhetes PDF;
- US03 — Fotos de embarcações;
- US07 — Boletos PDF;
- US15 — Bilhetes digitais.

Nele ficam armazenados:
- fotos das embarcações;
- bilhetes em PDF;
- boletos bancários;
- documentos operacionais.

A API Backend Porto Certo realiza:
- upload;
- recuperação;
- gerenciamento dos arquivos.

Tecnologias sugeridas:
- Firebase Storage;
  
---

# 7. Gateway de Pagamento

O Gateway de Pagamento é um sistema externo responsável pelo processamento financeiro da plataforma.

Esse container atende:
- US02 — Compra de passagens;
- US07 — Múltiplas formas de pagamento;
- US13 — Cancelamentos e estornos.

Ele processa:
- cartão de crédito;
- PIX;
- boleto bancário;
- estornos;
- confirmações financeiras.

O sistema Porto Certo não armazena dados sensíveis de cartões.

Toda a tokenização financeira é delegada ao gateway externo, garantindo conformidade com requisitos de segurança.

O Gateway também envia:
- confirmações;
- falhas;
- compensações;
- webhooks financeiros.
  
---

# 8. Serviço de Mensageria

O Serviço de Mensageria é responsável pela comunicação com os usuários da plataforma.

Esse container atende:
- US02 — Envio de bilhetes;
- US04 — Notificações em massa;
- US07 — Confirmações financeiras;
- US13 — Avisos de cancelamento e estorno.

Ele realiza:
- envio de e-mails;
- push notifications;
- comprovantes;
- alertas;
- notificações operacionais.

A API Backend Porto Certo controla todos os disparos de mensagens.

---

# 9. Serviço de Localização em Tempo Real

O Serviço de Localização em Tempo Real é responsável pelo rastreamento das embarcações.

Esse container atende:
- US05 — Rastreamento em mapa;
- US14 — Controle de viagens em andamento.

Ele é responsável por:
- receber coordenadas GPS;
- atualizar posição das embarcações;
- calcular ETA;
- transmitir localização em tempo real;
- manter sincronização das viagens.

O serviço fornece os dados de rastreamento diretamente para o App Mobile do Viajante.

A API Backend Porto Certo controla quando o rastreamento pode acontecer, respeitando a regra de negócio que determina que a transmissão GPS só pode ocorrer enquanto a viagem estiver com status “Em Andamento”.

---

# Relações Entre os Containers

As relações do sistema foram organizadas para manter separação de responsabilidades.

## Fluxo do viajante

O Viajante acessa o App Mobile do Viajante.

O aplicativo:
- consulta viagens;
- realiza reservas;
- processa compras;
- consulta bilhetes;
- recebe localização em tempo real.

O aplicativo envia requisições para a API Backend Porto Certo.

---

## Fluxo do proprietário

O Proprietário utiliza o Painel Web/App do Proprietário.

O painel envia operações administrativas para a API Backend Porto Certo.

---

## Fluxo de persistência

A API Backend Porto Certo:
- lê;
- grava;
- atualiza;

dados no Banco de Dados Principal.

---

## Fluxo de arquivos

A API Backend Porto Certo:
- armazena;
- recupera;

arquivos do Armazenamento de Arquivos.

---

## Fluxo financeiro

A API Backend Porto Certo envia solicitações para o Gateway de Pagamento.

O Gateway retorna:
- aprovações;
- falhas;
- estornos;
- webhooks financeiros.

---

## Fluxo de notificações

A API Backend Porto Certo envia mensagens para o Serviço de Mensageria.

O serviço realiza os disparos para os usuários.

---

## Fluxo de localização

A API Backend Porto Certo controla o rastreamento.

O Serviço de Localização transmite:
- localização;
- movimentação;
- ETA;

para o App Mobile do Viajante.

---

# Considerações Arquiteturais

A arquitetura do Porto Certo foi organizada de forma modular e desacoplada.

As principais decisões arquiteturais foram:
- centralização das regras de negócio no Backend;
- separação entre aplicações cliente e serviços;
- uso de cache offline;
- integração com serviços externos especializados;
- isolamento das operações financeiras;
- separação do serviço de rastreamento em tempo real.

Essa estrutura reduz acoplamento e facilita:
- manutenção;
- escalabilidade;
- segurança;
- reutilização;
- evolução futura do sistema.

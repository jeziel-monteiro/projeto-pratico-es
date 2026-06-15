# Diagrama de Componentes 

<div align = "justify">

O Diagrama de Componentes funciona como um "zoom" detalhado sobre um Container específico do sistema que foi mapeado no nível anterior. O objetivo desta camada não é mostrar classes individuais ou linhas de código, mas sim identificar como o contêiner é dividido em blocos lógicos de código, chamados de componentes, que possuem responsabilidades únicas, fronteiras bem definidas e interfaces de comunicação claras.

Mapear os componentes permite compreender o encapsulamento das regras de negócio, o nível de dependência interna do código (acoplamento) e como as requisições que entram no contêiner são processadas até atingirem a camada de dados ou os serviços externos.

## **App Mobile do Viajante**

O objetivo deste diagrama é detalhar os blocos de construção internos de um único Container, revelando como as funcionalidades são agrupadas arquiteturalmente. Ele não chega ao nível minucioso de classes ou linhas de código de programação, mas mapeia os componentes lógicos de negócio (como controladores, serviços e repositórios), suas responsabilidades únicas, o encapsulamento das regras e como eles se comunicam através de interfaces claras para fazer o contêiner funcionar.

## Explicação geral do diagrama modelado

<img width="16384" height="10337" alt="viajante" src="https://github.com/user-attachments/assets/f917efb9-126f-4e23-83ac-2159a0387979" />

<br>
<br>

O diagrama modelado para o App Mobile do Viajante ilustra a separação de responsabilidades entre a interface com o usuário, a regra de negócio e a comunicação de dados. Globalmente, o fluxo demonstra o passageiro interagindo com cinco componentes visuais e de controle distintos (que lidam com cadastro, buscas, emissão de bilhetes e carteira). Para evitar acoplamento, nenhum desses componentes visuais acessa a nuvem diretamente; todos eles delegam o tráfego de dados para uma Camada de Repositório centralizada. O diagrama também destaca a resiliência do sistema com um cache de dados local e ilustra as saídas do aplicativo para consumir APIs especializadas, como mapas e pagamentos.

## Detalhamento por Partes

### Acesso e Gestão de Credenciais

<img width="7710" height="3350" alt="logineseguranca" src="https://github.com/user-attachments/assets/abf304f6-47f7-4c7f-9f1b-6d08dd43fd1c" />

<br>
<br>

Nesta parte do diagrama, observamos a porta de entrada do aplicativo. O usuário interage com dois controladores dedicados exclusivamente à segurança. O Controlador de Cadastro e Login captura e valida localmente as credenciais, enquanto o Controlador de Redefinição de Senha gerencia as solicitações de recuperação de conta. Ambos se comunicam com o repositório para validar a sessão, isolando a regra de validação visual das chamadas de rede.

### Núcleo de Negócios (Busca e Compra)

<img width="7810" height="3410" alt="buscaeemissao" src="https://github.com/user-attachments/assets/9f4a6645-69bb-4e51-8d58-0a4ed6592bc4" />

<br>
<br>

O Componente de Busca e Rotas processa a pesquisa por datas e portos de origem/destino. Assim que o usuário escolhe a viagem, o fluxo avança para o Componente de Emissão de Passagens, que é responsável por gerenciar a escolha de assentos (redes ou camarotes), validar os dados do passageiro e iniciar a etapa financeira para garantir a reserva no sistema.

### Resiliência e Persistência Offline

<img width="7810" height="3410" alt="buscaeemissao" src="https://github.com/user-attachments/assets/7fd82eca-c898-4582-ac88-c1b44563ee8b" />

<br> 
<br>

Esta seção destaca o diferencial arquitetural pensado para o contexto amazônico. O componente Meus Bilhetes (Carteira) renderiza os QR Codes de embarque. Para garantir que o passageiro consiga abrir essa carteira em portos remotos sem conexão de internet, tanto a Camada de Repositório quanto a Carteira interagem com a Persistência Offline do Firestore, que atua como um banco de dados local temporário, armazenando os dados essenciais baixados previamente.

### Comunicação com Sistemas Externos e Repositório Central

<img width="9220" height="1220" alt="externos" src="https://github.com/user-attachments/assets/57d33946-b75b-460c-a29d-1594c6f78247" />

<br>
<br>

O detalhamento final evidencia como o aplicativo delega responsabilidades especializadas para infraestruturas externas:

- A Camada de Repositório age como o canal único de comunicação com o ecossistema principal do Porto Certo (o Firebase na nuvem), sincronizando leituras e escritas via SDK.

- O componente de busca envia coordenadas diretamente para o Serviço de Mapas (Mapbox) para renderizar o trajeto de forma visual.

- O componente de passagens aciona o SDK seguro do Gateway de Pagamento (Mercado Pago) para realizar transações financeiras sem que o cartão do cliente transite pelos nossos servidores, garantindo conformidade com padrões de segurança.

<br>
<br>

## **Container: Painel Web do Proprietário**

## Visão geral do diagrama

Este diagrama de componentes mapeia o ecossistema interno do Painel Web do Proprietário. O foco aqui é demonstrar como a interface administrativa da plataforma está estruturada para lidar com as operações de retaguarda (backoffice). Através deste diagrama, fica claro como as funcionalidades de cadastro de frota, precificação e acompanhamento de vendas estão divididas em módulos isolados, garantindo que alterações na tela de agendamentos não afetem a geração de relatórios de faturamento.

## Explicação geral do diagrama modelado para o sistema

<img width="16384" height="9599" alt="Proprietario" src="https://github.com/user-attachments/assets/f8206629-0ffe-4cbd-895f-8198024ae550" />

<br>
<br>

O diagrama ilustra o Proprietário como o ator principal interagindo com uma aplicação desenvolvida em Flutter Web. A arquitetura divide a aplicação em cinco controladores e componentes principais (Autenticação, Gestão de Embarcações, Agendamento de Viagens, Relatórios e Repositório). O fluxo demonstra que a interface web não armazena dados complexos localmente, mas atua como um painel de comando que envia e requisita informações operacionais através da sua Camada de Repositório Web. Esta camada, por sua vez, é a única responsável por cruzar a fronteira do sistema e comunicar-se de forma segura com o backend na nuvem (Firebase).

## Detalhamento por Partes
<br>

### Acesso e Gestão de Credenciais

<img width="7720" height="3250" alt="loginesenha" src="https://github.com/user-attachments/assets/5dbeb33b-c817-47e3-a040-93e9eaac1e01" />

<br>
<br>

Para garantir o acesso restrito e seguro aos dados de faturamento e frota, o Proprietário interage inicialmente com os controladores de segurança. O Controlador de Cadastro e Login valida os acessos gerenciais, enquanto o Controlador de Redefinição de Senha providencia a recuperação segura de contas operacionais. Ambos enviam dados diretamente ao repositório central para validação remota de tokens.

### Gestão Operacional (Frota e Rotas)

<img width="7000" height="3220" alt="gestaoembarcacao" src="https://github.com/user-attachments/assets/f4073865-cfd0-4ce2-89e3-997e5126b8bf" />

<br>
<br>

Esta seção destaca as ferramentas centrais para a existência do negócio. O Componente de Gestão de Embarcações é onde o proprietário define as características físicas (capacidade, tipo de barco). Já o Componente de Agendamento de Viagens (Rotas) lida com a logística de horários e a lógica de precificação das passagens. O isolamento destes componentes permite escalar funcionalidades no futuro (como adicionar novos tipos de classes de viagem) de forma independente.

### Monitoramento e Controle

<img width="7820" height="1920" alt="manifesto" src="https://github.com/user-attachments/assets/6a460185-da0a-4762-b051-9e1be71c0264" />

<br> 
<br> 

Responsável pelo acompanhamento do sucesso do negócio, este componente funciona como um Dashboard tático. Ele requisita os dados de vendas para gerar relatórios financeiros e compilar o manifesto de embarque (lista oficial de passageiros), que é uma obrigação legal para o transporte fluvial.

<br> 
<br> 

### Comunicação de Dados (Repositório Central)

<img width="8420" height="1220" alt="camadarepositorio" src="https://github.com/user-attachments/assets/839d7289-cc1e-489a-83bb-8d771122f664" />

<br>
<br>

Para finalizar o fluxo do Painel Web, a Camada de Repositório Web atua como o maestro de todas as requisições geradas pelos componentes acima. Ela unifica as chamadas e comunica-se através dos SDKs oficiais com a infraestrutura principal do Firebase, enviando cadastros, lendo faturamentos e solicitando envios de alertas em massa para os passageiros.

<br>
<br>

## **Container: API Backend Porto Certo (Firebase & Node.js)**

## Visão geral do diagrama

O diagrama de componentes do Backend ilustra o "motor" central do Porto Certo. Diferente dos contêineres de Front-end (que lidam com interfaces visuais e estado de ecrã), este diagrama evidencia como os serviços de infraestrutura (Backend as a Service) se articulam para processar regras de negócio críticas, validar segurança de dados, armazenar ficheiros pesados e executar códigos no servidor (Serverless) em resposta a eventos externos, como a confirmação de um pagamento.

## Explicação geral do diagrama modelado para o sistema

<img width="16384" height="12036" alt="backend" src="https://github.com/user-attachments/assets/2fb34b37-ffb5-41fa-a87e-fb0f3edd397d" />

<br>
<br>

A arquitetura do Backend do Porto Certo baseia-se numa topologia nativa de nuvem utilizando o ecossistema Firebase e instâncias Node.js. O diagrama demonstra as aplicações cliente (App Mobile e Painel Web) a acederem aos serviços internos do backend: Serviço de Autenticação, Banco de Dados (Firestore) com as suas Regras de Segurança, o Armazenamento de Arquivos, as Cloud Functions e o Serviço de Mensageria (FCM). Notoriamente, o modelo evidencia que lógicas sensíveis – como a atualização de um bilhete para "Pago" ou o disparo de e-mails com PDFs – não ocorrem no telemóvel do utilizador, mas sim em ambiente controlado e isolado através das Cloud Functions, as quais recebem webhooks do Gateway de Pagamento.

## Detelhamento por Partes

### Segurança e Persistência de Dados

<img width="16384" height="6801" alt="clientes" src="https://github.com/user-attachments/assets/f76d51ac-c716-4d53-a28d-758c0d07cda8" />

<br>
<br>

Nesta primeira secção, detalha-se o acesso à informação estruturada. Os clientes solicitam um token seguro ao Serviço de Autenticação (Firebase Auth). Com este token, tentam ler ou gravar no Banco de Dados (Cloud Firestore). A transação só ocorre porque as Regras de Segurança (Security Rules) interpcetam o pedido, avaliam os privilégios do token (ex: garantindo que um viajante não possa apagar o barco de um proprietário) e bloqueiam ou liberam a persistência no banco.

### Processamento Financeiro e Lógica de Servidor

<img width="12510" height="3710" alt="gatway" src="https://github.com/user-attachments/assets/68a1dc18-ca60-4e6f-bbce-88ec59adcbae" />

<br>
<br>

Para evitar fraudes, o aplicativo não dita se uma passagem está paga. Em vez disso, o Gateway de Pagamento (Mercado Pago) externo comunica diretamente de servidor para servidor, enviando um webhook de confirmação. As Cloud Functions de Pagamento e Status (que rodam em Node.js no Render/Firebase) recebem este aviso de forma segura, validam a origem da requisição e procedem à alteração do status da passagem no Banco de Dados para "Confirmada".

### Gestão de Ficheiros e Alertas em Tempo Real

<img width="13410" height="3460" alt="mensageria" src="https://github.com/user-attachments/assets/c2ff625d-e171-4d3e-b649-e47f7dfa1e16" />

<br>
<br>

Após a aprovação de uma viagem, entram em ação os componentes periféricos do backend. O Firebase Cloud Storage atua no isolamento de binários, gerando e guardando o ficheiro PDF do bilhete eletrónico. Simultaneamente, as Cloud Functions acionam duas engrenagens de comunicação: o Firebase Cloud Messaging (FCM), para disparar uma Notificação Push para o telemóvel do passageiro alertando sobre o sucesso da transação, e a API do Serviço de Mensageria / E-mail (Externo) para enviar a fatura e o PDF do bilhete formalmente para a caixa de correio do cliente.

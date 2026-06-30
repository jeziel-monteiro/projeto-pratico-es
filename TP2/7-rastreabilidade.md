# Mapeamento de Rastreabilidade

<div align="justify">

Esta seção apresenta a análise detalhada de rastreabilidade técnica do sistema **Porto Certo**, demonstrando como cada uma das histórias de usuário refinadas se relacionam com as decisões arquiteturais propostas pela equipe. Para garantir a solidez e a viabilidade do projeto, cada User History foi mapeado utilizando o **Modelo C4**.


### US01: Busca Avançada de Viagens
**História:** Enquanto viajante, desejo buscar por viagens informando origem, destino e data, para encontrar opções de transporte disponíveis que atendam à minha necessidade.

* **Diagrama de Contexto:** Relaciona-se com o ator **Viajante**, que interage com o sistema **Porto Certo** para pesquisar as opções de rotas disponíveis na malha fluvial.
* **Diagrama de Contêiner:** Ocorre quando o **App Mobile do Viajante (Flutter)** envia uma requisição de leitura HTTP para a **API Backend Porto Certo (Firebase Cloud Functions)**, que por sua vez consulta as rotas no **Banco de Dados Principal (Firebase Cloud Firestore)**.
* **Diagrama de Componentes:** No App Mobile, o gatilho é disparado pelo componente **Busca e Rotas**. Ele se comunica com a **Camada de Repositório**, que efetua a chamada via SDK para o Firestore.
* **Diagrama de Classes:** Mapeado na classe filha `Viajante` através do método público `+ buscarViagens(origem: String, destino: String, data: LocalDate): List`. Este método consulta a classe `Viagem` para extrair os atributos `- portoOrigem`, `- portoDestino`, `- dataHoraSaida`, além de ler os dados da `Embarcacao` vinculada para exibir o nome e acomodações.

---

### US02: Compra e Checkout de Passagens
**História:** Enquanto viajante, desejo realizar a compra de uma passagem fluvial informando meus dados e efetuando o pagamento, para garantir minha reserva na embarcação e receber o bilhete eletrônico de forma automatizada.

* **Diagrama de Contexto:** O **Viajante** inicia a compra de passagens no **Porto Certo**, que se integra ao sistema externo **Gateway de Pagamento** para processar a transação monetária.
* **Diagrama de Contêiner:** O **App Mobile do Viajante** envia os dados de checkout para a **API Backend Porto Certo**. O backend valida os assentos no **Cloud Firestore**, realiza a tokenização do cartão com o **Gateway de Pagamento (Mercado Pago)** e salva o arquivo final gerado no **Armazenamento de Arquivos (Cloud Storage)**.
* **Diagrama de Componentes:** No mobile, o componente **Emissão de Passagem** inicia o checkout e envia os dados gerenciais para a **Camada de Repositório**. No backend, o componente **Cloud Functions de Pagamento e Status** recebe o webhook do gateway, atualiza as coleções e armazena o bilhete PDF no **Armazenamento de Arquivos**.
* **Diagrama de Classes:** A classe `Viajante` se associa a `Bilhete` (cardinalidade 1 para 0..*). O processo de pagamento invoca a classe `Pagamento`, disparando o método `+ processarCheckout(): bool` que atualiza as enumerações `StatusPagamento` (para APROVADO) e `StatusBilhete` (para EMITIDO), preenchendo o atributo `- pdfUrl: String`.

---

### US03: Cadastro de Frota e Embarcações
**História:** Enquanto proprietário, desejo cadastrar os dados, fotos e especificações técnicas das minhas embarcações, para que os viajantes possam conhecer a infraestrutura e comodidades oferecidas antes de realizarem a compra da passagem.

* **Diagrama de Contexto:** Relaciona-se com o ator **Proprietário**, que interage com o hub de serviços do **Porto Certo** para cadastrar e gerenciar sua frota naval.
* **Diagrama de Contêiner:** O **Painel Web/App do Proprietário (Flutter Web)** envia dados textuais para a **API Backend Porto Certo** (salvando-os no **Cloud Firestore** com o status "Em Análise") e faz o upload de imagens pesadas diretamente para o **Armazenamento de Arquivos (Cloud Storage)**.
* **Diagrama de Componentes:** No Painel Web, a ação é executada pelo componente **Gestão de Embarcações**. Ele valida os campos obrigatórios localmente, envia os arquivos de imagem para o **Armazenamento de Arquivos** e requisita a gravação do registro naval através da **Camada de Repositório Web** para o Firebase.
* **Diagrama de Classes:** Mapeado na classe `Proprietario` através do método `+ cadastrarEmbarcacao(dados: Embarcacao): bool`. Este método instancia a classe `Embarcacao`, preenchendo os atributos `- registroOficial`, `- capacidadePassageiros`, `- tipoAcomodacao`, `- velocidadeMedia` e a lista `- fotosUrls: List<String>`, inicializando o status da embarcação como `EM_ANALISE`.

---

### US04: Notificação em Massa para Passageiros
**História:** Enquanto proprietário, desejo enviar notificações em massa para os viajantes que compraram passagens para uma viagem específica, para informá-los rapidamente sobre imprevistos, atrasos, mudanças de rota ou cancelamentos.

* **Diagrama de Contexto:** O **Proprietário** emite as notificações através do **Porto Certo**, que delega o disparo em massa para os viajantes afetados através do sistema externo de **Serviço de Mensageria**.
* **Diagrama de Contêiner:** O **Painel Web do Proprietário** solicita o disparo à **API Backend Porto Certo**. O backend consulta a lista de passageiros afetados no **Firestore** e aciona o contêiner externo **Serviço de Mensageria (Firebase Cloud Messaging - FCM)** para enviar os alertas *push* e e-mails.
* **Diagrama de Componentes:** O componente **Relatórios e Manifesto** ou **Agendamento de Viagens** aciona a **Camada de Repositório Web**. No servidor, o componente **Serviço de Mensageria (FCM)** recebe as diretrizes, consulta o banco e dispara as mensagens em background para o smartphone do viajante sem revelar os dados sensíveis dos clientes ao proprietário.
* **Diagrama de Classes:** A classe `Proprietario` interage com a classe `Notificacao` através da classe `Viagem`. A classe `Notificacao` executa o método `+ dispararEmMassa(id_viagem: String): void`, validando se o `StatusViagem` é AGENDADA ou EM_ANDAMENTO, e salvando o registro do envio no atributo `- mensagem: String`.

---

### US05: Mapa Interativo e Telemetria
**História:** Enquanto viajante, desejo acompanhar o deslocamento do transporte em tempo real em um mapa interativo, para reduzir a incerteza sobre minha localização exata e planejar meu desembarque.

* **Diagrama de Contexto:** O aplicativo consome dados geográficos e mapas em tempo real vindos do sistema externo **Serviço de Geolocalização** (como o Mapbox).
* **Diagrama de Contêiner:** A **API Backend Porto Certo** recebe os pacotes de telemetria enviados pela embarcação, atualiza o **Cloud Firestore** a cada 10 segundos, e o **App Mobile do Viajante** consome essas coordenadas consumindo a API do **Serviço de Localização em Tempo Real (Mapbox)**.
* **Diagrama de Componentes:** No App Mobile, o componente **Busca e Rotas** requisita as coordenadas da viagem em andamento através da **Camada de Repositório**, acionando o **Serviço de Mapa** via SDK para renderizar o ícone flutuante do barco na tela do cliente.
* **Diagrama de Classes:** Mapeado na classe `Viagem` através do atributo `- posicaoAtual: Coordenadas` e do método de atualização contínua `+ atualizarTelemetria(posicao: Coordenadas): void`. Este método altera a posição em tempo real do veículo no mapa enquanto o ENUM `StatusViagem` apontar para `EM_ANDAMENTO`.

---

### US06: Ativação do Modo de Alto Contraste (Acessibilidade)
**História:** Enquanto viajante com baixa visão, desejo ativar um modo de alto contraste na interface, para que eu possa distinguir claramente os textos, botões e elementos visuais.

* **Diagrama de Contexto:** O **Viajante** interage diretamente com a interface do software **Porto Certo** para customizar suas preferências de exibição visual.
* **Diagrama de Contêiner:** A alteração ocorre localmente no **App Mobile do Viajante** e sua preferência de acessibilidade é salva de forma síncrona no contêiner de **Cachê Local do Dispositivo (Firestore Offline Cache)** para persistência persistente.
* **Diagrama de Componentes:** No App do Viajante, o componente **Meus Bilhetes** ou as configurações gerais manipulam essa flag. O estado visual é gerenciado localmente pelo **Gerenciador de Cache Local** para manter a paleta ativa mesmo que o app inicie sem internet.
* **Diagrama de Classes:** Mapeado na classe filha `Viajante` através da propriedade booleana `- modoAltoContraste: boolean` e do método `+ favoritarTrecho(...)` ou rotinas internas de persistência local, salvando a configuração ligada ao ID da conta.

---

### US07: Seleção de Formas de Pagamento
**História:** Enquanto viajante, desejo escolher entre diferentes formas de pagamento no momento de finalizar a compra da minha passagem fluvial, para que eu possa utilizar a opção mais conveniente para o meu planejamento financeiro.

* **Diagrama de Contexto:** O sistema interage com o **Gateway de Pagamento** para disponibilizar e validar as diferentes opções de transação (PIX, Crédito e Boleto).
* **Diagrama de Contêiner:** O **App Mobile do Viajante** renderiza as opções de pagamento. Ao selecionar o método, a **API Backend Porto Certo** processa as regras de negócio de antecedência (como a trava de 72 horas para boletos) consultando o **Cloud Firestore** e comunicando-se com o **Gateway de Pagamento**.
* **Diagrama de Componentes:** O componente **Emissão de Passagem** lida com a lógica de renderização e desabilita o boleto se houver menos de 72h para a viagem. Ele envia os dados para a **Cloud Functions de Pagamento e Status**, que orquestra a comunicação com o gateway financeiro externo.
* **Diagrama de Classes:** A escolha do usuário alimenta o atributo `- metodoPagamento: String` dentro da classe `Pagamento`. Caso o boleto seja aceito, o status da reserva assume o ENUM de `StatusPagamento` como `PENDENTE`, aguardando a alteração de estado para `APROVADO` pela API de conciliação do backend.

---

### US08: Suporte Geral a Tecnologias Assistivas (Acessibilidade)
**História:** Enquanto viajante com deficiência visual (cegueira ou baixa visão), desejo que a interface do aplicativo suporte plenamente tecnologias assistivas e padrões de acessibilidade.

* **Diagrama de Contexto:** O ator **Viajante** utiliza leitores de tela integrados ao seu sistema operacional para consumir de forma acessível os dados fornecidos pelo ecossistema **Porto Certo**.
* **Diagrama de Contêiner:** O suporte é implementado nativamente dentro do código do **App Mobile do Viajante (Flutter/Dart)**, fornecendo semântica de componentes compatível com o TalkBack/VoiceOver e interagindo com o **Cachê Local do Dispositivo** para leitura linear de passagens offline.
* **Diagrama de Componentes:** Todos os componentes visuais do App Mobile (**Meus Bilhetes**, **Busca e Rotas**, **Emissão de Passagem**) são desenvolvidos seguindo as diretrizes de acessibilidade, injetando *labels* descritivos e garantindo uma ordem lógica na árvore de componentes gerenciada pelo framework.
* **Diagrama de Classes:** Reflete-se na estrutura semântica dos atributos legíveis por leitores de tela. Na classe `Bilhete`, o atributo `- codigoValidacaoVisual: String` armazena as informações estruturadas de forma que possam ser lidas linearmente (Nome, CPF, Assento) sem depender de elementos puramente visuais na inspeção offline do porto.

---

### US09: Planejamento e Programação de Viagens Fluviais
**História:** Enquanto proprietário, desejo cadastrar os detalhes de uma nova viagem fluvial, incluindo a embarcação utilizada, rota, data, horários e frequência, para que eu possa disponibilizar a venda de passagens aos viajantes e gerenciar minha oferta de transporte na plataforma.

* **Diagrama de Contexto:** O ator **Proprietário** interage com o elemento de software central **Porto Certo** enviando os parâmetros logísticos de rota, embarcação e cronograma para compor a oferta de transporte fluvial na região amazônica.
* **Diagrama de Contêiner:** O **Painel Web/App do Proprietário (Flutter Web/Dart)** captura as informações do formulário e as envia para a **API Backend Porto Certo (Firebase Cloud Functions)**. O backend valida as travas cronológicas e de capacidade, persistindo o novo registro de viagem no **Banco de Dados Principal (Firebase Cloud Firestore)**, tornando o inventário de assentos visível para o contêiner de buscas do passageiro.
* **Diagrama de Componentes:** 
    * No front-end do painel web, a Feature de **Agendamento de Viagens (Rotas)** gerencia a interface de cadastro, renderiza a tela de resumo para revisão e exibe a caixa de diálogo de confirmação.
    * A requisição é despachada para a **Camada de Repositório Web**, que interage via SDK com o banco NoSQL após passar pelos critérios de privilégio de escrita impostos pelo componente de **Regras de Segurança (Firestore Security Rules)**.
* **Diagrama de Código (Classes):** Aciona o método público `+ agendaViagem()` implicitamente gerenciado nas ações de rota da classe `Proprietario`. A operação instancia um novo objeto da classe `Viagem`, herdando e validando as referências `- id_proprietario` e `- id_embarcacao` (exigindo que a classe `Embarcacao` associada possua o atributo `- statusValidacao` igual a `"Validada"`). O construtor preenche as propriedades de trajeto `- portoOrigem`, `- portoDestino` e o preço base em `- precoPassagem`, definindo o estoque inicial no atributo numérico `- assentosDisponiveis` (que é travado para não exceder o campo `- capacidadePassageiros` do barco selecionado) e iniciando a enumeração `StatusViagem` com o valor literal `AGENDADA`.

---

### US10: Visualização do Perfil da Embarcação
**História:** Enquanto viajante, desejo acessar uma página de perfil detalhada de cada embarcação (contendo fotos, especificações técnicas e comodidades), para que eu possa comparar diferentes opções de transporte.

* **Diagrama de Contexto:** O **Viajante** consome dados de infraestrutura sobre as embarcações comerciais registradas e disponibilizadas na plataforma central do **Porto Certo**.
* **Diagrama de Contêiner:** O **App Mobile do Viajante** solicita os dados do barco. A **API Backend Porto Certo** faz uma leitura na coleção de embarcações do **Firebase Cloud Firestore** (filtrando apenas as que possuem o status "Validada") e recupera os caminhos das imagens guardadas no **Armazenamento de Arquivos**.
* **Diagrama de Componentes:** No App do Viajante, o componente **Busca e Rotas** faz a requisição do perfil do navio, acionando a **Camada de Repositório** para efetuar a leitura estritamente como *read-only* na coleção de embarcações do Firebase.
* **Diagrama de Classes:** A classe `Viajante` realiza uma leitura de associação associada à classe `Embarcacao`. Ela acessa os dados públicos de infraestrutura da embarcação (`- nome`, `- registroOficial`, `- capacidadePassageiros`, `- comodidades`) sem permissão para executar métodos mutantes, como o `+ editarDados()`, exclusivo do proprietário.

---

### US11: Painel de Controle Financeiro (Dashboard)
**História:** Enquanto proprietário, desejo acessar um painel de controle financeiro (Dashboard de Faturamento) com o cálculo automatizado do valor bruto e do valor líquido a receber das minhas viagens, para que eu possa gerenciar a receita do meu negócio com transparência.

* **Diagrama de Contexto:** O **Proprietário** extrai relatórios gerenciais e dados de inteligência de faturamento consolidados diretamente do sistema **Porto Certo**.
* **Diagrama de Contêiner:** O **Painel Web do Proprietário** requisita o faturamento. A **API Backend Porto Certo** executa as Cloud Functions de agregação, calcula os valores com base no histórico de passagens vendidas contido no **Cloud Firestore** e exibe os indicadores na tela do usuário.
* **Diagrama de Componentes:** No Painel Web, a ação é mapeada no componente **Relatórios e Manifesto (Dashboard)**. Ele faz chamadas de agregação para a **Camada de Repositório Web**, compilando em tempo real o balanço financeiro e as métricas de faturamento por tipo de pagamento.
* **Diagrama de Classes:** Mapeado na classe `Proprietario` através do método público `+ visualizarFaturamento(): Relatorio`. Este método faz a soma do faturamento lendo o atributo `- valorTotal` da classe `Pagamento` em todas as passagens vendidas para as instâncias de `Viagem` daquele proprietário, aplicando as deduções e descontos operacionais do negócio.

---

### US12: Assistente Interativo de Tela (Tutorial)
**História:** Enquanto viajante, desejo ter acesso a um assistente interativo com instruções passo a passo (tutorial em tela), para que eu possa entender facilmente como utilizar as funcionalidades do aplicativo.

* **Diagrama de Contexto:** O **Viajante** consome dicas contextuais geradas de forma dinâmica e interativa em tempo real na tela do sistema **Porto Certo**.
* **Diagrama de Contêiner:** O fluxo do assistente ocorre inteiramente no front-end dentro do **App Mobile do Viajante**. O estado de conclusão do tutorial (se o usuário clicou em "Pular" ou já concluiu o fluxo no primeiro acesso) é registrado no **Cachê Local do Dispositivo** para evitar reibições inconvenientes.
* **Diagrama de Componentes:** Mapeado como uma camada de sobreposição transversal (*Overlay*) que engloba os componentes de **Busca e Rotas** e **Emissão de Passagem**, gerenciando balões textuais curtos de até 100 caracteres de acordo com o foco da tela atual do cliente.
* **Diagrama de Classes:** Controlado localmente através dos metadados de sessão do `Viajante`. A flag de controle de primeira execução utiliza o contêiner de armazenamento do estado local mapeado no ciclo de vida da aplicação móvel.

---

### US13: Solicitação de Cancelamento pelo Viajante
**História:** Enquanto viajante, desejo ter a opção de cancelar uma passagem adquirida diretamente pelo aplicativo, para que eu possa reaver o valor investido ou liberar o assento em caso de imprevistos.

* **Diagrama de Contexto:** O **Viajante** solicita o cancelamento ao **Porto Certo**, que aciona de forma transparente o sistema externo **Gateway de Pagamento** para processar o estorno financeiro (refund) do valor pago.
* **Diagrama de Contêiner:** O **App Mobile do Viajante** envia o pedido de cancelamento. A **API Backend Porto Certo** valida a regra de antecedência de 24 horas no **Cloud Firestore**, aciona o estorno automático junto ao **Gateway de Pagamento (Mercado Pago)** e devolve o assento para o estoque de vagas do barco.
* **Diagrama de Componentes:** No aplicativo, o botão reside no componente **Meus Bilhetes**. A solicitação atinge as **Cloud Functions de Pagamento e Status** no backend, que alteram o status da passagem, liberam a poltrona na coleção e disparam a requisição via API HTTP para a operadora financeira externa.
* **Diagrama de Classes:** Ação gerenciada a partir de uma instância da classe `Bilhete`. O método altera a propriedade do ENUM `StatusBilhete` para `CANCELADO`, e atualiza de forma síncrona a instância associada de `Pagamento`, mudando o seu `StatusPagamento` para `ESTORNADO`.

---

### US14: Programação e Controle de Viagens Fluviais
**História:** Enquanto proprietário ou comandante da embarcação, desejo dispor de um comando para iniciar e encerrar oficialmente uma viagem agendada, para que o aplicativo passe a transmitir os dados de localização geográfica (GPS).

* **Diagrama de Contexto:** O **Proprietário** (ou comandante) envia os comandos logísticos ao **Porto Certo**, ativando a integração com o **Serviço de Geolocalização** da plataforma.
* **Diagrama de Contêiner:** O **Painel Web do Proprietário** altera o status da rota. A **API Backend Porto Certo** grava a mudança no **Cloud Firestore** mudando a viagem para "Em Andamento", o que ativa o gatilho para coletar e expor as coordenadas de telemetria daquela rota para o público.
* **Diagrama de Componentes:** No painel de controle do armador, o componente **Agendamento de Viagens (Rotas)** fornece os comandos "Iniciar Viagem" e "Encerrar Viagem", enviando os comandos de persistência através da **Camada de Repositório Web** para o banco de dados principal.
* **Diagrama de Classes:** Mapeado na classe `Viagem` através do gerenciamento da propriedade de estado do ENUM `StatusViagem`. O clique nos botões executa a transição lógica de estados do ciclo logístico da rota: de `AGENDADA` para `EM_ANDAMENTO`, e posteriormente para `CONCLUIDA`.

---

### US15: Cédula de Embarque Offline
**História:** Enquanto viajante, desejo que os meus bilhetes de passagem sejam salvos automaticamente no armazenamento local do meu dispositivo após a compra, para que eu consiga apresentar a cédula de embarque digital mesmo sem conectividade com a internet.

* **Diagrama de Contexto:** O **Viajante** utiliza a cédula gerada pelo aplicativo **Porto Certo** de forma visual, garantindo o acesso à embarcação de forma autônoma mesmo em portos isolados e sem sinal de rede das operadoras.
* **Diagrama de Contêiner:** Logo após o checkout, os dados do voucher são guardados silenciosamente no contêiner **Cachê Local do Dispositivo (Firestore Offline Cache)**. Se o app for aberto em modo offline, o sistema pula a API em nuvem e lê diretamente desse repositório local protegido.
* **Diagrama de Componentes:** O componente **Meus Bilhetes** consome diretamente os dados gerenciados pelo **Gerenciador de Cache Local**. Esse componente faz o mapeamento do arquivo binário e dos metadados locais para desenhar na interface do usuário os campos lógicos da passagem de forma estritamente visual.
* **Diagrama de Classes:** A classe `Bilhete` encapsula essa responsabilidade através do método público `+ gerarPdfOffline(): void`. Este método formata os atributos imutáveis da classe (`- id_bilhete`, `- codigoValidacaoVisual`, `- pdfUrl`) e lê as propriedades associadas de `Viagem` para montar o layout legível e contrastante para conferência visual.

---

### US16: Cadastro de Viajante (Passageiro)
**História:** Enquanto viajante, desejo me cadastrar na plataforma informando meus dados, para que eu possa ter acesso às funcionalidades do aplicativo.

* **Diagrama de Contexto:** O processo de criação de conta e autenticação no **Porto Certo** se integra de forma transparente com o sistema de segurança externo **Serviço de Autenticação**.
* **Diagrama de Contêiner:** O **App Mobile do Viajante** envia as credenciais. A **API Backend Porto Certo** intercepta o fluxo, valida a maioridade, delega a criação do usuário seguro para o **Serviço de Autenticação (Firebase Authentication)** e salva o perfil complementar com a senha forte criptografada no banco NoSQL **Cloud Firestore**.
* **Diagrama de Componentes:** No front-end mobile, o componente **Controlador de Cadastro e Login** valida localmente os formatos de entrada, e-mail/telefone e força da senha. Após a validação local, envia os dados via **Camada de Repositório** para o Firebase efetuar o preenchimento seguro da conta.
* **Diagrama de Classes:** Executado através da classe filha `Viajante` invocando os métodos sequenciais `+ solicitarPreCadastro(emailOrTelefone: String): bool` (MFA de 4 dígitos) e `+ completarCadastro(nome: String, sobrenome: String, idade: int, senha: String, confirmacao: String): bool`. Os dados comuns são herdados e salvos de forma protegida na propriedade `# senhaHash: String` da classe mãe `<abstract> Usuario`.

---

### US17: Cadastro de Proprietário
**História:** Enquanto Proprietário, desejo me cadastrar na plataforma informando meus dados, para que eu possa ter acesso às funcionalidades do aplicativo.

* **Diagrama de Contexto:** O **Proprietário** realiza o cadastro de sua empresa no **Porto Certo**, que interage com o **Serviço de Autenticação** externo para validar os privilégios administrativos corporativos da conta.
* **Diagrama de Contêiner:** O **Painel Web do Proprietário** envia os dados de faturamento e o CNPJ. A **API Backend Porto Certo** cria as credenciais seguras no contêiner do **Serviço de Autenticação**, e grava os dados comerciais no **Cloud Firestore** sob o status inicial "Em Análise" (pendente de auditoria de documentação naval).
* **Diagrama de Componentes:** O fluxo é comandado pelo componente **Controlador de Cadastro e Login** do painel web. Ele valida a igualdade de senhas, barra sequências numéricas fracas e despacha o payload através da **Camada de Repositório Web** para o barramento do Firebase.
* **Diagrama de Classes:** Mapeado na classe filha `Proprietario` através dos métodos de assinatura de domínio `+ solicitarPreCadastroCorporativo()` e `+ completarCadastroCorporativo(...)`. O método captura os atributos comerciais exclusivos da classe (`- cnpj`, `- nomeResponsavel`, `- cpfResponsavel`), além de enviar a credencial de segurança para o atributo herdado `- senhaHash: String`.
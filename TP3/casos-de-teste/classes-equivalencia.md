# Classes de Equivalência
<div align="justify">
Esta seção apresenta as classes de equivalência definidas para as histórias de usuário do sistema. A técnica foi aplicada com base nos critérios de aceitação e regras de negócio previamente especificados, considerando as principais condições de entrada válidas e inválidas para cada funcionalidade.
</div>

# Busca de Viagens

**US01**: Enquanto viajante, desejo buscar por viagens informando origem, destino e data, para encontrar opções de transporte disponíveis que atendam à minha necessidade.

## Classes de Equivalência

| Condição de Entrada                       | Classe Válida                                      | Classe Inválida                            | Classe Inválida                |
| :-----------------------------------------: | :--------------------------------------------------: | :------------------------------------------: | :------------------------------: |
| Filtros da busca (Origem, Destino e Data) | Origem, destino e data informados corretamente (1) | Algum filtro obrigatório não informado (2) | Dados inválidos para busca (3) |
| Disponibilidade da viagem                 | Viagem com vagas disponíveis (4)                   | Viagem sem vagas disponíveis (5)           |                                |
| Status da viagem                          | Embarque ainda não realizado (6)                   | Embarque já iniciado ou realizado (7)      |                                |

---

# Compra de Passagem

**US02**: Enquanto viajante, desejo realizar a compra de uma passagem fluvial informando meus dados e efetuando o pagamento, para garantir minha reserva na embarcação e receber o bilhete eletrônico de forma automatizada.

## Classes de Equivalência

| Condição de Entrada        | Classe Válida                                          | Classe Inválida                        | Classe Inválida                                |
| :--------------------------: | :------------------------------------------------------: | :--------------------------------------: | :----------------------------------------------: |
| Dados da viagem            | Origem, destino e data válidos (1)                     | Dados não informados (2)               | Dados inválidos (3)                            |
| Dados do passageiro        | Nome completo e documento preenchidos corretamente (4) | Nome não informado (5)                 | Documento inválido ou não informado (6)        |
| Disponibilidade do assento | Assento disponível (7)                                 | Assento indisponível (8)               |                                                |
| Forma de pagamento         | Forma de pagamento válida (9)                          | Forma de pagamento inválida (10)       | Dados de pagamento inválidos (11)              |
| Status do pagamento        | Pagamento aprovado (12)                                | Pagamento recusado (13)                | Falha na transação (14)                        |
| Emissão do bilhete         | Bilhete gerado após aprovação do pagamento (15)        | Bilhete não gerado após aprovação (16) | Bilhete gerado sem aprovação do pagamento (17) |

---

# Cadastro de Embarcação

**US03**: Enquanto proprietário, desejo cadastrar os dados, fotos e especificações técnicas das minhas embarcações, para que os viajantes possam conhecer a infraestrutura e comodidades oferecidas antes de realizarem a compra da passagem.

## Classes de Equivalência

| Condição de Entrada              | Classe Válida                                        | Classe Inválida                                          | Classe Inválida                                |
| :--------------------------------: | :----------------------------------------------------: | :--------------------------------------------------------: | :----------------------------------------------: |
| Dados obrigatórios da embarcação | Nome, tipo e capacidade preenchidos corretamente (1) | Algum campo obrigatório não preenchido (2)               | Dados obrigatórios inválidos (3)               |
| Registro oficial da embarcação   | Registro oficial válido e único (4)                  | Registro oficial já cadastrado (5)                       | Registro oficial não informado ou inválido (6) |
| Fotos da embarcação              | Fotos em PNG/JPG com até 5MB (7)                     | Arquivo em formato diferente de PNG/JPG (8)              | Arquivo maior que 5MB (9)                      |
| Permissão de gerenciamento       | Proprietário criador ou administrador (10)           | Usuário sem permissão para editar ou excluir (11)        |                                                |
| Status do cadastro               | Nova embarcação registrada como "Em Análise" (12)    | Embarcação listada aos viajantes antes da aprovação (13) |                                                |

---

# Notificações em Massa

**US04**: Enquanto proprietário, desejo enviar notificações em massa para os viajantes que compraram passagens para uma viagem específica, para informá-los rapidamente sobre imprevistos, atrasos, mudanças de rota ou cancelamentos, garantindo uma comunicação transparente e minimizando transtornos.

## Classes de Equivalência

| Condição de Entrada          | Classe Válida                                        | Classe Inválida                         | Classe Inválida                   |
| :----------------------------: | :----------------------------------------------------: | :---------------------------------------: | :---------------------------------: |
| Viagem selecionada           | Viagem com status "Agendada" ou "Em Andamento" (1)   | Viagem com status "Finalizada" (2)      | Viagem com status "Cancelada" (3) |
| Passageiros destinatários    | Viajantes com reservas confirmadas (4)               | Viajantes sem reserva confirmada (5)    |                                   |
| Mensagem da notificação      | Mensagem preenchida corretamente (6)                 | Mensagem vazia (7)                      |                                   |
| Intervalo entre notificações | Envio respeitando intervalo mínimo de 10 minutos (8) | Envio antes de completar 10 minutos (9) |                                   |

---

# Acompanhamento em Tempo Real

**US05**: Enquanto viajante, desejo acompanhar o deslocamento do transporte em tempo real em um mapa interativo, para reduzir a incerteza sobre minha localização exata e planejar meu desembarque com base no tempo estimado de chegada.

## Classes de Equivalência

| Condição de Entrada        | Classe Válida                            | Classe Inválida                                 | Classe Inválida                        |
| :--------------------------: | :----------------------------------------: | :-----------------------------------------------: | :--------------------------------------: |
| GPS do dispositivo         | GPS ativo (1)                            | GPS desativado (2)                              | Sinal GPS instável ou indisponível (3) |
| Status da viagem           | Viagem com status "Em Andamento" (4)     | Viagem com status "Agendada" (5)                | Viagem com status "Finalizada" (6)     |
| Atualização de localização | Dados atualizados a cada 10 segundos (7) | Atualização fora do intervalo previsto (8)      | Dados de localização não enviados (9)  |
| Tempo estimado de chegada  | ETA calculado corretamente (10)          | ETA não atualizado após alterações de rota (11) | ETA inválido (12)                      |

---

# Modo de Alto Contraste

**US06**: Enquanto viajante com baixa visão, desejo ativar um modo de alto contraste na interface, para que eu possa distinguir claramente os textos, botões e elementos visuais, navegando pelo aplicativo com maior conforto e autonomia.

## Classes de Equivalência

| Condição de Entrada                | Classe Válida                                             | Classe Inválida                                  | Classe Inválida       |
| :----------------------------------: | :---------------------------------------------------------: | :------------------------------------------------: | :---------------------: |
| Ativação do modo de alto contraste | Modo ativado corretamente (1)                             | Modo não ativado após solicitação do usuário (2) |                       |
| Aplicação do tema                  | Tema aplicado em todas as telas e componentes (3)         | Tema aplicado parcialmente (4)                   | Tema não aplicado (5) |
| Contraste visual                   | Contraste atende às diretrizes de acessibilidade (6)      | Contraste abaixo do mínimo exigido (7)           |                       |
| Persistência da configuração       | Preferência salva para sessões futuras (8)                | Preferência não salva (9)                        |                       |
| Funcionalidades do sistema         | Funcionalidades permanecem disponíveis após ativação (10) | Funcionalidades ocultadas ou desabilitadas (11)  |                       |

---

# Formas de Pagamento

**US07**: Enquanto viajante, desejo escolher entre diferentes formas de pagamento no momento de finalizar a compra da minha passagem fluvial, para que eu possa utilizar a opção mais conveniente para o meu planejamento financeiro e garantir minha reserva na embarcação.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Forma de pagamento | PIX, Cartão de Crédito ou Boleto selecionado corretamente (1) | Forma de pagamento não selecionada (2) | Forma de pagamento inválida (3) |
| Antecedência para boleto | Viagem com pelo menos 72 horas úteis de antecedência (4) | Viagem com menos de 72 horas úteis de antecedência (5) | |
| Pagamento PIX | Pagamento realizado dentro de 10 minutos (6) | Pagamento não realizado dentro do prazo (7) | |
| Status do pagamento | Pagamento aprovado ou compensado (8) | Pagamento recusado (9) | Falha na comunicação com a operadora (10) |
| Emissão do bilhete | Bilhete gerado após confirmação do pagamento (11) | Bilhete não gerado após confirmação (12) | Bilhete gerado sem pagamento confirmado (13) |

---

# Acessibilidade para Deficiência Visual

**US08**: Enquanto viajante com deficiência visual (cegueira ou baixa visão), desejo que a interface do aplicativo suporte plenamente tecnologias assistivas e padrões de acessibilidade, para que eu possa navegar, buscar viagens e comprar minhas passagens de forma autônoma, intuitiva e segura.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Compatibilidade com leitor de tela | Elementos lidos corretamente pelo leitor de tela (1) | Leitura parcial dos elementos (2) | Elementos não interpretados pelo leitor de tela (3) |
| Navegação assistiva | Navegação completa por teclado ou gestos (4) | Navegação parcialmente acessível (5) | Navegação impossível sem toque direto (6) |
| Elementos não textuais | Imagens e ícones com descrição alternativa (7) | Descrições incompletas (8) | Ausência de descrição alternativa (9) |
| Redimensionamento de texto | Interface permanece funcional após ampliação do texto (10) | Interface parcialmente comprometida (11) | Interface quebrada após ampliação (12) |
| Informações visuais | Informação visual acompanhada de texto acessível (13) | Informação disponível apenas por cor ou elemento visual (14) | |

---

# Cadastro de Viagem

**US09**: Enquanto proprietário, desejo cadastrar os detalhes de uma nova viagem fluvial, incluindo a embarcação utilizada, rota, data, horários e frequência, para que eu possa disponibilizar a venda de passagens aos viajantes e gerenciar minha oferta de transporte na plataforma.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Embarcação selecionada | Embarcação validada selecionada (1) | Embarcação não selecionada (2) | Embarcação não validada (3) |
| Dados obrigatórios da viagem | Origem, destino e horário preenchidos corretamente (4) | Algum campo obrigatório não preenchido (5) | Dados inválidos (6) |
| Tipo de viagem | Viagem definida como única ou recorrente corretamente (7) | Tipo de viagem não definido (8) | Viagem recorrente sem dias da semana definidos (9) |
| Antecedência da viagem | Horário cadastrado com no mínimo 12 horas de antecedência (10) | Horário com menos de 12 horas de antecedência (11) | |
| Quantidade de assentos | Quantidade de assentos menor ou igual à capacidade da embarcação (12) | Quantidade de assentos superior à capacidade da embarcação (13) | |
| Disponibilidade de embarcação | Proprietário possui pelo menos uma embarcação validada disponível (14) | Proprietário sem embarcações validadas (15) | |

---

# Perfil da Embarcação
<div align="justify">

  **US10**: Enquanto viajante, desejo acessar uma página de perfil detalhada de cada embarcação (contendo fotos, especificações técnicas e comodidades), para que eu possa comparar diferentes opções de transporte e escolher aquela que melhor atende às minhas preferências de conforto e segurança para a viagem.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Status da embarcação | Embarcação com status "Validada" (1) | Embarcação com status "Em Análise" (2) | Embarcação inexistente ou removida (3) |
| Dados do perfil | Dados aprovados e consistentes com o cadastro (4) | Dados incompletos no perfil (5) | Dados divergentes do cadastro aprovado (6) |
| Permissão de acesso | Usuário possui acesso apenas para visualização (7) | Usuário consegue alterar informações do perfil (8) | |

---

# Dashboard de Faturamento
<div align="justify">

  **US11**: Enquanto proprietário, desejo acessar um painel de controle financeiro (Dashboard de Faturamento) com o cálculo automatizado do valor bruto e do valor líquido a receber das minhas viagens, para que eu possa gerenciar a receita do meu negócio com transparência e acompanhar o impacto de taxas e descontos aplicados.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Período de consulta | Dia, semana ou mês selecionado corretamente (1) | Período não informado (2) | Período inválido (3) |
| Dados financeiros da viagem | Tarifa e quantidade de passagens válidas para cálculo (4) | Dados financeiros incompletos (5) | Dados financeiros inválidos (6) |
| Taxas e descontos | Taxas e descontos válidos ou assumidos como zero (7) | Taxas inválidas (8) | Descontos inválidos (9) |
| Modalidade de pagamento | Receita identificada por PIX, Crédito ou Boleto (10) | Modalidade não identificada (11) | |
| Valor líquido calculado | Valor líquido maior ou igual a zero (12) | Valor líquido negativo (13) | |
| Recalculo financeiro | Alterações atualizam os valores corretamente (14) | Valores não atualizados após alteração (15) | |

---

# Assistente Interativo
<div align="justify">

  **US12**: Enquanto viajante, desejo ter acesso a um assistente interativo com instruções passo a passo (tutorial em tela), para que eu possa entender facilmente como utilizar as funcionalidades do aplicativo, como buscar viagens e comprar passagens, sem me sentir perdido ou precisar de ajuda externa.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Conteúdo da mensagem | Mensagem com até 100 caracteres (1) | Mensagem vazia (2) | Mensagem com mais de 100 caracteres (3) |
| Acionamento do assistente | Primeiro acesso ou nova funcionalidade (4) | Assistente não exibido no primeiro acesso (5) | |
| Navegação no tutorial | Usuário pode avançar, voltar ou encerrar o tutorial (6) | Navegação parcialmente disponível (7) | Navegação indisponível (8) |
| Reativação do assistente | Tutorial reativado pelo botão de ajuda (9) | Botão de ajuda indisponível (10) | |
| Autonomia do usuário | Usuário pode pular o tutorial a qualquer momento (11) | Usuário obrigado a concluir o tutorial (12) | |

---

# Cancelamento de Passagem

**US13**: Enquanto viajante, desejo ter a opção de cancelar uma passagem adquirida diretamente pelo aplicativo, para que eu possa reaver o valor investido ou liberar o assento em caso de imprevistos ou alterações nos meus planos de viagem.
<div align="justify">

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Prazo para cancelamento | Solicitação realizada com pelo menos 24 horas de antecedência (1) | Solicitação realizada com menos de 24 horas de antecedência (2) | |
| Cancelamento por viagem cancelada | Viagem cancelada pelo proprietário com direito a estorno integral (3) | Viagem não cancelada pelo proprietário (4) | |
| Status do boleto | Boleto ainda não compensado (5) | Boleto já compensado (6) | |
| Estorno da passagem | Estorno realizado conforme as regras de negócio (7) | Estorno não realizado quando devido (8) | Estorno realizado indevidamente (9) |

---

# Iniciar e Encerrar Viagem

**US14**: Enquanto proprietário ou comandante da embarcação, desejo dispor de um comando para iniciar e encerrar oficialmente uma viagem agendada, para que o aplicativo passe a transmitir os dados de localização geográfica (GPS) aos passageiros apenas durante o percurso planejado.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Status da viagem para início | Viagem com status "Agendada" e dentro do horário de partida (1) | Viagem não agendada (2) | Viagem fora do horário de partida (3) |
| Início da viagem | Comando "Iniciar Viagem" executado corretamente (4) | Comando não executado (5) | |
| Status da viagem para transmissão GPS | Viagem com status "Em Andamento" (6) | Viagem com status "Agendada" (7) | Viagem com status "Finalizada" (8) |
| Encerramento da viagem | Comando "Encerrar Viagem" executado ao final do percurso (9) | Viagem não encerrada após chegada ao destino (10) | |
| Conectividade durante a viagem | Conexão ativa ou restabelecida automaticamente (11) | Falha de conexão sem tentativa de reconexão (12) | |

---

# Bilhete Offline

**US15**: Enquanto viajante, desejo que os meus bilhetes de passagem sejam salvos automaticamente no armazenamento local do meu dispositivo após a compra, contendo todos os meus dados de identificação e os detalhes da rota, para que eu consiga apresentar a cédula de embarque digital ao proprietário e garantir meu acesso à embarcação de forma totalmente visual, mesmo sem conectividade com a internet.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Status do pagamento | Pagamento confirmado ou compensado (1) | Pagamento não confirmado (2) | |
| Armazenamento do bilhete | Bilhete salvo corretamente no cache local (3) | Bilhete não salvo no cache local (4) | |
| Acesso offline | Bilhete disponível sem conexão com a internet (5) | Bilhete indisponível sem internet (6) | |
| Dados de identificação | Nome, CPF e RG exibidos corretamente (7) | Dados incompletos (8) | Dados divergentes dos informados na compra (9) |
| Dados da viagem | Embarcação, assento, origem, destino, data e horário exibidos corretamente (10) | Dados da viagem incompletos (11) | Dados da viagem incorretos (12) |
| Preferências de acessibilidade | Configurações visuais mantidas no modo offline (13) | Configurações visuais não mantidas no modo offline (14) | |

---

# Cadastro de Viajante

**US16**: Como viajante, desejo me cadastrar na plataforma informando meus dados, para que eu possa ter acesso às funcionalidades do aplicativo.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| E-mail ou telefone | E-mail ou telefone em formato válido (1) | E-mail em formato inválido (2) | Telefone em formato inválido (3) |
| Unicidade do contato | E-mail ou telefone não cadastrado (4) | E-mail já cadastrado (5) | Telefone já cadastrado (6) |
| Código de verificação | Código correto dentro do prazo de 5 minutos (7) | Código incorreto (8) | Código expirado (9) |
| Reenvio de código | Reenvio após 60 segundos e dentro do limite permitido (10) | Reenvio antes de 60 segundos (11) | Mais de 3 reenvios por hora (12) |
| Idade do usuário | Idade maior ou igual a 18 anos (13) | Idade menor que 18 anos (14) | |
| Dados pessoais | Nome, sobrenome e idade preenchidos corretamente (15) | Algum campo obrigatório não preenchido (16) | |
| Complexidade da senha | Senha com no mínimo 8 caracteres, letra maiúscula, letra minúscula, número e caractere especial (17) | Senha com menos de 8 caracteres (18) | Senha sem atender aos requisitos de complexidade (19) |
| Confirmação de senha | Senha e confirmação idênticas (20) | Senha e confirmação diferentes (21) | |

---

# Cadastro de Proprietário

**US17**: Como Proprietário, desejo me cadastrar na plataforma informando meus dados, para que eu possa ter acesso às funcionalidades do aplicativo.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| E-mail ou telefone | E-mail ou telefone em formato válido (1) | E-mail em formato inválido (2) | Telefone em formato inválido (3) |
| CNPJ | CNPJ válido e com situação cadastral ativa (4) | CNPJ com formato inválido (5) | CNPJ inativo ou irregular (6) |
| Unicidade dos dados | E-mail, telefone e CNPJ não cadastrados (7) | E-mail já cadastrado (8) | Telefone ou CNPJ já cadastrado (9) |
| Código de verificação | Código correto dentro do prazo de 5 minutos (10) | Código incorreto (11) | Código expirado (12) |
| Reenvio de código | Reenvio após 60 segundos e dentro do limite permitido (13) | Reenvio antes de 60 segundos (14) | Mais de 3 reenvios por hora (15) |
| Dados cadastrais | Razão Social, CNPJ, Nome do Responsável, CPF e contato preenchidos corretamente (16) | Algum campo obrigatório não preenchido (17) | |
| Senha corporativa | Senha com no mínimo 8 caracteres, letras maiúsculas, minúsculas, números e caracteres especiais (18) | Senha que não atende aos requisitos mínimos de complexidade (19) | Senha baseada em dados óbvios do cadastro (20) |
| Confirmação de senha | Senha e confirmação idênticas (21) | Senha e confirmação diferentes (22) | |
| Status do cadastro | Cadastro criado com status "Em Análise" (23) | Cadastro liberado sem validação da plataforma (24) | |

</div>

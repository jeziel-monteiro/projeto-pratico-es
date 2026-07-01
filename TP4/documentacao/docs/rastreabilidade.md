# Rastreabilidade com Histórias de Usuário — Porto Certo Viagens

<div align="justify">

## O que é Rastreabilidade?
A rastreabilidade de requisitos é um conceito fundamental na engenharia de software que consiste na capacidade de associar, acompanhar e mapear o ciclo de vida de um requisito desde a sua concepção original até a sua entrega final no sistema. No contexto do desenvolvimento ágil, ela estabelece um vínculo claro e transparente entre as necessidades expressas pelos usuários (Histórias de Usuário) e os elementos reais construídos no produto (Implementação no MVP). Essa prática assegura que todas as demandas de negócio sejam cumpridas, evita o desenvolvimento de funcionalidades desnecessárias e facilita os processos de validação, testes e manutenções futuras.

---

### US01 — Busca de Viagens
* **História de Usuário:** Enquanto viajante, desejo buscar por viagens informando origem, destino e data, para encontrar opções de transporte disponíveis que atendam à minha necessidade.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/a5107441-8e4a-4c86-8664-ed105693a32d" width="320" alt="Tela 8 - Busca"></td>
    <td><img src="https://github.com/user-attachments/assets/f3573981-14a3-45c6-bd8c-92946fd358a6" width="320" alt="Tela 9 - Resultados"></td>
    <td><img src="https://github.com/user-attachments/assets/4f46b15a-ddda-4fb3-b10f-9589dd73bb91" width="320" alt="Tela 21 - Favoritos"></td>
  </tr>
</table>

* **Implementação no MVP:** A funcionalidade foi implementada por meio da Tela de Busca e da Tela de Resultados. Na tela de busca, os campos obrigatórios de origem, destino e data são disponibilizados ao usuário, com validação que impede a seleção de datas anteriores ao dia atual. Após a submissão, a tela de resultados exibe os cartões de viagem contendo nome da embarcação, rota, horário, duração estimada e preço por pessoa. A funcionalidade de favoritar viagens é acessível por meio do botão de coração nos cartões de resultado, integrada à Tela de Favoritos.

---

### US02 — Compra de Passagem
* **História de Usuário:** Enquanto viajante, desejo realizar a compra de uma passagem fluvial informando meus dados e efetuando o pagamento, para garantir minha reserva na embarcação e receber o bilhete eletrônico de forma automatizada.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/5431f67a-9c5e-452d-96fe-96400b65b199" width="220" alt="Tela 12 - Dados"></td>
    <td><img src="https://github.com/user-attachments/assets/d249d1f6-eef7-45c0-a951-34eebb4a4461" width="220" alt="Tela 13 - Acomodação"></td>
    <td><img src="https://github.com/user-attachments/assets/0419a53f-3b77-47fa-aacd-b7ca6d2f78c6" width="220" alt="Tela 14 - Resumo"></td>
    <td><img src="https://github.com/user-attachments/assets/71750031-7c71-4b1c-a6d2-0ed7f7de9bf0" width="220" alt="Tela 19 - Sucesso"></td>
  </tr>
</table>

* **Implementação no MVP:** O fluxo de compra foi implementado em múltiplas telas encadeadas: a Tela de Dados da Viagem  coleta os dados do passageiro (nome completo e CPF) e permite a seleção dos pontos de embarque e desembarque; a Tela de Acomodação apresenta as opções de Rede e Camarote com seus respectivos valores; a Tela de Resumo exibe o valor total da compra de forma destacada antes da etapa de pagamento; e as Telas de Pagamento  processam a transação com indicador visual de carregamento. As telas de Pagamento Aprovado e Bilhete Digital finalizam o fluxo, com geração do bilhete eletrônico contendo QR Code e notificação de envio por e-mail.

---

### US05 — Acompanhamento em Tempo Real
* **História de Usuário:** Enquanto viajante, desejo acompanhar o deslocamento do transporte em tempo real em um mapa interativo, para reduzir a incerteza sobre minha localização exata e planejar meu desembarque com base no tempo estimado de chegada.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/38ec2222-6159-447d-a726-3b211479999b" width="320" alt="Tela 22 - Rastreamento"></td>
  </tr>
</table>

* **Implementação no MVP:** A funcionalidade foi implementada na Tela de Rastreamento por meio de uma simulação de geolocalização construída inteiramente em SVG, dispensando o uso de imagens externas. O mapa apresenta o rio Amazonas com margens, ilhas, rota tracejada e um marcador representando a posição atual da embarcação, além dos pontos de origem e destino. O estado de GPS indisponível é representado por uma tela específica com mensagem de instabilidade e botão para nova tentativa. O tempo estimado de chegada é exibido em painel fixo sobre o mapa, e uma barra de progresso indica o percentual do trajeto concluído e a distância restante.

---

### US06 — Modo de Alto Contraste
* **História de Usuário:** Enquanto viajante com baixa visão, desejo ativar um modo de alto contraste na interface, para que eu possa distinguir claramente os textos, botões e elementos visuais, navegando pelo aplicativo com maior conforto e autonomia.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/f705516d-c21f-455c-8236-86e5ea71e13d" width="320" alt="Tela 25 - Acessibilidade"></td>
    <td><img src="https://github.com/user-attachments/assets/ad67450a-e79c-48f9-8816-ab93c525049a" width="320" alt="Tela 26 - Alto Contraste"></td>
  </tr>
</table>

* **Implementação no MVP:** O modo de alto contraste foi implementado de forma global no aplicativo. A Tela de Acessibilidade disponibiliza um toggle para ativação do recurso. Ao ser ativado, um filtro CSS é aplicado sobre todo o conteúdo do dispositivo, alterando instantaneamente o esquema visual de todas as telas. A Tela de Alto Contraste apresenta adicionalmente um tema explícito em preto e amarelo com menu de navegação acessível. Para preservar a naturalidade das fotografias de perfil e embarcações durante o modo ativo, uma regra de contra-filtro é aplicada especificamente às imagens, restaurando suas cores originais.

---

### US07 — Formas de Pagamento
* **História de Usuário:** Enquanto viajante, desejo escolher entre diferentes formas de pagamento no momento de finalizar a compra da minha passagem fluvial, para que eu possa utilizar a opção mais conveniente para o meu planejamento financeiro e garantir minha reserva na embarcação.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/20facbf6-ded3-40e1-b6d8-cc92f1b2484a" width="220" alt="Tela 15 - Pagamento"></td>
    <td><img src="https://github.com/user-attachments/assets/0a37264a-3ab0-4f8f-b785-b667b178182b" width="220" alt="Tela 16 - PIX"></td>
    <td><img src="https://github.com/user-attachments/assets/1a5ca634-b2e3-4bb3-8155-91dd2ce2fe45" width="220" alt="Tela 17 - Boleto"></td>
    <td><img src="https://github.com/user-attachments/assets/d149afa3-3a67-499a-bcb6-ee1c5601b2da" width="220" alt="Tela 17b - Cartão"></td>
  </tr>
</table>

* **Implementação no MVP:** A seleção da forma de pagamento foi implementada na Tela de Pagamento, que apresenta as três modalidades disponíveis: PIX, Cartão de Crédito e Boleto Bancário. Cada opção possui sua tela de execução dedicada: a Tela de PIX exibe o QR Code com temporizador regressivo de 10 minutos e código copia e cola; a Tela de Cartão de Créditoapresenta alerta sobre a taxa de 2% antes da confirmação e card visual do cartão preenchido em tempo real; a Tela de Boleto exibe o código de barras copiável, botão de download em PDF e simulações de pagamento aprovado e vencimento. Todas as telas contam com indicadores de carregamento durante o processamento e estados distintos para sucesso e falha.

---

### US08 — Acessibilidade para Deficiência Visual
* **História de Usuário:** Enquanto viajante com deficiência visual (cegueira ou baixa visão), desejo que a interface do aplicativo suporte plenamente tecnologias assistivas e padrões de acessibilidade, para que eu possa navegar, buscar viagens e comprar minhas passagens de forma autônoma, intuitiva e segura.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/611c0b6b-3332-4a80-932c-d98598b2702b" width="320" alt="Tela 25 - Controles"></td>
  </tr>
</table>

* **Implementação no MVP:** As funcionalidades de acessibilidade foram centralizadas na Tela de Acessibilidade, que oferece controle de tamanho de fonte com slider interativo, toggle para leitor de tela e toggle para navegação assistiva. Todas as imagens do aplicativo possuem atributos descritivos de texto alternativo. Os formulários utilizam labels associados aos campos de entrada. A conformidade com as diretrizes WCAG 2.1 Nível AA é declarada na tela de acessibilidade. A integração com o modo de alto contraste complementa os requisitos visuais contemplados pela história.

---

### US10 — Perfil Detalhado da Embarcação
* **História de Usuário:** Enquanto viajante, desejo acessar uma página de perfil detalhada de cada embarcação (contendo fotos, specifications técnicas e comodidades), para que eu possa comparar diferentes opções de transporte e escolher aquela que melhor atende às minhas preferências de conforto e segurança para a viagem.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/6478a78c-1e03-45eb-a1c6-2cb46c82fb59" width="220" alt="Tela 10 - Perfil"></td>
    <td><img src="https://github.com/user-attachments/assets/10d70630-9287-418c-9b1b-65cfaa15b787" width="220" alt="Tela 11 - Próximas"></td>
    <td><img src="https://github.com/user-attachments/assets/107db91a-d432-4f76-9b39-3584e811a6f0" width="220" alt="Tela 11b - Avaliações"></td>
  </tr>
</table>

* **Implementação no MVP:** O perfil da embarcação foi implementado na Tela de Perfil da Embarcação, que exibe nome, número de registro oficial, capacidade máxima de passageiros e velocidade média em cards informativos. Uma galeria de fotos navegável por indicadores de posição e a listagem de comodidades disponíveis complementam as informações apresentadas. A seção de próximas viagens oferece acesso à Tela de Próximas Viagens. A Tela de Avaliações amplia o perfil com nota média, distribuição de avaliações por estrela, listagem de comentários de passageiros e formulário para submissão de nova avaliação com seleção de estrelas e validação mínima de caracteres.

---

### US12 — Assistente Interativo (Tutorial Onboarding)
* **História de Usuário:** Enquanto viajante, desejo ter acesso a um assistente interativo com instruções passo a passo (tutorial em tela), para que eu possa entender facilmente como utilizar as funcionalidades do aplicativo, como buscar viagens e comprar passagens, sem me sentir perdido ou precisar de ajuda externa.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/ba2853b4-5d31-4520-ac0f-3d0e7485904c" width="220" alt="Tela 3 - Assistente"></td>
    <td><img src="https://github.com/user-attachments/assets/94597176-3e3a-49a9-b237-69f02aa66e9f" width="220" alt="Tela 31 - Guia 1"></td>
  </tr>
</table>

* **Implementação no MVP:** O assistente foi implementado em duas frentes. O Assistente Conversacional conduz o usuário na busca de viagens por meio de perguntas sequenciais sobre destino, origem e data, com opções de resposta rápida em formato de chips. O Tutorial Overlay sobrepõe balões de orientação nas telas principais — Home, Busca, Pagamento e Perfil —, com botões para avançar, pular e indicadores de progresso. As Telas de Guia oferecem tutoriais passo a passo sobre como comprar uma passagem, as formas de pagamento e os tipos de acomodação, acessíveis pela Central de Ajuda (Tela 27) na seção "Orientações de Compra".

---

### US13 — Cancelamento de Passagem
* **História de Usuário:** Enquanto viajante, desejo ter a opção de cancelar uma passagem adquirida diretamente pelo aplicativo, para que eu possa reaver o valor investido ou liberar o assento em caso de imprevistos ou alterações nos meus planos de viagem.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/d3a74a63-3793-494d-8ec6-cc83987e40ae" width="320" alt="Tela 20 - Bilhete e Cancelamento"></td>
  </tr>
</table>

* **Implementação no MVP:** O fluxo de cancelamento foi implementado integralmente na Tela do Bilhete Digital. O botão "Cancelar Reserva" é exibido de forma permanente, acompanhado de um indicador colorido que informa o prazo restante e a política aplicável ao cenário. Ao ser acionado, um modal de confirmação apresenta a política de retenção de taxas, o valor a ser devolvido, o prazo do estorno e alertas específicos por cenário. O estado de cancelamento concluído exibe um comprovante completo com protocolo, valor estornado, prazo e confirmação de envio do comprovante por e-mail. Quatro cenários de demonstração foram implementados para validação: cancelamento com reembolso integral (acima de 24h de antecedência), com multa de 20% (abaixo de 24h), boleto não compensado com cancelamento imediato e sem ônus, e cancelamento originado pelo proprietário com reembolso integral automático.

---

### US15 — Bilhete Digital Offline (Cédula de Embarque)
* **História de Usuário:** Enquanto viajante, desejo que os meus bilhetes de passagem sejam salvos automaticamente no armazenamento local do meu dispositivo após a compra, contendo todos os meus dados de identificação e os detalhes da rota, para que eu consiga apresentar a cédula de embarque digital ao proprietário e garantir meu acesso à embarcação de forma totalmente visual, mesmo sem conectividade com a internet.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/8c7ad1a1-46ed-414f-8553-c608dc940ad3" width="320" alt="Tela 20 - Modo Offline"></td>
  </tr>
</table>

* **Implementação no MVP:** O bilhete digital foi implementado na Tela do Bilhete Digital. A tela exibe todos os dados obrigatórios de identificação do passageiro: Nome completo, CPF e os detalhes da viagem, como embarcação, rota, data, horário e acomodação, em layout de alta legibilidade com tipografia contrastante. O QR Code é gerado via SVG nativo, sem dependência de serviços externos, garantindo renderização sem conexão com a internet. Um aviso informativo indica que o bilhete é salvo automaticamente no dispositivo e permanece acessível em modo offline. O botão de download em PDF está disponível junto às ações de compartilhamento e rastreamento.

---

### US16 — Cadastro do Viajante
* **História de Usuário:** Como viajante, desejo me cadastrar na plataforma informando meus dados, para que eu possa ter acesso às funcionalidades do aplicativo.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/7e483b57-b31b-460c-8ceb-84fb376319d3" width="320" alt="Tela 5 - Formulário Cadastro"></td>
  </tr>
</table>

* **Implementação no MVP:** O cadastro foi implementado na Tela de Cadastro, com formulário contendo os campos de nome completo, CPF, telefone, e-mail, senha e confirmação de senha. A validação em tempo real exibe mensagens de erro específicas por campo, incluindo verificação de formato de CPF e e-mail e conferência de correspondência entre as senhas. O campo de senha conta com toggle de visibilidade e um indicador de força com barra de progresso colorida, que avalia em tempo real o comprimento, a presença de letra maiúscula, número e caractere especial. Os termos de uso e a política de privacidade são acessíveis por links na parte inferior da tela.

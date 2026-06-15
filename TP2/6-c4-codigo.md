# Diagrama de Código (Classes)

<div align = "justify">

O Diagrama de Código representa o quarto e mais profundo nível do Modelo C4. O objetivo desta camada não é mostrar a arquitetura macro, mas detalhar a estrutura interna de um componente mapeado nos níveis anteriores, traduzindo-o para elementos estruturais de programação orientada a objetos (como classes, atributos, operações e enumerações). Mapear o código permite compreender o encapsulamento dos dados, a herança entre as entidades e as regras de negócio intrínsecas que garantem o funcionamento lógico do sistema, servindo como o projeto definitivo para a implementação e manutenção do software.

## Diagrama do Projeto

<img width="1283" height="925" alt="Diagrama e código" src="https://github.com/user-attachments/assets/968239f1-d91a-40a5-a426-c5954187b056" />


## Explicação geral do diagrama modelado

O diagrama modelado para o sistema Porto Certo ilustra a estrutura das coleções de dados e as regras de negócio centrais da aplicação com base no ecossistema Firebase. O fluxo demonstra a separação de responsabilidades em domínios específicos, destacando o uso de herança para reaproveitamento de código, o encapsulamento rígido para a segurança dos atributos e a padronização de estados através de Enumerações para evitar falhas no banco de dados. Além disso, a modelagem foi construída para atender estritamente aos requisitos mapeados no Backlog do produto.

### Detalhamento por Partes e Relação com as Histórias de Usuário (US)

**Acesso e Gestão de Perfis (Autenticação)**
A classe abstrata `Usuario` atua como a base central, protegendo os dados comuns de cadastro (como nome, CPF e email). Dela, herdam duas especializações: o `Proprietario` (focado no Painel Web, armazenando CNPJ e dados bancários) e o `Viajante` (que interage com o App Mobile). 
* **Relação com as US:** O atributo `modoAltoContraste` na classe `Viajante` atende diretamente ao requisito de acessibilidade visual solicitado na **US06**.

**Gestão Operacional (Frota e Rotas)**
O componente `Embarcacao` é responsável por validar e armazenar as características físicas dos barcos. Ele atua como dependência direta para a `Viagem`, que é a classe que orquestra os agendamentos (origem, destino, data) e recebe as atualizações das coordenadas de telemetria.
* **Relação com as US:** A classe `Embarcacao` e sua subordinação ao `Proprietario` materializam a **US03 (Cadastro de Frota)**. Já a classe `Viagem` e o método `favoritarTrecho()` no perfil do viajante atendem aos requisitos de busca e logística da **US01 (Busca de Viagens)**.

**Núcleo de Vendas e Checkout**
O `Bilhete` tem a responsabilidade única de gerenciar a passagem, dependendo estritamente do processamento da classe `Pagamento`, que consolida os valores antes de acionar o Gateway financeiro.
* **Relação com as US:** A relação de dependência entre estas duas classes reflete a **US02 (Processo de Compra)**. Além disso, a operação `gerarPdfOffline()` encapsulada na classe `Bilhete` é a solução arquitetural exata para a exigência de disponibilidade sem internet descrita na **US06 (Bilhete Offline)**.

**Comunicação e Engajamento**
A classe `Notificacao` atua no suporte aos imprevistos, gerenciando o conteúdo e o canal dos avisos disparados aos passageiros.
* **Relação com as US:** A operação `dispararEmMassa()`, atrelada aos eventos de mudança de status da classe `Viagem`, cumpre integralmente a regra de negócio exigida na **US04 (Notificações em Massa)**.

### Ligação dos Componentes

* **Proprietário → Embarcação e Viagem:** Relação estrutural de 1 para muitos (0..*). O proprietário cadastra e gerencia múltiplas embarcações e é o responsável direto por agendar diversas rotas.
* **Embarcação → Viagem:** Relação de 1 para muitos. Uma mesma embarcação realiza várias viagens ao longo de sua vida útil, mas uma rota específica aloca estritamente um único barco.
* **Viajante e Viagem → Bilhete:** Relações de 1 para muitos. O viajante adquire vários bilhetes ao longo do tempo, e uma viagem gera múltiplas passagens, mas cada bilhete é nominal a um único usuário e atrelado a uma rota inalterável.
* **Bilhete → Pagamento:** Relação rígida de 1 para 1. Cada bilhete emitido pelo sistema possui exatamente uma transação financeira associada, garantindo a consistência do checkout.
* **Classes de Negócio → Enumerações (Status):** Relação de Dependência. As classes `Viagem`, `Pagamento` e `Bilhete` dependem estruturalmente dos Enums (`StatusViagem`, `StatusPagamento`, `StatusBilhete`) para limitar seus estados a uma lista fechada de opções válidas (ex: PENDENTE, APROVADO, CANCELADA), blindando a aplicação contra erros de entrada de dados.

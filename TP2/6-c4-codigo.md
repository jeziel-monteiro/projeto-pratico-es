# Diagrama de Código (Classes)

<div align = "justify">

O Diagrama de Código representa o quarto e mais profundo nível do Modelo C4. O objetivo desta camada não é mostrar a arquitetura macro, mas detalhar a estrutura interna de um componente mapeado nos níveis anteriores, traduzindo-o para elementos estruturais de programação orientada a objetos (como classes, atributos, operações e enumerações). Mapear o código permite compreender o encapsulamento dos dados, a herança entre as entidades e as regras de negócio intrínsecas que garantem o funcionamento lógico do sistema, servindo como o projeto definitivo para a implementação e manutenção do software.

## Diagrama do Projeto 
<div align="center"> 

<img width="1283" height="925" alt="Diagrama e código" src="https://github.com/user-attachments/assets/1d259b62-1770-4fe4-bebb-aa572a6b6dcf" />

</div>

## Explicação geral do diagrama modelado

O diagrama modelado para o sistema Porto Certo ilustra a estrutura das entidades de domínio e as regras de negócio centrais da aplicação com persistência principal em PostgreSQL. O fluxo demonstra a separação de responsabilidades em domínios específicos, destacando o uso de herança para reaproveitamento de código, o encapsulamento rígido para a segurança dos atributos e a padronização de estados através de Enumerações para evitar falhas no banco de dados. Além disso, a modelagem foi construída para atender estritamente aos requisitos mapeados no Backlog do produto.

---

### Detalhamento por Partes e Relação com as Histórias de Usuário (US)

#### 1. Acesso e Gestão de Perfis (Autenticação)
<div align="center"> 
  
<img width="666" height="387" alt="Captura de tela 2026-06-14 211525" src="https://github.com/user-attachments/assets/834c471b-5800-41d9-8c09-ae42737019e9" />

</div>

Esta modelagem reflete o componente de Serviço de Autenticação e as regras de autorização aplicadas pela API Backend. Isolamos os dados cadastrais comuns (como `#nomeCompleto` e `#cpf`) na superclasse abstrata `Usuario`, que detém a operação `+autenticar()` para validação de tokens.
As propriedades específicas ficam nas subclasses: 
* A classe `Viajante` abriga propriedades do aplicativo móvel, como o atributo `-modoAltoContraste` (atendendo à **US06** de acessibilidade) e o método `+favoritarTrecho()` (referente à **US01**). 
* A classe `Proprietario` guarda dados para o painel web, como faturamento e CNPJ, através do método `+visualizarFaturamento()`.

#### 2. Gestão de Frota
<div align="center"> 

<img width="517" height="247" alt="Captura de tela 2026-06-14 211549" src="https://github.com/user-attachments/assets/554e23a7-74e9-41dd-8b60-16f96cfa58cf" />

</div>

Esta seção amarra diretamente o componente web de Gestão de Embarcações com a **US03**.
Um proprietário autenticado pode possuir e gerenciar uma frota inteira de barcos (relação `0..*`). No entanto, para fins de responsabilidade fiscal e auditoria de segurança no ecossistema, cada `Embarcacao` cadastrada pertence obrigatoriamente a exatamente uma conta de `Proprietario` (relação `1`). A manipulação desses dados ocorre através do método `+editarDados()`.

#### 3. Agendamento e Rastreamento
<div align="center"> 

<img width="548" height="457" alt="Captura de tela 2026-06-14 211617" src="https://github.com/user-attachments/assets/f6a4af9e-6607-475d-91ba-b57347482e9c" />

</div>

Este bloco reflete o componente de Agendamento de Viagens (Rotas) e atende à **US09**.
Para que uma rota aconteça, o Proprietário precisa criá-la informando obrigatoriamente uma embarcação previamente homologada. Um barco realiza diversas viagens ao longo do seu ciclo de vida (`0..*`), mas uma `Viagem` específica só pode ocorrer utilizando um único barco (`1`) devido à limitação física de assentos. É nesta classe que o fluxo de rastreamento no mapa ocorre, através do método `+atualizarTelemetria()`.

#### 4. Resiliência e Emissão de Bilhetes
<div align="center"> 

<img width="677" height="395" alt="Captura de tela 2026-06-14 211653" src="https://github.com/user-attachments/assets/893a9e46-9b1f-45df-875b-7b8e16a2eb34" />

</div>

Modela o componente móvel "Meus Bilhetes" e a regra de resiliência offline exigida na **US06**.
Uma viagem comercializa vários assentos, gerando múltiplos bilhetes (`0..*`). O passageiro armazena estes bilhetes localmente no cache do seu telemóvel para consulta sem internet, através do método `+gerarPdfOffline()`. Cada `Bilhete` está atrelado rigidamente a uma única viagem específica (`1`) e a um único passageiro comprador (`1`), impedindo fraudes ou clonagem de assentos.

#### 5. Núcleo de Vendas e Checkout
<div align="center"> 

<img width="545" height="287" alt="Captura de tela 2026-06-14 211727" src="https://github.com/user-attachments/assets/3beba771-c4a3-49e7-a9c7-b2a0e358433e" />

</div>

Reflete a integração rigorosa entre o Checkout de Passagem e o serviço de pagamento do backend conectado ao Gateway de Pagamento.
De acordo com a **US02 (Processo de Compra)**, a emissão oficial do bilhete em PDF só ocorre após a transação financeira ser dada como concluída. Por isso, existe uma relação estrita de `1 para 1`: cada passagem emitida corresponde a exatamente uma transação financeira processada pelo backend através do método `+processarCheckout()`.

#### 6. Notificações e Engajamento
<div align="center"> 

<img width="727" height="216" alt="Captura de tela 2026-06-14 211821" src="https://github.com/user-attachments/assets/e14deec8-3b52-489d-a53d-913e35b95387" />

</div>

Atende diretamente ao requisito da **US04 (Notificações em massa disparadas pelo proprietário)**.
Quando um proprietário emite um alerta de atraso ou mudança climática, esse disparo é indexado no PostgreSQL e amarrado diretamente ao identificador daquela `Viagem`. A operação `+dispararEmMassa()` permite que o serviço de mensageria do backend encaminhe a mensagem de alerta estritamente aos passageiros com passagens ativas para aquela rota específica.

#### 7. Padronização de Estados (Enumerações)
<div align="center"> 

<img width="858" height="503" alt="image" src="https://github.com/user-attachments/assets/cd07ddd9-b4c6-4a18-9142-919972af0311" />

</div>

Para garantir a integridade do banco de dados, as classes de negócio utilizam relações de dependência (setas tracejadas) apontando para Enumerações (`<<enumeration>>`):
* **`Pagamento` $\rightarrow$ `StatusPagamento`:** O checkout não pode aceitar um texto qualquer para registrar a transação. O status restringe o sistema a aceitar apenas `PENDENTE`, `APROVADO`, `RECUSADO` ou `ESTORNADO`.
* **`Viagem` $\rightarrow$ `StatusViagem`:** Amarra as regras de agendamento e telemetria. O status da viagem (`AGENDADA`, `EM_ANDAMENTO`, `CONCLUIDA`, `CANCELADA`) dita o comportamento de busca de rotas para o viajante.
* **`Bilhete` $\rightarrow$ `StatusBilhete`:** Ligado à US06, o sistema precisa garantir o estado da passagem (`RESERVADO`, `EMITIDO`, `CANCELADO`) antes de renderizar os dados de acessibilidade ou gerar o PDF offline de forma segura.

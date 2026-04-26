# Golden Circle

<div align = "justify">
 
A concepção do Porto Certo utiliza a metodologia Golden Circle para alinhar o desenvolvimento técnico ao propósito do projeto. Esta estrutura garante que a solução resolva gargalos reais de forma inovadora e escalável:
- **O Porquê (Why)**: O propósito central e a mitigação da dor social que motivou o projeto;
- **O Como (How)**: A arquitetura de inovação e os diferenciais tecnológicos do sistema;
- **O Quê (What)**: A materialização do produto e suas funcionalidades entregues ao usuário.

<div align = "center">

<img width="1920" height="1080" alt="Golden-Circle" src="https://github.com/user-attachments/assets/456524e3-683e-4e33-9f66-b61d019770e8" />

</div>

<br>
<br>
<br>

**1 - O Porquê (Propósito e Dor Social a resolver)**
 O sistema nasce da necessidade de combater a persistente desorganização e a falta de transparência nas rotas fluviais, fatores que submetem passageiros e proprietários à incerteza, à perda de tempo e a dificuldades logísticas presentes na região. O objetivo central é proporcionar previsibilidade e dignidade ao transporte fluvial, eliminando a fragmentação de informações que gera frustrações no dia a dia dos usuários.

**2. O Como (Diferencial ou Inovação)**
A inovação do sistema reside na integração bilateral de um ecossistema digital que atende simultaneamente passageiros e proprietários. Diferente das soluções isoladas, o Porto Certo utiliza centralização de dados em tempo real e inteligência de suporte via chatbot para converter o caos logístico em um fluxo de informações organizado, seguro e auditável através de avaliações e sistemas de reserva.

**3. O Quê (Solução Entregue)**
O Sistema Porto Certo, composto por uma plataforma Web e um Aplicativo Android. A solução entrega um conjunto de interfaces funcionais que permitem a visualização de embarques, compra de passagens, rastreio de encomendas e notificações, além de um módulo administrativo para proprietários gerenciarem seus perfis, frotas e cronogramas de viagens

</div>

# Exploração do mercado

# SWOT
A elaboração do SWOT foi feito para mapear os cenários internos e externos do nosso sistema, aqui temos os seguintes pontos levantados pela ferramenta:

<div align = "center">

<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/021ef623-1631-4dfa-b85c-524befeceb4c" />

</div>

## Pontos Fortes

<div align = "justify">

- **UX/UI**: O público-alvo pode ter diferentes níveis de letramento digital. Se o aplicativo travar ou tiver um fluxo confuso, o passageiro desiste e volta a comprar no porto. O sistema precisa ser à prova de frustração;

- **Acessibilidade Nativa e Inclusão Digital**: Suporte total a leitores de tela (como o TalkBack) e navegação simplificada para usuários com deficiência visual ou baixo letramento digital.A maioria dos apps concorrentes ignora completamente a acessibilidade. Isso abre as portas para uma parcela significativa da população e gera um forte apelo social e de inclusão;

- **Arquitetura Escalável**: Importância técnica estrutural. O banco de dados e o backend precisam ser desenhados para aguentar o tráfego de centenas de embarcações e milhares de usuários simultâneos sem lentidão;

- **Dados e Previsibilidade**: O sistema precisa ter painéis (dashboards) que processem os dados de venda em tempo real e de forma precisa. Se o relatório mostrar um barco vazio quando ele está cheio, o operador perde dinheiro e abandona a plataforma.

</div>

## Pontos fracos

<div align = "justify">

- **Dependência de Conectividade**: Este é o maior desafio técnico na nossa região amazônica. O sistema não pode ser 100% dependente da nuvem o tempo todo. Ele precisa de uma arquitetura que suporte modo offline (como cache local no celular) para que a validação de passagens via QR Code funcione mesmo no meio do rio, sem sinal;

- **Custo de Aquisição**: O sistema deve ter fluxos de cadastro simples (como login via Google ou WhatsApp) que reduzam a barreira de entrada para o usuário novo;

- **Dependência B2B**: O painel do dono do barco precisa ser extremamente atrativo e fácil de usar. Se o cadastro (onboarding) da frota for burocrático no sistema, eles não vão aderir;

- **Limitações**: A interface precisa ser clara em relação ao que é permitido. Mensagens de erro e tooltips bem escritos evitam que o usuário tente comprar espaço para uma moto e fique frustrado por não encontrar a opção.

</div>

## Oportunidades

<div align = "justify">

- **Precificação Dinâmica:** O app cria a oportunidade de os donos de barcos variarem o preço da passagem conforme a demanda e a antecedência da compra, mais barato dias antes, mais caro nas últimas horas ou quando o barco está lotando, maximizando a margem de lucro.;

- **Integração Intermodal:** A oportunidade de conectar o aplicativo com outros modais via API. O sistema pode se integrar com aplicativos de transporte urbano locais, cooperativas de táxi ou agências de turismo, permitindo vender a jornada completa do passageiro (ex: Aeroporto/Hotel -> Porto -> Destino Fluvial) em um único ecossistema.;

- **Expansão para Encomendas:** Importância crucial para a modelagem de dados. A tabela de Viagens no banco de dados deve ser construída hoje com flexibilidade para que, em uma próxima sprint, a entidade Cargas seja acoplada facilmente à mesma viagem, sem quebrar a lógica dos passageiros.

</div>

## Ameaças 

<div align = "justify">

- **Boicote de Cambistas**: O sistema precisa de logs de auditoria pesados e validação rigorosa de usuários (ex: confirmação por SMS/E-mail). Isso evita que atores mal-intencionados criem contas falsas para "travar" reservas de passagens e prejudicar as vendas legítimas;


- **Instabilidade Climática**: O sistema não pode tratar apenas o "caminho feliz" (a viagem que dá certo). Ele precisa obrigatoriamente de fluxos de cancelamento em massa, reagendamento simplificado e estorno automatizado (refund) para quando os rios secarem e as frotas pararem;

- **Regras da Marinha/Capitania**: O código precisa ser modular. Se amanhã a Marinha exigir o número do CPF e o nome da mãe de todos os passageiros no bilhete, a equipe deve conseguir adicionar esses campos no formulário de compra rapidamente, sem quebrar o resto do app.

## 3. Matriz TOWS: Estratégias de Cenários

A tabela abaixo cruza os fatores internos (Forças e Fraquezas) com os fatores externos (Oportunidades e Ameaças) para formular planos de ação estratégicos para o aplicativo.

</div>

## Identificação Visual de Soluções Existentes

<div align = "justify">

Para a exploração de mercado,a equipe realizou uma coleta buscando soluções que abordam o mesmo problema ou que se assemelham ao nosso sistema. o grupo identificou a seguintes soluções:

</div>

<div align="center">

<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/ade0fed0-4221-4438-a389-55683650de48" />

<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/93d628cb-01fb-4696-a44c-40bf45a317f1" />

<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/6630da04-4d44-4089-b3e4-77a9a95b6dfb" />

</div>

## Quadro Comparativo
Em seguida, com base nas soluções encontradas, elaboramos uma tabela para identificar e comparar seus diferentes aspectos: 

| **Critérios/ Soluções** | **Solução A** | **Solução B** | **Solução C** | **Nossa Solução** |
| :---: | :---: | :---: | :---: | :---: |
| **Tecnologia utilizada** | web | web | web | mobile |
| **Público Alvo** | Jovens e Adultos | Jovens e Adultos | Jovens e adultos | Jovens e Adultos |
| **Pontos Fortes**| Possibilidade de comprar pelo site/ Possibilidade de transportar veículos/ Parcelamento da compra | É possível comprar passagens, apresenta uma boa interface | POssibilidade de parcelamento na compra de passagens | Mais de uma modalidade de pagamento/ Possibilidade de Parcelmento/ Geolocalização dos barcos em tempo real | 
| **Pontos Fracos/ Limitações** | Não tem geolocalização/ o sistema não informa se há espaço para veículos na embarcação e depende do dono da embarcação para haver um resposta | Não faz transporte de veículos/ mercadorias/ Não tem geolocalização dos barcos | Falta de informação dos barcos/ poucas imagens dos barcos | Transporte de veículos e mercadorias não vai ser realizado |

# Personas

<div align = "justify">

Persona é a representação fictícia do cliente, sendo uma criação de suas histórias pessoais, motivações, objetivos, desafios e preocupações.
A partir desse contexto, o desenvolvimento das personas do nosso sistema deram uma visão melhor do nosso público alvo, suas necessidades e suas dores reais.

## Persona 1 (Lucas, O Viajante):

<div align = "center">

<img src= "https://github.com/user-attachments/assets/21fc9b22-6cc3-480f-9335-dba368942bbf"/>

## Persona 2 (Manuel, O Proprietário):

<img src= "https://github.com/user-attachments/assets/9a24aa81-2c4b-413d-b3f8-84e873820eee"/>

## Persona 3 (Ana, Deficiência Visual):

<img src= "https://github.com/user-attachments/assets/b66e6aa9-d4a4-4290-a20f-01ffa7c223f7"/>

</div>

# Ideação
<div align="justify">
Após compreendermos o problema, o mercado e as dores de nossos usuários, avançamos para a fase de geração de ideias. Cada integrante da equipe contribuiu com soluções iniciais baseadas nos estudos de inspiração, que foram posteriormente discutidas, combinadas e refinadas coletivamente para definir o escopo funcional do Porto Certo.
</div>

## Registro de Brainstorming
Toda a documentação das ideias individuais, o processo de discussão e as propostas selecionadas pela equipe estão centralizados em nossa página no notion.

> 🔗 [Acesse a Página de Ideação no Notion](https://www.notion.so/a5f7b50cb8ba82468c5181366d8a4503?v=d097b50cb8ba82be9197089457837923&pvs=10)

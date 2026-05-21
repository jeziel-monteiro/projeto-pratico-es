# Modelo C4

<div align="justify">

O C4 Model é uma metodologia de mapeamento visual para arquiteturas de sistemas, desenhada para explicar a estrutura de um software de forma progressiva. Seu nome deriva de suas quatro camadas principais de abstração: Contexto, Contêiner, Componente e Código. Essa divisão estruturada permite que o sistema seja analisado desde um panorama macro, focado nas integrações gerais, até as minúcias técnicas da implementação.

Uma de suas principais características é a utilização de um design visual limpo e minimalista. A notação gráfica entrega níveis de detalhe sob medida, evitando sobrecarregar o leitor com informações desnecessárias para o contexto que ele precisa analisar.

Ao simplificar a visualização técnica, o modelo atua como uma ponte de comunicação crucial entre desenvolvedores e gestores. Ele resolve os atritos clássicos entre a área de negócios e a de tecnologia, traduzindo a complexidade do sistema em diagramas que todas as partes interessadas conseguem compreender com facilidade. Essa clareza colabora diretamente para uma documentação mais ágil e torna o processo de manutenção e evolução do software muito mais fluido e alinhado.

# Diagrama de Contexto

No Diagrama de Contexto seu sistema é desenhado como uma caixa central, cercado diretamente pelos usuários que o utilizam e pelos outros sistemas com os quais ele interage. Como essa é uma visão panorâmica e distanciada da arquitetura, o detalhamento não é importante nesta fase. O foco deve estar estritamente nas pessoas (atores, papéis, personas) e nas dependências de software. 

Em relação à sua estrutura, o escopo foca em apenas um sistema de software, que atua como o elemento principal. Os elementos de apoio são justamente as pessoas e os sistemas externos conectados diretamente a ele, sendo que esses softwares secundários geralmente ficam fora da sua fronteira de responsabilidade ou domínio corporativo.

## Diagrma do Projeto

<img width="5288" height="6728" alt="Diagrama_Contexto drawio" src="https://github.com/user-attachments/assets/327df16d-d312-491b-938c-f7390e1e8e55" />

## Componentes do Diagrama

### Sistema Central (Software System)

- **Porto Certo:** É o coração da operação. Funciona como um hub digital (Aplicativo Móvel e Software Comercial) que unifica a venda de passagens, o controle da frota fluvial e o monitoramento das viagens em tempo real.

### Os Usuários (Person)

- **Viajante:** É o consumidor final. A pessoa física que utiliza o aplicativo buscando a compra de passagens fluviais.

- **Proprietário:** É o fornecedor comercial. A pessoa ou empresa dona das embarcações, responsável por garantir a infraestrutura de transporte oferecida na plataforma.

### Os Sistemas Externos (Software System)

- **Gateway de Pagamento:** Uma instituição financeira que garante que as transferências de dinheiro sejam feitas com segurança e liquidez.

- **Serviço de Mensageria:** Um provedor de telecomunicações focado na entrega de mensagens, documentos e alertas fora do ambiente do aplicativo.

## Ligação dos Componentes

**Ações do Viajante-> Sistema:** O Viajante interage ativamente com o sistema enviando comandos para acessar a plataforma, buscar rotas disponíveis, reservar bilhetes e efetuar a compra de passagens.

**Ações do Proprietário -> Sistema:** O Proprietário atua na gestão. Ele envia dados para o sistema ao cadastrar suas embarcações, criar as rotas de viagem, iniciar e encerrar os trajetos, emitir notificações aos passageiros e consultar seus relatórios de faturamento.

**Sistema -> Gateway de Pagamento:** Sempre que o Viajante finaliza uma compra de passagem, o sistema pega os dados dessa intenção de compra e os envia para o Gateway de Pagamento. O sistema externo é quem processa a transação real e devolve a confirmação.

**Sistema -> Serviço de Mensageria:** Quando o Proprietário decide emitir uma notificação sobre a viagem (ou quando o sistema precisa enviar o bilhete do passageiro), o sistema aciona o Serviço de Mensageria. É este provedor externo que realiza o disparo real dos e-mails, SMS ou alertas para os dispositivos dos usuários.

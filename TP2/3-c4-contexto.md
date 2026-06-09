# Modelo C4

<div align="justify">

O C4 Model é uma metodologia de mapeamento visual para arquiteturas de sistemas, desenhada para explicar a estrutura de um software de forma progressiva. Seu nome deriva de suas quatro camadas principais de abstração: Contexto, Contêiner, Componente e Código. Essa divisão estruturada permite que o sistema seja analisado desde um panorama macro, focado nas integrações gerais, até as minúcias técnicas da implementação.

Uma de suas principais características é a utilização de um design visual limpo e minimalista. A notação gráfica entrega níveis de detalhe sob medida, evitando sobrecarregar o leitor com informações desnecessárias para o contexto que ele precisa analisar.

Ao simplificar a visualização técnica, o modelo atua como uma ponte de comunicação crucial entre desenvolvedores e gestores. Ele resolve os atritos clássicos entre a área de negócios e a de tecnologia, traduzindo a complexidade do sistema em diagramas que todas as partes interessadas conseguem compreender com facilidade. Essa clareza colabora diretamente para uma documentação mais ágil e torna o processo de manutenção e evolução do software muito mais fluido e alinhado.

# Diagrama de Contexto

No Diagrama de Contexto, o sistema analisado é desenhado como uma caixa central, cercado diretamente pelos usuários que o utilizam e pelos outros sistemas com os quais interage. Por se tratar de uma visão panorâmica e distanciada da arquitetura, o detalhamento técnico não é relevante nesta fase, fazendo com que o foco recaia estritamente sobre as pessoas, como atores ou personas, e nas dependências de software.

Em relação à sua estrutura, a modelagem possui um escopo voltado para apenas um sistema de software, que atua como o elemento principal. Os elementos de apoio são representados justamente por essas pessoas e pelos sistemas externos conectados diretamente ao núcleo, sendo que esses softwares secundários geralmente se situam fora da fronteira de responsabilidade ou do domínio corporativo da organização principal.

## Diagrama do Projeto

<img width="12863" height="16384" alt="DiagramaC1A drawio" src="https://github.com/user-attachments/assets/0e0bf8f5-9cbc-450f-9141-adb9468741eb" />

## Componentes do Diagrama

### Sistema Central (Software System)

- **Porto Certo:** Plataforma digital central responsável por unificar a comercialização de passagens, o controle logístico de frotas e a orquestração dos dados de viagem.

### Os Usuários (Person)

- **Viajante:** O consumidor final que utiliza o aplicativo para buscar rotas, comprar e gerenciar passagens e acompanhar o deslocamento fluvial.
  
- **Proprietário:** O fornecedor comercial que utiliza o software para gerenciar embarcações, cadastrar rotas e monitorar o faturamento.

### Os Sistemas Externos (Software System)

- **Gateway de Pagamento:** Serviço financeiro que processa transações imediatas (Como o Pix e Cartão) e gerencia a emissão e conciliação assíncrona de boletos bancários

- **Serviço de Geolocalização:** Infraestrutura externa de mapeamento utilizada para renderizar as coordenadas e calcular trajetos.

## Ligação dos Componentes

**Ações do Viajante-> Sistema:** O Viajante interage ativamente com o sistema enviando comandos para acessar a plataforma, buscar rotas disponíveis, reservar bilhetes e efetuar a compra de passagens.

**Ações do Proprietário -> Sistema:** O Proprietário atua na gestão. Ele envia dados para o sistema ao cadastrar suas embarcações, criar as rotas de viagem, iniciar e encerrar os trajetos, emitir notificações aos passageiros e consultar seus relatórios de faturamento.

**Sistema -> Gateway de Pagamento:** O sistema envia dados de transações para processamento de Cartão de Crédito/Pix e registra cobranças de Boletos Bancários, recebendo de volta a confirmação assíncrona de compensação.

**Sistema -> Serviço de Geolocalização:** Provedor externo de mapas utilizado pelo sistema para calcular rotas, plotar as coordenadas geradas pela telemetria da embarcação e exibir o mapa interativo aos usuários.

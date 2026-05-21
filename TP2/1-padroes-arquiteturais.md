# Padrões Arquiteturais

<div align="justify">

Padrões arquiteturais são estruturas conceituais que definem a organização global e a divisão de responsabilidades em um sistema de software, funcionando como soluções consolidadas para problemas complexos e recorrentes de engenharia. Enquanto os padrões de projeto atuam em nível de código, os arquiteturais determinam a macroestrutura e o fluxo de comunicação entre os subsistemas.

Para o contexto do sistema Porto Certo, identificamos dois padrões arquiteturais adequados para a construção do MVP, os quais serão apresentados detalhadamente abaixo.

</div>

---

## CQRS (Command Query Responsibility Segregation)

<div align="justify">

### Descrição do padrão arquitetural

O CQRS fundamenta-se na separação estrita entre as operações de escrita (Comandos) e as operações de leitura (Consultas). Em vez de utilizar um único modelo de dados para todo o sistema, o CQRS divide o backend em duas estradas independentes: uma otimizada para processar transações e mudanças de estado, e outra otimizada para buscas rápidas e renderização de interfaces.

### Justificativa da escolha

A abordagem CQRS se aplica ao Porto Certo por dois motivos centrais:

- **Performance em Picos de Demanda**: Em períodos de grandes deslocamentos regionais (festivais ou feriados), o volume de buscas por rotas cresce exponencialmente. Com o CQRS, a camada de consulta pode ser escalada e cacheada independentemente, garantindo que o passageiro consiga pesquisar viagens sem sofrer lentidão causada pelo processamento pesado de faturamentos ou agendamentos ocorrendo simultaneamente.

- **Especialização de Modelos de Dados**: No Porto Certo, o modelo necessário para "Vender uma Passagem" (que exige travas de segurança e validação de assentos) é muito diferente do modelo para "Exibir a Cédula de Embarque Offline". A segregação permite que cada lado da arquitetura utilize a estrutura de dados mais eficiente para sua função.

### Aplicação no sistema

- **Lado de Comando** (Writes): Responsável por processar ações que alteram o estado do sistema, como a compra de passagens, o cancelamento de reservas com estorno e a publicação de novas rotas pelo proprietário. Aqui, o sistema foca em integridade e validação de regras de negócio.

-** Lado de Consulta** (Reads): Responsável por alimentar a interface do usuário. Alimenta a busca de rotas, o mapa de geolocalização e o Dashboard de Faturamento. Os dados de leitura são projetados para serem consumidos instantaneamente, reduzindo o tempo de carregamento no aplicativo móvel.

</div>

---

## 2. Event Sourcing (Originação por Eventos)

<div align="justify">

### Descrição do padrão arquitetural

O Event Sourcing altera a forma como o estado do sistema é persistido. Em vez de salvar apenas o "valor atual" de uma linha no banco de dados, o sistema armazena uma sequência imutável de eventos que descrevem tudo o que aconteceu. O estado atual é obtido através da "reprodução" desses eventos em ordem cronológica.

### Justificativa da escolha

A escolha da Arquitetura em Camadas atende diretamente aos requisitos não funcionais prioritários do grupo:

- **Resiliência à Conectividade Intermitente**: Esta é a solução definitiva para o problema da internet no rio. O aplicativo pode gerar eventos localmente (como Coordenada_GPS_Coletada ou Checkin_Realizado) e mantê-los em uma fila local. Assim que o sinal é restabelecido, o sistema sincroniza a "corrente de eventos" com o servidor, garantindo que nenhuma informação seja perdida durante o trajeto.

- **Auditoria Financeira Imutável**: No Dashboard de Faturamento, a transparência é total. O saldo do proprietário não é apenas um número, mas o resultado de eventos como Passagem_Paga, Taxa_Administrativa_Retida e Estorno_Processado. Isso impede inconsistências nos cálculos de valor bruto e líquido e facilita auditorias em caso de disputas.

### Aplicação no sistema

- **Ciclo de Vida da Viagem**: A jornada de uma embarcação é registrada como uma série de eventos: Viagem_Agendada → Viagem_Iniciada → Localizacao_Atualizada → Viagem_Finalizada. Caso o passageiro acompanhe a geolocalização, o sistema reproduz esses eventos para desenhar a rota percorrida no mapa interativo.

- **Integridade do Bilhete**: A Cédula de Embarque Digital é gerada a partir do evento de confirmação de pagamento. Mesmo offline, o aplicativo possui a "prova" do evento de compra armazenada localmente, permitindo que a identificação visual (Nome, CPF e RG) seja validada pelo comandante sem a necessidade de consultar o servidor central no momento do embarque.

A união desses padrões permite que o Porto Certo funcione como um sistema de registro histórico. Quando um comando é executado (ex: comprar passagem), ele gera um evento (Passagem_Comprada). Esse evento é salvo no Event Store (Escrita) e, simultaneamente, atualiza a base de dados de leitura para que o passageiro veja seu bilhete na tela de "Meus Bilhetes" imediatamente. Essa arquitetura garante um sistema à prova de falhas, auditável e perfeitamente adaptado aos desafios geográficos da Amazônia.
</div>
# Padrões Arquiteturais

<div align="justify">

## Visão geral dos Requisitos do Sistema

Padrões arquiteturais são estruturas conceituais que definem a organização global e a divisão de responsabilidades em um sistema de software, funcionando como soluções consolidadas para problemas complexos e recorrentes de engenharia. Enquanto os padrões de projeto atuam em nível de código, os arquiteturais determinam a macroestrutura e o fluxo de comunicação entre os subsistemas.

Para o contexto do sistema Porto Certo, identificamos dois padrões arquiteturais adequados para a construção do MVP, os quais serão apresentados detalhadamente abaixo.

</div>

---

##  Cliente-Servidor (Client-Server)

<div align="justify">

### Descrição do padrão arquitetural

A arquitetura **cliente-servidor** é um modelo computacional que divide tarefas ou cargas de trabalho entre provadores de serviços, chamados servidores, e solicitantes de serviços, chamados clientes. Esse modelo foi projetado para melhorar a eficiência e o desenvolvimento de recursos, centralizando as funções do servidor, que lidam com o processamento e o desenvolvimento de dados, chegando aos clientes interagindo com o usuário e solicitando serviços ao servidor.

<img width="1333" height="750" alt="Image" src="https://github.com/user-attachments/assets/4f8ecbea-9006-48a3-beea-8f92bf37ebb1" />

<br>
<br>
<br>

**Cliente**: Este é o ponto de acesso inicial, representado por um navegador da web, aplicativo móvel ou outro software. O cliente envia solicitações ao servidor, como a requisição de páginas da web, dados ou serviços específicos.

**Servidor**: O servidor é onde residem os recursos requisitados pelo cliente. Ele processa as solicitações, recuperando informações de um banco de dados. Executando códigos e retornando os resultados de volta ao cliente, seja uma página da web, um arquivo ou qualquer dado requisitado.

### Justificativa da escolha

A abordagem Cliente-Servidor se aplica ao Porto Certo pelos seguintes motivos:

- **Gerência**: O gerenciamento centralizado é uma das vantagens mais significativas da arquitetura cliente-servidor. Ao consolidar o controle de dados, aplicativos e segurança no servidor, os administradores podem garantir a consistência em toda a rede. Essa centralização simplifica tarefas como atualizações, backups e solução de problemas, resultando em uma manobra mais eficiente e redução do tempo de inatividade.

- **Escalabilidade**: A arquitetura cliente-servidor é altemente escalável, permitindo que as empresas cresçam sem grandes interrupções. Os servidores podem ser atuaizados com hardware mais potente ou recursos adicionais para lidar com um número crescente de solicitações de clientes. Essa flexibilização possibilita uma expansão incremental dos serviços e da capacidade de uso, garantindo que o sistema possui atender às demandas em constante evolução.

- **Segurança**: Servidores centralizados permitem medidas de segurança robustas para proteger informações confidenciais. Os administradores podem implementar protocolos de segurança abertas, monitorar o acesso e aplicar políticas de formação consistente. Isso reduz o risco de violações de dados e acesso não autorizado, garantindo que as confidências permaneçam segundos.

- **Confiabilidade e disponibilidade**: Os sistemas cliente-servidor são projetados para serem confidenciais e disponíveis. Os servidores geralmente possuem componentes redundantes e sistemas de backup para garantir uma operação contínua. Em caso de falha de um servidor, os clientes podem ser redirecionados para servidores de backup, minimizando o tempo de inatividade e mantendo a disponibilidade do serviço.

### Aplicação no sistema

No ecossistema Porto Certo, o padrão manifesta-se através da comunicação entre o aplicativo móvel e o servidor backend unificado:

* **Lado Cliente:** Composto pelo **Aplicativo Móvel Android**, operando em modo multi-perfil para oferecer visões dedicadas ao Passageiro e ao Proprietário. O cliente consome os serviços expostos pelo servidor para realizar buscas de viagens, enviar dados de faturamento para validação e renderizar as coordenadas de geolocalização processadas.
* **Lado Servidor:** Uma aplicação backend centralizada, responsável pelo gerenciamento do banco de dados relacional, que valida as regras críticas de integridade. O servidor executa o motor financeiro de faturamento do proprietário, bloqueia agendamentos de viagens fora do prazo de 12 horas e processa requisições de estorno automático em caso de cancelamento de rotas.

</div>

---

# Visão geral da Arquitetura do Sistema

<img width="1117" height="855" alt="Image" src="https://github.com/user-attachments/assets/55188711-0c87-4b7e-96b6-679171dda24c" />

<br>
<br>
<br>

<img width="1663" height="781" alt="Image" src="https://github.com/user-attachments/assets/12ed8346-7069-443a-aab4-33ddf12177bb" />

<br>
<br>
<br>

<div align="justify">

1. **Interface do Cliente**: O fluxo se inicia na camada do usuário. No módulo de Solicitação de Passagens, os passageiros interagem com os filtros de busca e telas de compra. No módulo de Gerenciamento de Embarcações, os proprietários controlam dados de frotas e escalas. Esta etapa é responsável por gerenciar os Formulários e Validação superficiais (como checagem de máscaras de campos obrigatórios) diretamente no dispositivo do usuário antes do envio.

2. **Transmissão**: Assim que a ação é disparada, os dados entram na fase de trânsito como uma Requisição. Esta camada garante a Transferência Segura de Dados através de Criptografia de Rede, encapsulando informações confidenciais (como dados de checkout) em um ambiente de Pagamento Protegido antes que alcancem a nuvem.

3. **Processamento no Servidor**: Os dados chegam ao ecossistema do servidor. Aqui é onde reside a inteligência centralizada do sistema: a Lógica de Negócio computa as regras operacionais, as Verificações de Segurança barram acessos não autorizados e a Validação de Recursos avalia a disponibilidade de ativos (como assentos livres) em tempo real, impedindo conflitos ou duplicidades de dados.

4. **Persistência e Serviços**: Após processar e validar as regras de negócio, o servidor interage com a camada de dados e terceiros. Ele consolida as informações no Repositório Central de Dados, aciona os Serviços Externos necessários (como parceiros financeiros de cobrança ou infraestruturas de mapas) e gera os insumos para os Relatórios Financeiros consolidados dos operadores.

5. **Resposta em Trânsito**: O resultado das operações do servidor é empacotado e enviado de volta através de uma Resposta. O pacote trafega como uma Resposta Encapsulada e otimizada por técnicas de Compressão de Dados. Esta etapa também prepara os metadados estruturados para lidar com cenários de Sinalização Offline, permitindo que o cliente saiba exatamente o estado da operação mesmo sob conectividade instável.

6. **Exibição e Cache**: O ciclo se encerra no dispositivo cliente. O aplicativo recebe o retorno do servidor e realiza a Renderização Local (UI) na tela do usuário, aplicando dinamicamente os Recursos de Acessibilidade configurados. Simultaneamente, o sistema realiza o Armazenamento Offline dos dados cruciais (como a estrutura digital do bilhete de viagem) no cache interno do aparelho, o que garante a autonomia para consultas e checagem visual de dados mesmo em locais completamente isolados e sem internet.
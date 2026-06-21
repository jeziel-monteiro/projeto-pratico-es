# Classes de Equivalência
<div align="justify">
Esta seção apresenta as classes de equivalência e os casos de teste definidas para as histórias de usuário do sistema. A técnica foi aplicada com base nos critérios de aceitação e regras de negócio previamente especificados, considerando as principais condições de entrada válidas e inválidas para cada funcionalidade.
</div>

# Busca de Viagens

**US01**: Enquanto viajante, desejo buscar por viagens informando origem, destino e data, para encontrar opções de transporte disponíveis que atendam à minha necessidade.

 **Critérios de aceitação**

- **CR01**: A tela de busca deve conter filtros obrigatórios para "Origem", "Destino" e "Data".
- **CR02**: O sistema deve exibir uma lista de resultados contendo o nome da embarcação, horário de saída, duração e preço.
- **CR03**: As consultas de busca ao sistema devem ser respondidas e listadas na tela em até três segundos.
- **CR04**: O sistema deve permitir registrar como "Favoritos" os trechos e viagens que são de interesse recorrente do usuário.

**Regras de Negócio**

- **RN01**: Listar apenas viagens com vagas disponíveis e com embarque que ainda não foi realizado a viagem.

## Classes de Equivalência

| Condição de Entrada                       | Classe Válida                                      | Classe Inválida                            | Classe Inválida                |
| :-----------------------------------------: | :--------------------------------------------------: | :------------------------------------------: | :------------------------------: |
| Filtros da busca (Origem, Destino e Data) | Origem, destino e data informados corretamente (1) | Algum filtro obrigatório não informado (2) | Dados inválidos para busca (3) |
| Disponibilidade da viagem                 | Viagem com vagas disponíveis (4)                   | Viagem sem vagas disponíveis (5)           |                                |
| Status da viagem                          | Embarque ainda não realizado (6)                   | Embarque já iniciado ou realizado (7)      |                                |

## Casos de Teste 

| Casos de Teste | Classes de <br> Equivalência | <div align="center">Entradas</div> | <div align="center">Resultado Esperado</div> |
| :---: | :---: | :--- | :--- |
| **Caso 1** | 1, 4, 6 | **Origem:** "Manaus"<br>**Destino:** "Parintins"<br>**Data:** "20/12/2026" | O sistema processa a busca com sucesso e exibe a lista de viagens disponíveis para o trecho e data informados. (Origem, destino e data informados corretamente) |
| **Caso 2** | 2, 4, 6 | **Origem:** "Manaus"<br>**Destino:** *[Em branco]*<br>**Data:** "20/12/2026" | Busca rejeitada. O sistema exibe uma mensagem de erro solicitando o preenchimento de todos os filtros obrigatórios. (Algum filtro obrigatório não informado) |
| **Caso 3** | 3, 4, 6 | **Origem:** "1234"<br>**Destino:** "@#$%"<br>**Data:** "32/13/2026" | Busca rejeitada. O sistema exibe uma mensagem de erro indicando que os dados inseridos são inválidos. (Dados inválidos para busca) |
| **Caso 4** | 1, 5, 6 | **Origem:** "Manaus"<br>**Destino:** "Tefé"<br>**Data:** "15/11/2026" | A busca é processada, mas o sistema exibe uma mensagem indicando que as viagens para esta data estão esgotadas. (Viagem sem vagas disponíveis) |
| **Caso 5** | 1, 4, 7 | **Origem:** "Manaus"<br>**Destino:** "Coari"<br>**Data:** "10/01/2016" | A busca é processada, mas o sistema não lista as viagens. (Embarque já iniciado ou realizado) |

---

# Compra de Passagem

**US02**: Enquanto viajante, desejo realizar a compra de uma passagem fluvial informando meus dados e efetuando o pagamento, para garantir minha reserva na embarcação e receber o bilhete eletrônico de forma automatizada.

**Critérios de Aceitação:**

- **CR01**: O sistema deve permitir a seleção de origem, destino e data da viagem através de seletores claros e validados.
- **CR02**: O sistema deve exibir o valor total da compra, incluindo todas as taxas, de forma destacada antes da etapa de finalização do pagamento.
- **CR03**: O sistema deve disponibilizar um formulário para inserção dos dados do passageiro (Nome completo e documento) e campos para os dados da forma de pagamento escolhida.
- **CR04**: O sistema deve validar a transação em tempo real junto à operadora financeira e informar o usuário sobre o sucesso ou o motivo exato de uma eventual falha.
- **CR05**: Caso o processamento do pagamento demore mais de 2 segundos, o sistema deve exibir um indicador visual de progresso para evitar que o usuário abandone a tela.
- **CR06**: Após a aprovação, o sistema deve gerar automaticamente o bilhete eletrônico em PDF e enviá-lo para o e-mail cadastrado.
- **CR07**: O sistema deve armazenar em cache local do dispositivo os metadados do bilhete em PDF gerado após a compra, garantindo que o passageiro possa consultá-lo e exibi-lo mesmo em modo offline.
- **CR08**: O sistema deve exibir um alerta de confirmação caso o usuário tente fechar a tela ou voltar após já ter iniciado a inserção dos dados de pagamento.

**Regras de Negócio:**

- **RN01**: O sistema deve realizar uma última verificação de disponibilidade do assento escolhido imediatamente antes de processar a cobrança junto à operadora.
- **RN02**: O valor final da passagem não pode sofrer alterações após o usuário ter iniciado o preenchimento dos dados na etapa de pagamento.
- **RN03**: O processamento de dados sensíveis de cartão de crédito deve ser delegado a um gateway de pagamento homologado por meio de tokenização, proibindo o armazenamento de dados brutos de cartões no servidor local.
- **RN04**: Para atender às normas de proteção de dados e segurança financeira, dados sensíveis de cartão de crédito nunca devem ser armazenados de forma descriptografada no banco de dados.
- **RN05**: A geração e envio do bilhete eletrônico são ações condicionais, permitidas estritamente quando o status do pagamento retornado pela operadora for "Aprovado".


## Classes de Equivalência

| Condição de Entrada        | Classe Válida                                          | Classe Inválida                        | Classe Inválida                                |
| :--------------------------: | :------------------------------------------------------: | :--------------------------------------: | :----------------------------------------------: |
| Dados da viagem            | Origem, destino e data válidos (1)                     | Dados não informados (2)               | Dados inválidos (3)                            |
| Dados do passageiro        | Nome completo e documento preenchidos corretamente (4) | Nome não informado (5)                 | Documento inválido ou não informado (6)        |
| Disponibilidade do assento | Assento disponível (7)                                 | Assento indisponível (8)               |                                                |
| Forma de pagamento         | Forma de pagamento válida (9)                          | Forma de pagamento inválida (10)       | Dados de pagamento inválidos (11)              |
| Status do pagamento        | Pagamento aprovado (12)                                | Pagamento recusado (13)                | Falha na transação (14)                        |
| Emissão do bilhete         | Bilhete gerado após aprovação do pagamento (15)        | Bilhete não gerado após aprovação (16) | Bilhete gerado sem aprovação do pagamento (17) |

## Casos de Teste 

| Casos de Teste | Classes de <br> Equivalência | <div align="center">Entradas</div> | <div align="center">Resultado Esperado</div> |
| :---: | :---: | :--- | :--- |
| **Caso 1** | 1, 4, 7, 9, 12, 15 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "PIX" | O sistema processa a compra, aprova o pagamento com sucesso e disponibiliza o bilhete. (Bilhete gerado após aprovação do pagamento) |
| **Caso 2** | 2, 4, 7, 9, 12, 15 | **Viagem:** [Em branco]<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "PIX" | A compra é rejeitada na etapa inicial. O sistema alerta que os detalhes da viagem são obrigatórios. (Dados não informados) |
| **Caso 3** | 3, 4, 7, 9, 12, 15 | **Viagem:** "Destino Inválido (32/13/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "PIX" | A compra não avança. O sistema exibe uma mensagem indicando que a viagem selecionada possui informações incorretas. (Dados inválidos) |
| **Caso 4** | 1, 5, 7, 9, 12, 15 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** [Em branco]<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "PIX" | A compra é rejeitada. O sistema exibe um alerta exigindo o preenchimento do nome completo do passageiro. (Nome não informado) |
| **Caso 5** | 1, 6, 7, 9, 12, 15 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "000.000.000-00"<br>**Assento:** "15"<br>**Pagamento:** "PIX" | A submissão é bloqueada, exigindo que o utilizador insira um número de documento real. (Documento inválido ou não informado) |
| **Caso 6** | 1, 4, 8, 9, 12, 15 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15" (Ocupado)<br>**Pagamento:** "PIX" | O sistema impede a confirmação da reserva e exibe mensagem informando que a vaga foi preenchida. (Assento indisponível) |
| **Caso 7** | 1, 4, 7, 10, 12, 15 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "Cheque" | O sistema impossibilita a seleção informando que o método escolhido não é suportado pela plataforma. (Forma de pagamento inválida) |
| **Caso 8** | 1, 4, 7, 11, 12, 15 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "Cartão" (CVV incorreto) | O processo é interrompido na validação dos dados bancários preenchidos. (Dados de pagamento inválidos) |
| **Caso 9** | 1, 4, 7, 9, 13, 15 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "Cartão" (Sem limite) | O sistema informa que a operadora não autorizou a transação e interrompe a compra. (Pagamento recusado) |
| **Caso 10** | 1, 4, 7, 9, 14, 15 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "PIX" (Timeout na API) | O sistema notifica que houve um erro de comunicação com o banco/operadora e a transação falhou. (Falha na transação) |
| **Caso 11** | 1, 4, 7, 9, 12, 16 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "PIX" (Aprovado) | O pagamento é processado, mas ocorre erro interno e a tela exibe falha técnica ao tentar emitir o bilhete. (Bilhete não gerado após aprovação) |
| **Caso 12** | 1, 4, 7, 9, 12, 17 | **Viagem:** "Manaus a Parintins (20/12/2026)"<br>**Passageiro:** "João Silva"<br>**Documento:** "123.456.789-00"<br>**Assento:** "15"<br>**Pagamento:** "PIX" (Simulação de bypass) | Falha crítica de validação do sistema: ele emite indevidamente o bilhete ignorando o fluxo de aprovação. (Bilhete gerado sem aprovação do pagamento) |

---

# Cadastro de Embarcação

**US03**: Enquanto proprietário, desejo cadastrar os dados, fotos e especificações técnicas das minhas embarcações, para que os viajantes possam conhecer a infraestrutura e comodidades oferecidas antes de realizarem a compra da passagem.

**Critérios de Aceitação:**

- **CR01**: O sistema deve disponibilizar um formulário estruturado para a inserção do nome da embarcação, número de registro oficial, capacidade de passageiros, tipos de assentos e velocidade média.
- **CR02**: O sistema deve alertar o usuário e destacar os campos obrigatórios em vermelho caso ele tente salvar o cadastro sem preencher o nome, tipo e capacidade.
- **CR03**: O sistema deve permitir a seleção de comodidades da embarcação através de uma lista de opções (ex: ar-condicionado, lanchonete, espaço para redes).
- **CR04**: O sistema deve permitir o upload de fotos para a criação de uma galeria, notificando o proprietário imediatamente caso o arquivo não seja PNG/JPG ou ultrapasse 5MB.
- **CR05**: O sistema deve validar o registro oficial em tempo real e exibir uma mensagem de erro clara caso o número já esteja cadastrado, impedindo a submissão do formulário.
- **CR06**: O sistema deve oferecer um botão de "Pré-visualização", permitindo que o proprietário veja como o perfil da embarcação aparecerá para os viajantes antes de confirmar o salvamento.
- **CR07**: O sistema deve permitir que o proprietário gerencie suas embarcações, oferecendo opções de edição e exclusão. A exclusão deve acionar uma caixa de diálogo pedindo a confirmação final da ação para evitar exclusões acidentais.
- **CR08**: Ao concluir o cadastro, o sistema deve exibir uma mensagem de sucesso indicando que os dados foram salvos e que a embarcação encontra-se "Em Análise".

**Regras de Negócio:**

- **RN01**: O sistema deve bloquear o salvamento de qualquer cadastro que não possua os campos de nome, tipo e capacidade preenchidos.
- **RN02**: O número de registro oficial da embarcação é um identificador único no sistema; cadastros duplicados não são permitidos sob nenhuma hipótese.
- **RN03**: Toda nova embarcação inserida no sistema recebe automaticamente o status de "Em Análise", não sendo listada para os viajantes nas buscas de viagens até que seja aprovada.
- **RN04**: Apenas a conta do proprietário que criou o registro da embarcação (ou um perfil de Administrador da plataforma) tem permissão de sistema para editar ou excluir aquele cadastro.

## Classes de Equivalência

| Condição de Entrada              | Classe Válida                                        | Classe Inválida                                          | Classe Inválida                                |
| :--------------------------------: | :----------------------------------------------------: | :--------------------------------------------------------: | :----------------------------------------------: |
| Dados obrigatórios da embarcação | Nome, tipo e capacidade preenchidos corretamente (1) | Algum campo obrigatório não preenchido (2)               | Dados obrigatórios inválidos (3)               |
| Registro oficial da embarcação   | Registro oficial válido e único (4)                  | Registro oficial já cadastrado (5)                       | Registro oficial não informado ou inválido (6) |
| Fotos da embarcação              | Fotos em PNG/JPG com até 5MB (7)                     | Arquivo em formato diferente de PNG/JPG (8)              | Arquivo maior que 5MB (9)                      |
| Permissão de gerenciamento       | Proprietário criador ou administrador (10)           | Usuário sem permissão para editar ou excluir (11)        |                                                |
| Status do cadastro               | Nova embarcação registrada como "Em Análise" (12)    | Embarcação listada aos viajantes antes da aprovação (13) |                                                |

## Casos de Teste 

| Casos de Teste | Classes de <br> Equivalência | <div align="center">Entradas</div> | <div align="center">Resultado Esperado</div> |
| :---: | :---: | :--- | :--- |
| **Caso 1** | 1, 4, 7, 10, 12 | **Nome:** "Boto Fluvial"<br>**Tipo:** "Lancha"<br>**Capacidade:** "80"<br>**Registro:** "RE-12345-AM"<br>**Foto:** "perfil.jpg (2MB)"<br>**Usuário:** "Proprietário Logado" | O sistema realiza o cadastro da embarcação com sucesso no banco de dados. (Nome, tipo e capacidade preenchidos corretamente) |
| **Caso 2** | 2, 4, 7, 10, 12 | **Nome:** [Em branco]<br>**Tipo:** "Lancha"<br>**Capacidade:** "80"<br>**Registro:** "RE-12345-AM"<br>**Foto:** "perfil.jpg (2MB)"<br>**Usuário:** "Proprietário Logado" | O cadastro é rejeitado. O sistema exibe uma mensagem de erro alertando sobre o preenchimento de campos obrigatórios. (Algum campo obrigatório não preenchido) |
| **Caso 3** | 3, 4, 7, 10, 12 | **Nome:** "Boto Fluvial"<br>**Tipo:** "Lancha"<br>**Capacidade:** "-5"<br>**Registro:** "RE-12345-AM"<br>**Foto:** "perfil.jpg (2MB)"<br>**Usuário:** "Proprietário Logado" | O cadastro não avança. O sistema aponta erro informando que a capacidade não pode ser negativa ou que os dados possuem formato inválido. (Dados obrigatórios inválidos) |
| **Caso 4** | 1, 5, 7, 10, 12 | **Nome:** "Boto Fluvial"<br>**Tipo:** "Lancha"<br>**Capacidade:** "80"<br>**Registro:** "RE-11111-AM" (Já cadastrado)<br>**Foto:** "perfil.jpg (2MB)"<br>**Usuário:** "Proprietário Logado" | O sistema impede o envio e emite um alerta informando que a embarcação com este registro já existe na plataforma. (Registro oficial já cadastrado) |
| **Caso 5** | 1, 6, 7, 10, 12 | **Nome:** "Boto Fluvial"<br>**Tipo:** "Lancha"<br>**Capacidade:** "80"<br>**Registro:** "123-AM"<br>**Foto:** "perfil.jpg (2MB)"<br>**Usuário:** "Proprietário Logado" | O sistema bloqueia o envio e exige que o registro oficial siga o padrão formatado estabelecido pelos órgãos reguladores. (Registro oficial não informado ou inválido) |
| **Caso 6** | 1, 4, 8, 10, 12 | **Nome:** "Boto Fluvial"<br>**Tipo:** "Lancha"<br>**Capacidade:** "80"<br>**Registro:** "RE-12345-AM"<br>**Foto:** "documento.pdf (1MB)"<br>**Usuário:** "Proprietário Logado" | O upload é bloqueado. O sistema exibe um erro informando que o formato do arquivo não é suportado pela plataforma. (Arquivo em formato diferente de PNG/JPG) |
| **Caso 7** | 1, 4, 9, 10, 12 | **Nome:** "Boto Fluvial"<br>**Tipo:** "Lancha"<br>**Capacidade:** "80"<br>**Registro:** "RE-12345-AM"<br>**Foto:** "perfil.jpg (15MB)"<br>**Usuário:** "Proprietário Logado" | O upload é interrompido. O sistema exibe um alerta de que a imagem ultrapassa o limite máximo de tamanho permitido. (Arquivo maior que 5MB) |
| **Caso 8** | 1, 4, 7, 11, 12 | **Nome:** "Boto Fluvial"<br>**Tipo:** "Lancha"<br>**Capacidade:** "80"<br>**Registro:** "RE-12345-AM"<br>**Foto:** "perfil.jpg (2MB)"<br>**Usuário:** "Viajante Comum" | A ação é bloqueada pelo sistema, exibindo um aviso de erro de permissão de acesso para esta funcionalidade. (Usuário sem permissão para editar ou excluir) |
| **Caso 9** | 1, 4, 7, 10, 13 | **Nome:** "Boto Fluvial"<br>**Tipo:** "Lancha"<br>**Capacidade:** "80"<br>**Registro:** "RE-12345-AM"<br>**Foto:** "perfil.jpg (2MB)"<br>**Usuário:** "Proprietário Logado" (Simulação de bypass) | O sistema aplica obrigatoriamente o status "Em Análise" e bloqueia a exibição da embarcação no catálogo público, garantindo que não fique visível antes da aprovação de um administrador. (Embarcação listada aos viajantes antes da aprovação) |

---

# Notificações em Massa

**US04**: Enquanto proprietário, desejo enviar notificações em massa para os viajantes que compraram passagens para uma viagem específica, para informá-los rapidamente sobre imprevistos, atrasos, mudanças de rota ou cancelamentos, garantindo uma comunicação transparente e minimizando transtornos.

**Critérios de Aceitação:**

- **CR01**: O sistema deve permitir que o proprietário selecione uma de suas viagens (agendadas ou em andamento) para ser o alvo da notificação.
- **CR02**: O sistema deve disponibilizar um campo de texto para a redação do aviso, exibindo de forma clara um contador e o limite máximo de caracteres permitidos.
- **CR03**: Antes do disparo, o sistema deve exibir uma caixa de diálogo de confirmação (Alerta) mostrando a prévia da mensagem e informando a quantidade de passageiros que a receberão.
- **CR04**: Após a confirmação, o sistema deve disparar as mensagens (via Push Notification e/ou E-mail) para todos os viajantes com bilhetes válidos para aquela viagem.
- **CR05**: O sistema deve exibir um feedback de sucesso (Status do Sistema) informando que as notificações foram enviadas e processadas pela plataforma.
- **CR06**: O sistema deve manter um histórico visível para o proprietário com todas as notificações enviadas vinculadas àquela viagem.

**Regras de Negócio:**

- **RN01**: O disparo de notificações é sistêmico e restrito aos viajantes com reservas confirmadas na viagem selecionada. O proprietário não tem acesso direto aos dados pessoais (como e-mail ou telefone) dos usuários, sendo a plataforma a intermediária do envio.
- **RN02**: Só é permitido o envio de notificações para viagens que estejam com o status "Agendada" ou "Em Andamento". Viagens com status "Finalizada" ou "Cancelada" (após o aviso de cancelamento) têm o canal de notificação em massa bloqueado.
- **RN03**: Para evitar o uso indevido e o excesso de alertas nos dispositivos dos viajantes, o sistema deve impor um intervalo mínimo (cooldown) de 10 minutos entre o envio de notificações sucessivas para a mesma viagem.
- **RN04**: O cancelamento de uma viagem por parte do proprietário através do painel de calendário deve disparar de forma automatizada o gatilho de estorno (refund) financeiro para a operadora de pagamentos e publicar simultaneamente um alerta em massa no broker de notificações para os passageiros afetados.

## Classes de Equivalência

| Condição de Entrada          | Classe Válida                                        | Classe Inválida                         | Classe Inválida                   |
| :----------------------------: | :----------------------------------------------------: | :---------------------------------------: | :---------------------------------: |
| Viagem selecionada           | Viagem com status "Agendada" ou "Em Andamento" (1)   | Viagem com status "Finalizada" (2)      | Viagem com status "Cancelada" (3) |
| Passageiros destinatários    | Viajantes com reservas confirmadas (4)               | Viajantes sem reserva confirmada (5)    |                                   |
| Mensagem da notificação      | Mensagem preenchida corretamente (6)                 | Mensagem vazia (7)                      |                                   |
| Intervalo entre notificações | Envio respeitando intervalo mínimo de 10 minutos (8) | Envio antes de completar 10 minutos (9) |                                   |

## Casos de Teste 

| Casos de Teste | Classes de <br> Equivalência | <div align="center">Entradas</div> | <div align="center">Resultado Esperado</div> |
| :---: | :---: | :--- | :--- |
| **Caso 1** | 1, 4, 6, 8 | **Viagem:** "Manaus a Tefé (Agendada)"<br>**Destinatários:** "Passageiros confirmados"<br>**Mensagem:** "Atraso de 30 minutos na partida."<br>**Último Envio:** "Há 2 horas" | O sistema envia a notificação com sucesso para todos os passageiros da viagem. (Mensagem preenchida corretamente) |
| **Caso 2** | 2, 4, 6, 8 | **Viagem:** "Manaus a Tefé (Finalizada)"<br>**Destinatários:** "Passageiros confirmados"<br>**Mensagem:** "Obrigado por viajar conosco."<br>**Último Envio:** "Nenhum" | O sistema bloqueia o envio da notificação, pois a viagem já foi concluída. (Viagem com status "Finalizada") |
| **Caso 3** | 3, 4, 6, 8 | **Viagem:** "Manaus a Tefé (Cancelada)"<br>**Destinatários:** "Passageiros confirmados"<br>**Mensagem:** "Aviso sobre reembolso do trajeto."<br>**Último Envio:** "Nenhum" | O sistema bloqueia o envio da notificação, alertando que a viagem se encontra cancelada. (Viagem com status "Cancelada") |
| **Caso 4** | 1, 5, 6, 8 | **Viagem:** "Manaus a Tefé (Agendada)"<br>**Destinatários:** "Usuários sem reserva"<br>**Mensagem:** "Aviso geral para a viagem."<br>**Último Envio:** "Nenhum" | O sistema não permite o envio e exibe um alerta de que os destinatários selecionados não possuem reserva. (Viajantes sem reserva confirmada) |
| **Caso 5** | 1, 4, 7, 8 | **Viagem:** "Manaus a Tefé (Agendada)"<br>**Destinatários:** "Passageiros confirmados"<br>**Mensagem:** [Em branco]<br>**Último Envio:** "Há 30 minutos" | O envio falha e o sistema solicita o preenchimento obrigatório do campo de texto. (Mensagem vazia) |
| **Caso 6** | 1, 4, 6, 9 | **Viagem:** "Manaus a Tefé (Agendada)"<br>**Destinatários:** "Passageiros confirmados"<br>**Mensagem:** "Correção: Atraso de 40 min."<br>**Último Envio:** "Há 2 minutos" | O sistema bloqueia a ação e exige aguardar o tempo mínimo, exibindo um erro. (Envio antes de completar 10 minutos) |

---

# Acompanhamento em Tempo Real

**US05**: Enquanto viajante, desejo acompanhar o deslocamento do transporte em tempo real em um mapa interativo, para reduzir a incerteza sobre minha localização exata e planejar meu desembarque com base no tempo estimado de chegada.

**Critérios de Aceitação:**

- **CR01**: O usuário deve estar com o GPS ativado no dispositivo para ter acesso a sua visualização no mapa.
- **CR02**: O mapa deve exibir um icone representativo do transporte que se desloca suavemente conforme as coordenadas mudam.
- **CR03**: O sistema deve notificar ao usuário referente a perda de sinal por meio de uma mensagem simples (Exemplo: instabilidade na conexão com a internet") no centro da tela caso o sinal de GPS seja perdido ou esteja instável.
- **CR04**: A interface do mapa deve ser responsiva, permitindo gestos de zoom e rotação sem travamentos.
- **CR05**: O tempo de chegada deve ser recalculado automaticamente e exibido na tela sempre que houver desvios na rota original ou atrasos significativos em relação ao que foi estipulado no cadastro da viagem pelo proprietário.

**Regras de Negócio:**

- **RN01**: O sistema deve atualizar à posição do usuário no mapa em intervalos fixos de 10 segundos para otimizar o consumo de dados e bateria.
- **RN02**: O acesso ao mapa com geolocalização em tempo real só deve ser permitido enquanto os status da viagem for em "Andamento".
- **RN03**: O sistema deve emitir uma expectativa de tempo de chegada atualizada em casos de atrasos, desvios ou paradas não programadas.

## Classes de Equivalência

| Condição de Entrada        | Classe Válida                            | Classe Inválida                                 | Classe Inválida                        |
| :--------------------------: | :----------------------------------------: | :-----------------------------------------------: | :--------------------------------------: |
| GPS do dispositivo         | GPS ativo (1)                            | GPS desativado (2)                              | Sinal GPS instável ou indisponível (3) |
| Status da viagem           | Viagem com status "Em Andamento" (4)     | Viagem com status "Agendada" (5)                | Viagem com status "Finalizada" (6)     |
| Atualização de localização | Dados atualizados a cada 10 segundos (7) | Atualização fora do intervalo previsto (8)      | Dados de localização não enviados (9)  |
| Tempo estimado de chegada  | ETA calculado corretamente (10)          | ETA não atualizado após alterações de rota (11) | ETA inválido (12)                      |

## Casos de Teste

| Casos de Teste | Classes de <br> Equivalência | <div align="center">Entradas</div> | <div align="center">Resultado Esperado</div> |
| :---: | :---: | :--- | :--- |
| **Caso 1** | 1, 4, 7, 10 | **GPS do dispositivo:** "Ativo"<br>**Status da Viagem:** "Em Andamento"<br>**Atualização:** "Enviada em 10s"<br>**ETA:** "Calculado pelo sistema" | O sistema exibe o mapa interativo atualizando a localização do transporte a cada 10 segundos e mostrando a previsão de chegada. (ETA calculado corretamente) |
| **Caso 2** | 2, 4, 7, 10 | **GPS do dispositivo:** "Desativado"<br>**Status da Viagem:** "Em Andamento"<br>**Atualização:** "Enviada em 10s"<br>**ETA:** "Calculado pelo sistema" | O sistema exibe um pop-up solicitando permissão para ativar a localização do dispositivo do usuário. (GPS desativado) |
| **Caso 3** | 3, 4, 7, 10 | **GPS do dispositivo:** "Sinal instável"<br>**Status da Viagem:** "Em Andamento"<br>**Atualização:** "Enviada em 10s"<br>**ETA:** "Calculado pelo sistema" | O mapa informa que a localização do usuário não pode ser precisa devido à falta de sinal no dispositivo. (Sinal GPS instável ou indisponível) |
| **Caso 4** | 1, 5, 7, 10 | **GPS do dispositivo:** "Ativo"<br>**Status da Viagem:** "Agendada"<br>**Atualização:** "Enviada em 10s"<br>**ETA:** "Calculado pelo sistema" | O acompanhamento em tempo real fica inativo e uma mensagem informa que a viagem ainda não começou. (Viagem com status "Agendada") |
| **Caso 5** | 1, 6, 7, 10 | **GPS do dispositivo:** "Ativo"<br>**Status da Viagem:** "Finalizada"<br>**Atualização:** "Enviada em 10s"<br>**ETA:** "Calculado pelo sistema" | O sistema oculta o rastreamento em tempo real ou exibe uma notificação informando que a viagem já foi concluída. (Viagem com status "Finalizada") |
| **Caso 6** | 1, 4, 8, 10 | **GPS do dispositivo:** "Ativo"<br>**Status da Viagem:** "Em Andamento"<br>**Atualização:** "Atrasada (30s)"<br>**ETA:** "Calculado pelo sistema" | O sistema exibe um alerta de lentidão na atualização dos dados e mostra a última localização conhecida da embarcação. (Atualização fora do intervalo previsto) |
| **Caso 7** | 1, 4, 9, 10 | **GPS do dispositivo:** "Ativo"<br>**Status da Viagem:** "Em Andamento"<br>**Atualização:** "Falha no envio"<br>**ETA:** "Calculado pelo sistema" | O marcador no mapa fica estático e o sistema exibe um alerta de perda temporária de comunicação com a embarcação. (Dados de localização não enviados) |
| **Caso 8** | 1, 4, 7, 11 | **GPS do dispositivo:** "Ativo"<br>**Status da Viagem:** "Em Andamento"<br>**Atualização:** "Enviada em 10s"<br>**ETA:** "Congelado após desvio" | O sistema emite um aviso visual indicando que a previsão de chegada está em recálculo devido a alterações no percurso. (ETA não atualizado após alterações de rota) |
| **Caso 9** | 1, 4, 7, 12 | **GPS do dispositivo:** "Ativo"<br>**Status da Viagem:** "Em Andamento"<br>**Atualização:** "Enviada em 10s"<br>**ETA:** "Erro de cálculo" | A localização da embarcação é atualizada no mapa, mas o campo de tempo estimado de chegada exibe "Indisponível". (ETA inválido) |
---

# Modo de Alto Contraste

**US06**: Enquanto viajante com baixa visão, desejo ativar um modo de alto contraste na interface, para que eu possa distinguir claramente os textos, botões e elementos visuais, navegando pelo aplicativo com maior conforto e autonomia.

**Critérios de Aceitação:**

- **CR01**: O sistema deve disponibilizar uma opção de fácil acesso (chave de ativação/desativação) para o "Modo de Alto Contraste" nas configurações.
- **CR02**: Ao ativar o recurso, o sistema deve aplicar instantaneamente o tema de alto contraste em absolutamente todas as telas e componentes do aplicativo.
- **CR03**: O tema de alto contraste deve garantir a legibilidade destacando textos, contornos de botões, formulários e ícones contra o fundo.
- **CR04**: O sistema deve salvar a preferência do usuário (persistência de configuração), garantindo que o modo de alto contraste permaneça ativado automaticamente sempre que ele retornar ao aplicativo em sessões futures.
- **CR05**: A ativação do modo de alto contraste não deve ocultar, desabilitar ou sobrepor nenhuma funcionalidade ou informação existente no modo padrão.

**Regras de Negócio:**

- **RN01**: O esquema de cores projetado para o modo de alto contraste deve obrigatoriamente atender à razão mínima de contraste exigida pelas diretrizes internacionais de acessibilidade.
- **RN02**: A configuração de tema visual é uma preferência individual e deve ser armazenada em banco de dados vinculada ao perfil do usuário logado (ou localmente no dispositivo para usuários não logados).
- **RN03**: A alteração para o tema de alto contraste é uma modificação estritamente visual e de acessibilidade; sob nenhuma circunstância ela deve interferir nas regras de negócio, fluxos de compra ou funcionamento técnico do sistema.

## Classes de Equivalência

| Condição de Entrada                | Classe Válida                                             | Classe Inválida                                  | Classe Inválida       |
| :----------------------------------: | :---------------------------------------------------------: | :------------------------------------------------: | :---------------------: |
| Ativação do modo de alto contraste | Modo ativado corretamente (1)                             | Modo não ativado após solicitação do usuário (2) |                       |
| Aplicação do tema                  | Tema aplicado em todas as telas e componentes (3)         | Tema aplicado parcialmente (4)                   | Tema não aplicado (5) |
| Contraste visual                   | Contraste atende às diretrizes de acessibilidade (6)      | Contraste abaixo do mínimo exigido (7)           |                       |
| Persistência da configuração       | Preferência salva para sessões futuras (8)                | Preferência não salva (9)                        |                       |
| Funcionalidades do sistema         | Funcionalidades permanecem disponíveis após ativação (10) | Funcionalidades ocultadas ou desabilitadas (11)  |                       |

## Casos de Teste

| Casos de Teste | Classes de <br> Equivalência | <div align="center">Entradas</div> | <div align="center">Resultado Esperado</div> |
| :---: | :---: | :--- | :--- |
| **Caso 1** | 1, 3, 6, 8, 10 | **Ativação:** "Solicitada pelo usuário"<br>**Navegação:** "Telas do aplicativo"<br>**Verificação:** "Taxa de contraste"<br>**Sessão:** "App reiniciado"<br>**Uso:** "Busca e compra ativas" | O sistema aplica o tema escuro/alto contraste em todo o app, preservando botões e salvando a preferência do usuário. (Modo ativado corretamente) |
| **Caso 2** | 2, 3, 6, 8, 10 | **Ativação:** "Solicitada pelo usuário"<br>**Navegação:** "Telas do aplicativo"<br>**Verificação:** "Taxa de contraste"<br>**Sessão:** "App reiniciado"<br>**Uso:** "Busca e compra ativas" | O aplicativo falha em processar a mudança e a interface permanece no tema padrão claro. (Modo não ativado após solicitação do usuário) |
| **Caso 3** | 1, 4, 6, 8, 10 | **Ativação:** "Solicitada pelo usuário"<br>**Navegação:** "Telas do aplicativo"<br>**Verificação:** "Taxa de contraste"<br>**Sessão:** "App reiniciado"<br>**Uso:** "Busca e compra ativas" | O sistema ativa o modo, mas algumas telas (como o perfil da embarcação) continuam com o tema padrão. (Tema aplicado parcialmente) |
| **Caso 4** | 1, 5, 6, 8, 10 | **Ativação:** "Solicitada pelo usuário"<br>**Navegação:** "Telas do aplicativo"<br>**Verificação:** "Taxa de contraste"<br>**Sessão:** "App reiniciado"<br>**Uso:** "Busca e compra ativas" | O usuário ativa a funcionalidade, o sistema processa a ação, mas a interface não sofre nenhuma alteração visual. (Tema não aplicado) |
| **Caso 5** | 1, 3, 7, 8, 10 | **Ativação:** "Solicitada pelo usuário"<br>**Navegação:** "Telas do aplicativo"<br>**Verificação:** "Taxa de contraste"<br>**Sessão:** "App reiniciado"<br>**Uso:** "Busca e compra ativas" | O tema é aplicado, mas a cor das fontes sobre os botões não atende às regras de acessibilidade, dificultando a leitura. (Contraste abaixo do mínimo exigido) |
| **Caso 6** | 1, 3, 6, 9, 10 | **Ativação:** "Solicitada pelo usuário"<br>**Navegação:** "Telas do aplicativo"<br>**Verificação:** "Taxa de contraste"<br>**Sessão:** "App reiniciado"<br>**Uso:** "Busca e compra ativas" | O modo é ativado com sucesso e funciona durante o uso, mas após reiniciar o aplicativo, a interface volta ao tema padrão claro. (Preferência não salva) |
| **Caso 7** | 1, 3, 6, 8, 11 | **Ativação:** "Solicitada pelo usuário"<br>**Navegação:** "Telas do aplicativo"<br>**Verificação:** "Taxa de contraste"<br>**Sessão:** "App reiniciado"<br>**Uso:** "Busca e compra ativas" | O modo é ativado com sucesso, porém o botão de "Confirmar Pagamento" desaparece ou se torna inclicável na interface. (Funcionalidades ocultadas ou desabilitadas) |

---

# Formas de Pagamento

**US07**: Enquanto viajante, desejo escolher entre diferentes formas de pagamento no momento de finalizar a compra da minha passagem fluvial, para que eu possa utilizar a opção mais conveniente para o meu planejamento financeiro e garantir minha reserva na embarcação.

**Critérios de Aceitação:**

- **CR01**: O sistema deve apresentar claramente as opções de pagamento habilitadas para a viagem, como: "Cartão de Crédito", "PIX" e "Boleto Bancário".
- **CR02**: A opção "Boleto Bancário" só deve aparecer visível e selecionável se a data de embarque da viagem respeitar o prazo mínimo de antecedência configurado nas regras de negócio. Caso contrário, a opção deve ser ocultada ou aparecer desabilitada com um aviso informando o motivo (ex: "Indisponível: compras via boleto exigem X dias de antecedência para compensação").
- **CR03**: Ao selecionar "Cartão de Crédito", o sistema deve exibir um alerta claro sobre o acréscimo da taxa de 2,0% antes que o usuário clique em "Pagar".
- **CR04**: Ao selecionar "Boleto Bancário" e finalizar a reserva, o sistema deve exibir uma tela de instruções com o código de barras copiável e um botão bem visível para "Baixar Boleto em PDF".
- **CR05**: Durante o processamento do pagamento, o sistema deve exibir um indicador visual de carregamento e bloquear o botão de confirmação para evitar cobranças em duplicidade.
- **CR06**: Se o pagamento falhar (ex: saldo insuficiente, erro de comunicação), o sistema deve notificar o usuário com uma mensagem clara sobre o motivo e permitir a tentativa com outro método.
- **CR07**: O sistema deve disponibilizar um botão "Voltar" ou "Cancelar" para que o usuário possa desistir do pagamento e retornar ao resumo da reserva sem perder o assento (desde que dentro do tempo limite).
- **CR08**: Após a confirmação do pagamento, o usuário deve ser redirecionado para uma tela de "Sucesso" contendo o número do voucher da viagem e um botão para baixar o bilhete em formato PDF.
- **CR09**: Para **PIX/Crédito**, o sistema deve exibir uma tela de "Sucesso" imediato contendo o número do voucher e o botão para baixar o bilhete em formato PDF.
- **CR10**: Para **Boleto**, o sistema deve exibir uma tela de "Reserva Aguardando Pagamento", informando a data limite para o vencimento do boleto e avisando que o bilhete definitivo só será liberado após a compensação bancária.
- **CR11**: A opção "Boleto Bancário" deve ficar indisponível para seleção caso a viagem possua menos de 72 horas úteis de antecedência para o embarque.

**Regras de Negócio:**

- **RN01**: Compras de passagens realizadas na modalidade de crédito possuem um acréscimo de 2,0% sobre o valor total da tarifa.
- **RN02**: Transações via PIX ("QR Code" ou "Copia e Cola") possuem um tempo de validade estrito de 10 minutos; após esse período sem confirmação, a intenção de compra é expirada.
- **RN03**: O pagamento via Boleto Bancário só será permitido para viagens cujo embarque esteja previsto para, no mínimo, 72 horas úteis (3 dias úteis) de antecedência a partir do momento da emissão.
- **RN04**: O prazo de vencimento do boleto bancário será de 24 horas úteis após a sua geração. Caso o pagamento não seja detectado pela API de conciliação bancária dentro deste prazo, o assento reservado deve ser devolvido automaticamente ao inventário da embarcação e a reserva cancelada.
- **RN05**: O bilhete/voucher definitivo em PDF só será gerado e enviado para o e-mail do usuário após o recebimento do arquivo de retorno bancário (ou webhook da API de pagamentos) confirmando o status de "Compensado".
- **RN06**: A plataforma deve sempre operar oferecendo, no mínimo, duas modalidades distintas de pagamento para garantir a conversão da venda.
- **RN07**: Os boletos gerados pela plataforma possuem prazo estrito de vencimento de 24 horas úteis; a ausência de compensação bancária neste período resulta no cancelamento automático da reserva e na liberação do assento de volta ao inventário.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Forma de pagamento | PIX, Cartão de Crédito ou Boleto selecionado corretamente (1) | Forma de pagamento não selecionada (2) | Forma de pagamento inválida (3) |
| Antecedência para boleto | Viagem com pelo menos 72 horas úteis de antecedência (4) | Viagem com menos de 72 horas úteis de antecedência (5) | |
| Pagamento PIX | Pagamento realizado dentro de 10 minutos (6) | Pagamento não realizado dentro do prazo (7) | |
| Status do pagamento | Pagamento aprovado ou compensado (8) | Pagamento recusado (9) | Falha na comunicação com a operadora (10) |
| Emissão do bilhete | Bilhete gerado após confirmação do pagamento (11) | Bilhete não gerado após confirmação (12) | Bilhete gerado sem pagamento confirmado (13) |

## Casos de Teste 

| Casos de Teste | Classes de <br> Equivalência | <div align="center">Entradas</div> | <div align="center">Resultado Esperado</div> |
| :---: | :---: | :--- | :--- |
| **Caso 1** | 1, 4, 6, 8, 11 | **Viagem:** "Manaus a Parintins (Daqui a 5 dias)"<br>**Forma de Pagamento:** "Cartão de Crédito"<br>**Tempo de Pagamento:** "Imediato"<br>**Retorno da Operadora:** "Aprovado" | O sistema processa o pagamento com sucesso e disponibiliza o bilhete ao utilizador. (Bilhete gerado após confirmação do pagamento) |
| **Caso 2** | 2, 4, 6, 8, 11 | **Viagem:** "Manaus a Parintins (Daqui a 5 dias)"<br>**Forma de Pagamento:** *[Nenhuma]*<br>**Tempo de Pagamento:** "Imediato"<br>**Retorno da Operadora:** "Aprovado" | O sistema impede o avanço para a confirmação e exige a escolha de um método. (Forma de pagamento não selecionada) |
| **Caso 3** | 3, 4, 6, 8, 11 | **Viagem:** "Manaus a Parintins (Daqui a 5 dias)"<br>**Forma de Pagamento:** "Cheque" *(Não suportado)*<br>**Tempo de Pagamento:** "Imediato"<br>**Retorno da Operadora:** "N/A" | A compra não avança. O sistema informa que o método escolhido não é aceite pela plataforma. (Forma de pagamento inválida) |
| **Caso 4** | 1, 5, 6, 8, 11 | **Viagem:** "Manaus a Parintins (Para amanhã - 24h)"<br>**Forma de Pagamento:** "Boleto"<br>**Tempo de Pagamento:** "Imediato"<br>**Retorno da Operadora:** "Aprovado" | O sistema bloqueia a emissão do boleto e sugere outra forma de pagamento, devido ao prazo de compensação. (Viagem com menos de 72 horas úteis de antecedência) |
| **Caso 5** | 1, 4, 7, 8, 11 | **Viagem:** "Manaus a Parintins (Daqui a 5 dias)"<br>**Forma de Pagamento:** "PIX"<br>**Tempo de Pagamento:** "15 minutos"<br>**Retorno da Operadora:** "Aprovado" | O sistema cancela a reserva temporária e informa que o tempo limite expirou. (Pagamento não realizado dentro do prazo) |
| **Caso 6** | 1, 4, 6, 9, 11 | **Viagem:** "Manaus a Parintins (Daqui a 5 dias)"<br>**Forma de Pagamento:** "Cartão de Crédito"<br>**Tempo de Pagamento:** "Imediato"<br>**Retorno da Operadora:** "Saldo Insuficiente" | A compra é interrompida e o ecrã notifica que a transação não foi autorizada. (Pagamento recusado) |
| **Caso 7** | 1, 4, 6, 10, 11 | **Viagem:** "Manaus a Parintins (Daqui a 5 dias)"<br>**Forma de Pagamento:** "Cartão de Crédito"<br>**Tempo de Pagamento:** "Imediato"<br>**Retorno da Operadora:** "Sem resposta / Timeout" | O sistema exibe um erro técnico de conexão e pede para o utilizador tentar novamente. (Falha na comunicação com a operadora) |
| **Caso 8** | 1, 4, 6, 8, 12 | **Viagem:** "Manaus a Parintins (Daqui a 5 dias)"<br>**Forma de Pagamento:** "PIX"<br>**Tempo de Pagamento:** "Imediato"<br>**Retorno da Operadora:** "Aprovado" | O valor é descontado e o pagamento consta como confirmado, mas ocorre um erro interno e a interface não emite o bilhete. (Bilhete não gerado após confirmação) |
| **Caso 9** | 1, 4, 6, 8, 13 | **Viagem:** "Manaus a Parintins (Daqui a 5 dias)"<br>**Forma de Pagamento:** "PIX"<br>**Tempo de Pagamento:** "Imediato"<br>**Retorno da Operadora:** "Aprovado" | O sistema emite o bilhete prematuramente, antes mesmo de realizar a etapa de validação da confirmação do pagamento, quebrando o fluxo de segurança. (Bilhete gerado sem pagamento confirmado) |

---

# Acessibilidade para Deficiência Visual

**US08**: Enquanto viajante com deficiência visual (cegueira ou baixa visão), desejo que a interface do aplicativo suporte plenamente tecnologias assistivas e padrões de acessibilidade, para que eu possa navegar, buscar viagens e comprar minhas passagens de forma autônoma, intuitiva e segura.

**Critérios de Aceitação:**

- **CR01**: O sistema deve ser totalmente compatível com leitores de tela nativos dos sistemas operacionais (como TalkBack e VoiceOver), lendo corretamente todos os elementos e fluxos da tela.
- **CR02**: O sistema deve permitir a navegação completa e a execução de todas as tarefas (como selecionar origem/destino e preencher formulários) utilizando apenas comandos de teclado ou gestos de varredura direcional.
- **CR03**: Todas as imagens, ícones gráficos e elementos não textuais informativos devem possuir descrições alternativas claras (alt text) programadas no código.
- **CR04**: A interface deve garantir uma relação de contraste adequada entre os textos e as cores de fundo, garantindo legibilidade para usuários com baixa visão.
- **CR05**: O layout do aplicativo deve suportar o redimensionamento do texto nas configurações do sistema operacional sem quebrar a interface, sobrepor botões ou ocultar informações vitais da viagem.
- **CR06**: Os formulários e botões interativos devem possuir rótulos (labels) descritivos ocultos ou visíveis, indicando claramente sua finalidade e estado atual (ex: "botão confirmar pagamento, desativado").

**Regras de Negócio:**

- **RN01**: A estrutura semântica e o desenvolvimento da interface devem obrigatoriamente aderir às diretrizes internacionais de acessibilidade WCAG (Web Content Accessibility Guidelines).
- **RN02**: Nenhuma funcionalidade do sistema pode depender exclusivamente do uso de mouse ou de toques de alta precisão na tela, exigindo sempre uma alternativa de navegação sequencial.
- **RN03**: Qualquer informação ou feedback transmitido visualmente (como o uso da cor vermelha para indicar um erro no formulário) deve ser obrigatoriamente acompanhado de um aviso textual ou equivalente interpretável pelo leitor de tela.
- **RN04**: O sistema deve manter um padrão lógico e consistente na ordem de tabulação e foco dos elementos em todas as telas, respeitando o fluxo natural de leitura.
- **RN05**: Todos os dados de identificação do passageiro exibidos na cédula de embarque offline devem possuir rótulos de acessibilidade descritivos para leitura linear, impedindo que o leitor de tela pule campos cruciais como o número do CPF ou o assento durante a conferência no porto.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Compatibilidade com leitor de tela | Elementos lidos corretamente pelo leitor de tela (1) | Leitura parcial dos elementos (2) | Elementos não interpretados pelo leitor de tela (3) |
| Navegação assistiva | Navegação completa por teclado ou gestos (4) | Navegação parcialmente acessível (5) | Navegação impossível sem toque direto (6) |
| Elementos não textuais | Imagens e ícones com descrição alternativa (7) | Descrições incompletas (8) | Ausência de descrição alternativa (9) |
| Redimensionamento de texto | Interface permanece funcional após ampliação do texto (10) | Interface parcialmente comprometida (11) | Interface quebrada após ampliação (12) |
| Informações visuais | Informação visual acompanhada de texto acessível (13) | Informação disponível apenas por cor ou elemento visual (14) | |

## Casos de Teste 

| Casos de Teste | Classes de <br> Equivalência | <div align="center">Entradas</div> | <div align="center">Resultado Esperado</div> |
| :---: | :---: | :--- | :--- |
| **Caso 1** | 1, 4, 7, 10, 13 | **Leitura:** "Compatível"<br>**Navegação:** "Por gestos"<br>**Imagens:** "Descritas"<br>**Texto:** "Ampliado"<br>**Cores:** "Com texto de apoio" | O utilizador consegue navegar, ouvir todos os elementos, compreender as imagens e concluir a compra com a interface funcional mesmo com o texto ampliado. (Acessibilidade plena ativada) |
| **Caso 2** | 2, 4, 7, 10, 13 | **Leitura:** "Parcial"<br>**Navegação:** "Por gestos"<br>**Imagens:** "Descritas"<br>**Texto:** "Ampliado"<br>**Cores:** "Com texto de apoio" | O sistema omite a leitura de algumas partes cruciais da interface, prejudicando o entendimento do utilizador. (Leitura parcial dos elementos) |
| **Caso 3** | 3, 4, 7, 10, 13 | **Leitura:** "Incompatível"<br>**Navegação:** "Por gestos"<br>**Imagens:** "Descritas"<br>**Texto:** "Ampliado"<br>**Cores:** "Com texto de apoio" | O leitor de tela fica mudo ao interagir com a interface, impedindo qualquer retorno sonoro. (Elementos não interpretados pelo leitor de tela) |
| **Caso 4** | 1, 5, 7, 10, 13 | **Leitura:** "Compatível"<br>**Navegação:** "Parcial"<br>**Imagens:** "Descritas"<br>**Texto:** "Ampliado"<br>**Cores:** "Com texto de apoio" | O utilizador consegue navegar por gestos em parte do ecrã, mas o foco não alcança menus pop-up ou rodapés. (Navegação parcialmente acessível) |
| **Caso 5** | 1, 6, 7, 10, 13 | **Leitura:** "Compatível"<br>**Navegação:** "Impossível"<br>**Imagens:** "Descritas"<br>**Texto:** "Ampliado"<br>**Cores:** "Com texto de apoio" | A navegação assistiva não funciona, obrigando o utilizador a tocar diretamente na posição visual dos componentes. (Navegação impossível sem toque direto) |
| **Caso 6** | 1, 4, 8, 10, 13 | **Leitura:** "Compatível"<br>**Navegação:** "Por gestos"<br>**Imagens:** "Incompletas"<br>**Texto:** "Ampliado"<br>**Cores:** "Com texto de apoio" | O leitor dita uma descrição vaga para a imagem da embarcação, sem detalhar o que ela representa. (Descrições incompletas) |
| **Caso 7** | 1, 4, 9, 10, 13 | **Leitura:** "Compatível"<br>**Navegação:** "Por gestos"<br>**Imagens:** "Sem descrição"<br>**Texto:** "Ampliado"<br>**Cores:** "Com texto de apoio" | O sistema foca nos ícones, mas o leitor de tela dita apenas o nome do arquivo da imagem ou "botão", não informando a ação. (Ausência de descrição alternativa) |
| **Caso 8** | 1, 4, 7, 11, 13 | **Leitura:** "Compatível"<br>**Navegação:** "Por gestos"<br>**Imagens:** "Descritas"<br>**Texto:** "Ampliado"<br>**Cores:** "Com texto de apoio" | Ao aumentar o tamanho da fonte, alguns botões de "Comprar" sobrepõem-se a outros elementos, dificultando o acesso. (Interface parcialmente comprometida) |
| **Caso 9** | 1, 4, 7, 12, 13 | **Leitura:** "Compatível"<br>**Navegação:** "Por gestos"<br>**Imagens:** "Descritas"<br>**Texto:** "Ampliado"<br>**Cores:** "Com texto de apoio" | O redimensionamento do texto desconfigura totalmente o ecrã, empurrando os botões de ação para fora da área visível. (Interface quebrada após ampliação) |
| **Caso 10** | 1, 4, 7, 10, 14 | **Leitura:** "Compatível"<br>**Navegação:** "Por gestos"<br>**Imagens:** "Descritas"<br>**Texto:** "Ampliado"<br>**Cores:** "Sem texto de apoio" | O sistema indica um erro mudando apenas a cor da borda de um campo para vermelho, sem gerar nenhum alerta em texto para o leitor de tela. (Informação disponível apenas por cor ou elemento visual) |

---

# Cadastro de Viagem

**US09**: Enquanto proprietário, desejo cadastrar os detalhes de uma nova viagem fluvial, incluindo a embarcação utilizada, rota, data, horários e frequência, para que eu possa disponibilizar a venda de passagens aos viajantes e gerenciar minha oferta de transporte na plataforma.

**Critérios de Aceitação:**

- **CR01**: O sistema deve permitir a seleção de uma embarcação da frota do proprietário, listando apenas aquelas que já foram validadas pela plataforma.
- **CR02**: O sistema deve oferecer campos obrigatórios para definir a origem, o destino e o horário de saída da viagem.
- **CR03**: O sistema deve permitir que o proprietário marque a viagem como "Única" ou "Recorrente". Caso seja recorrente, deve permitir a seleção dos dias da semana em que a viagem se repete.
- **CR04**: O sistema deve validar o horário de saída e impedir o cadastro caso o intervalo seja inferior a 12 horas de antecedência, exibindo uma mensagem de orientação ao usuário.
- **CR05**: Antes de finalizar a publicação, o sistema deve exibir uma tela de resumo com todos os dados (embarcação, rota, datas, horários e preço) para revisão.
- **CR06**: O sistema deve exibir uma caixa de diálogo de confirmação solicitando que o usuário valide as informações antes da conclusão definitiva.
- **CR07**: Após a confirmação, o sistema deve exibir um indicador de processamento e, em seguida, uma mensagem de sucesso informando que a viagem já está visível para os viajantes.

**Regras de Negócio:**

- **RN01**: O sistema deve aplicar uma trava de integridade que impeça a publicação de uma nova rota caso o proprietário não selecione uma embarcação cadastrada que possua o status de 'Validada' pela moderação da plataforma.
- **RN02**: O proprietário está autorizado a cadastrar novas viagens apenas se possuir pelo menos uma embarcação com status "Validada" e disponível em seu perfil.
- **RN03**: O sistema deve impedir que o limite de assentos disponíveis informado para a viagem seja superior à capacidade total cadastrada para a embarcação selecionada.
- **RN04**: Para fins de planejamento logístico e processamento de dados, o sistema impõe uma restrição de tempo onde uma viagem só pode ser registrada com um prazo mínimo de 12 horas de antecedência em relação ao horário previsto para o embarque.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Embarcação selecionada | Embarcação validada selecionada (1) | Embarcação não selecionada (2) | Embarcação não validada (3) |
| Dados obrigatórios da viagem | Origem, destino e horário preenchidos corretamente (4) | Algum campo obrigatório não preenchido (5) | Dados inválidos (6) |
| Tipo de viagem | Viagem definida como única ou recorrente corretamente (7) | Tipo de viagem não definido (8) | Viagem recorrente sem dias da semana definidos (9) |
| Antecedência da viagem | Horário cadastrado com no mínimo 12 horas de antecedência (10) | Horário com menos de 12 horas de antecedência (11) | |
| Quantidade de assentos | Quantidade de assentos menor ou igual à capacidade da embarcação (12) | Quantidade de assentos superior à capacidade da embarcação (13) | |
| Disponibilidade de embarcação | Proprietário possui pelo menos uma embarcação validada disponível (14) | Proprietário sem embarcações validadas (15) | |

## Casos de teste

| Casos de teste | Classes de equivalência | Entradas | Resultados esperados |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 4, 7, 10, 12, 14 | **Embarcação**: "Validada"<br>**Origem**: "Manaus"<br>**Destino**: "Parintins"<br>**Horário**: "20:00 (antecedência de 24h)"<br>**Tipo**: "Única"<br>**Assentos**: 50 (Capacidade: 50) | O sistema processa o cadastro com sucesso e disponibiliza a viagem para venda. |
| Caso 2 | 2, 4, 7, 10, 12, 14 | **Embarcação**: *[Em branco]*<br>**Origem**: "Manaus"<br>**Destino**: "Parintins"<br>**Horário**: "20:00"<br>**Tipo**: "Única"<br>**Assentos**: 50 | Cadastro rejeitado. O sistema exibe mensagem de erro na seleção do veículo. (Embarcação não selecionada) |
| Caso 3 | 3, 4, 7, 10, 12, 14 | **Embarcação**: "Em Análise"<br>**Origem**: "Manaus"<br>**Destino**: "Parintins"<br>**Horário**: "20:00"<br>**Tipo**: "Única"<br>**Assentos**: 50 | Cadastro rejeitado. O sistema impede a vinculação de barcos não homologados. (Embarcação não validada) |
| Caso 4 | 1, 5, 7, 10, 12, 14 | **Embarcação**: "Validada"<br>**Origem**: "Manaus"<br>**Destino**: *[Em branco]*<br>**Horário**: *[Em branco]*<br>**Tipo**: "Única"<br>**Assentos**: 50 | Cadastro rejeitado. Os campos obrigatórios vazios são destacados na interface. (Algum campo obrigatório não preenchido) |
| Caso 5 | 1, 6, 7, 10, 12, 14 | **Embarcação**: "Validada"<br>**Origem**: "@#$%"<br>**Destino**: "1234"<br>**Horário**: "20:00"<br>**Tipo**: "Única"<br>**Assentos**: 50 | Cadastro rejeitado. O sistema aciona o validador de caracteres de texto. (Dados inválidos) |
| Caso 6 | 1, 4, 8, 10, 12, 14 | **Embarcação**: "Validada"<br>**Origem**: "Manaus"<br>**Destino**: "Parintins"<br>**Horário**: "20:00"<br>**Tipo**: *[Não selecionado]*<br>**Assentos**: 50 | Cadastro rejeitado. O sistema exige a definição da recorrência da rota. (Tipo de viagem não definido) |
| Caso 7 | 1, 4, 9, 10, 12, 14 | **Embarcação**: "Validada"<br>**Origem**: "Manaus"<br>**Destino**: "Parintins"<br>**Horário**: "20:00"<br>**Tipo**: "Recorrente"<br>**Dias da semana**: *[Nenhum selecionado]*<br>**Assentos**: 50 | Cadastro rejeitado. O sistema bloqueia a criação de agenda sem dias definidos. (Viagem recorrente sem dias da semana definidos) |
| Caso 8 | 1, 4, 7, 11, 12, 14 | **Embarcação**: "Validada"<br>**Origem**: "Manaus"<br>**Destino**: "Parintins"<br>**Horário**: "18:30 (daqui a 2 horas)"<br>**Tipo**: "Única"<br>**Assentos**: 50 | Cadastro rejeitado. O sistema barra a operação devido ao limite de antecedência mínima. (Horário com menos de 12 horas de antecedência) |
| Caso 9 | 1, 4, 7, 10, 13, 14 | **Embarcação**: "Validada" (Capacidade: 50)<br>**Origem**: "Manaus"<br>**Destino**: "Parintins"<br>**Horário**: "20:00"<br>**Tipo**: "Única"<br>**Assentos**: 65 | Cadastro rejeitado. O sistema bloqueia a venda de assentos acima do limite físico do barco. (Quantidade de assentos superior à capacidade da embarcação) |
| Caso 10 | 1, 4, 7, 10, 12, 15 | **Proprietário**: *[Sem embarcações validadas]*<br>**Ação**: Tentar abrir tela de criação de viagem | Acesso bloqueado. O sistema redireciona o usuário para a inclusão de frotas. (Proprietário sem embarcações validadas) |

---

# Perfil da Embarcação
<div align="justify">

  **US10**: Enquanto viajante, desejo acessar uma página de perfil detalhada de cada embarcação (contendo fotos, especificações técnicas e comodidades), para que eu possa comparar diferentes opções de transporte e escolher aquela que melhor atende às minhas preferências de conforto e segurança para a viagem.

  **Critérios de Aceitação:**

- **CR01**: O sistema deve exibir uma página dedicada para a embarcação com seu nome, número de registro oficial, capacidade máxima e velocidade média.
- **CR02**: O sistema deve apresentar uma galeria de fotos navegável (carrossel ou grade) com as imagens cadastradas pelo proprietário.
- **CR03**: O sistema deve listar de forma clara todas as comodidades oferecidas na embarcação (ex: ar-condicionado, lanchonete, espaço para redes).
- **CR04**: O sistema deve fornecer um botão de "Voltar" claramente visível para que o viajante possa retornar facilmente à lista de resultados de busca sem perder os filtros aplicados.
- **CR05**: Na página de perfil da embarcação, o sistema deve exibir um botão de atalho ou seção mostrando as "Próximas Viagens" disponíveis para aquele barco específico.

**Regras de Negócio:**

- **RN01**: Apenas embarcações que possuem o status de cadastro "Validada" (e não "Em Análise") podem ter seus perfis exibidos publicamente para os viajantes.
- **RN02**: O ambiente de visualização de perfis para o usuário com perfil de "Viajante" deve ser estritamente de leitura (read-only), sem qualquer possibilidade de alteração das informações exibidas.
- **RN03**: As informações apresentadas no perfil público devem ser um reflexo exato dos dados aprovados no banco de dados durante o cadastro feito pelo proprietário.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Status da embarcação | Embarcação com status "Validada" (1) | Embarcação com status "Em Análise" (2) | Embarcação inexistente ou removida (3) |
| Dados do perfil | Dados aprovados e consistentes com o cadastro (4) | Dados incompletos no perfil (5) | Dados divergentes do cadastro aprovado (6) |
| Permissão de acesso | Usuário possui acesso apenas para visualização (7) | Usuário consegue alterar informações do perfil (8) | |

## Casos de Teste

| Casos de teste | Classes de equivalência | Entradas | Resultados esperados |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 4, 7 | **Status da embarcação**: "Validada"<br>**Dados do perfil**: Fotos e especificações íntegras<br>**Tipo de Usuário**: Viajante | O perfil carrega perfeitamente na interface com dados e mídias consistentes para leitura. |
| Caso 2 | 2, 4, 7 | **Status da embarcação**: "Em Análise"<br>**Ação**: Viajante força acesso via URL direta | Acesso negado. A interface exibe aviso de que a embarcação está indisponível para o público. (Embarcação com status "Em Análise") |
| Caso 3 | 3, 4, 7 | **Status da embarcação**: "Inexistente" (Removida)<br>**Ação**: Viajante tenta abrir o link | Erro 404. O sistema informa que o recurso não foi encontrado na base de dados. (Embarcação nonexistent ou removida) |
| Caso 4 | 1, 5, 7 | **Status da embarcação**: "Validada"<br>**Dados do perfil**: *[Capacidade em branco / Sem fotos]* | O sistema intercepta o carregamento para evitar quebras visuais de tela. (Dados incompletos no perfil) |
| Caso 5 | 1, 6, 7 | **Status da embarcação**: "Validada"<br>**Dados do perfil**: Fotos e especificações adulteradas | O sistema indica erro de integridade de dados e não renderiza a página. (Dados divergentes do cadastro aprovado) |
| Caso 6 | 1, 4, 8 | **Status da embarcação**: "Validada"<br>**Tipo de Usuário**: Viajante<br>**Ação**: Forçar requisição de alteração de dados | Ação bloqueada pelo back-end por falta de privilégios de escrita. (Usuário consegue alterar informações do perfil) |

---

# Dashboard de Faturamento
<div align="justify">

  **US11**: Enquanto proprietário, desejo acessar um painel de controle financeiro (Dashboard de Faturamento) com o cálculo automatizado do valor bruto e do valor líquido a receber das minhas viagens, para que eu possa gerenciar a receita do meu negócio com transparência e acompanhar o impacto de taxas e descontos aplicados.

**Critérios de Aceitação**

- **CR01**: O sistema deve disponibilizar uma tela dedicada de "Dashboard de Faturamento" dentro do perfil do proprietário.

- **CR02**: O painel deve exibir de forma clara e destacada três indicadores principais: Valor Bruto Total, Total de Deduções/Taxas e Valor Líquido Acumulado.

- **CR03**: O sistema deve listar o valor líquido individual gerado por cada viagem cadastrada e realizada, permitindo a filtragem por período (dia, semana, mês).

- **CR04**: O painel deve discriminar visualmente a origem dos valores, separando o faturamento por modalidade de pagamento (Pix, Cartão de Crédito e Boleto Bancário).

- **CR05**: Ao detalhar uma viagem específica, o proprietário deve visualizar o impacto das taxas administrativas cobradas dos clientes (como o acréscimo de 2,0% do crédito) e as taxas retidas pela plataforma/gateway de pagamento.

- **CR06**: Quando o proprietário editar os valores base ou conceder descontos em uma viagem existente, o sistema deve recalcular automaticamente o valor líquido daquela rota e atualizar o total acumulado do painel em tempo real.

**Regras de Negócio**

- **RN01**: O processamento financeiro automatizado do sistema deve seguir estritamente as equações de integridade:

$$Valor\ Bruto = Tarifa\ Base \times Quantidade\ de\ Passagens\ Vendidas$$$$Valor\ Líquido = Valor\ Bruto - Taxas\ de\ Intermediação - Descontos$$

- **RN02**: O acréscimo de 2,0% cobrado nas transações de cartão de crédito deve entrar no sistema como um valor acessório repassado e ser discriminado separadamente, não podendo ser contabilizado como prejuízo ou dedução do valor bruto original devido ao proprietário.
- **RN03**: A aplicação de taxas e descontos não é obrigatória para a criação de uma viagem; caso os campos de parametrização operacional fiquem vazios, o sistema deve assumir o valor padrão de "0" para os cálculos.
- **RN03**: O valor líquido calculado e exibido para uma viagem ou para o total do painel sob nenhuma circunstância pode resultar em um valor negativo; caso as deduções superem o bruto (erro de configuração externa), o sistema deve bloquear a exibição e gerar um log de auditoria.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Período de consulta | Dia, semana ou mês selecionado corretamente (1) | Período não informado (2) | Período inválido (3) |
| Dados financeiros da viagem | Tarifa e quantidade de passagens válidas para cálculo (4) | Dados financeiros incompletos (5) | Dados financeiros inválidos (6) |
| Taxas e descontos | Taxas e descontos válidos ou assumidos como zero (7) | Taxas inválidas (8) | Descontos inválidos (9) |
| Modalidade de pagamento | Receita identificada por PIX, Crédito ou Boleto (10) | Modalidade não identificada (11) | |
| Valor líquido calculado | Valor líquido maior ou igual a zero (12) | Valor líquido negativo (13) | |
| Recalculo financeiro | Alterações atualizam os valores corretamente (14) | Valores não atualizados após alteração (15) | |

## Casos de Teste

| Casos de teste | Classes de equivalência | Entradas | Resultados esperados |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 4, 7, 10, 12, 14 | **Período**: "Mês atual"<br>**Dados financeiros**: Tarifas válidas<br>**Taxas/Descontos**: Válidos (deduções normais)<br>**Modalidade**: PIX / Crédito | Os gráficos consolidam os valores brutos e líquidos com a subtração exata das taxas operacionais. |
| Caso 2 | 2, 4, 7, 10, 12, 14 | **Período**: *[Em branco]*<br>**Ação**: Tentar carregar Dashboard | O sistema impede a plotagem de dados e solicita a definição de um intervalo de busca. (Período não informado) |
| Caso 3 | 3, 4, 7, 10, 12, 14 | **Período**: Data Inicial "30/12/2026" / Data Final "01/12/2026" | Erro de validação. O sistema acusa inconsistência lógica no intervalo cronológico. (Período inválido) |
| Caso 4 | 1, 5, 7, 10, 12, 14 | **Período**: "Mês atual"<br>**Dados financeiros**: Viagem sem registro de tarifa base | O cálculo é pausado e uma notificação de erro estrutural de faturamento é disparada. (Dados financeiros incompletos) |
| Caso 5 | 1, 6, 7, 10, 12, 14 | **Período**: "Mês atual"<br>**Dados financeiros**: Valores corrompidos em formato string | O sistema aborta a operação para evitar a generation de somas matemáticas incorretas. (Dados financeiros inválidos) |
| Caso 6 | 1, 4, 8, 10, 12, 14 | **Período**: "Mês atual"<br>**Taxas**: Cadastrada com valor negativo (-1%) | O cálculo financeiro rejeita a taxa incoerente por questões de segurança de auditoria. (Taxas inválidas) |
| Caso 7 | 1, 4, 9, 10, 12, 14 | **Período**: "Mês atual"<br>**Descontos**: Valor superior ao preço do bilhete | O sistema barra a consolidação de cupons abusivos que zeram ou negativam custos. (Descontos inválidos) |
| Caso 8 | 1, 4, 7, 11, 12, 14 | **Modalidade**: Método desconhecido vindo do gateway | O painel isola a transação em uma categoria de auditoria pendente. (Modalidade não identificada) |
| Caso 9 | 1, 4, 7, 10, 13, 14 | **Taxas aplicadas**: > 100% da receita bruta | O sistema força o resultado líquido a zero e emite um alerta crítico de faturamento. (Valor líquido negativo) |
| Caso 10 | 1, 4, 7, 10, 12, 15 | **Ação**: Realizar estorno de passagem<br>**Estado do painel**: Gráficos sem atualização imediata | O sistema aciona uma sincronização de cache forçada para corrigir os números defasados. (Valores não atualizados após alteração) |

---

# Assistente Interativo
<div align="justify">

  **US12**: Enquanto viajante, desejo ter acesso a um assistente interativo com instruções passo a passo (tutorial em tela), para que eu possa entender facilmente como utilizar as funcionalidades do aplicativo, como buscar viagens e comprar passagens, sem me sentir perdido ou precisar de ajuda externa.

**Critérios de Aceitação:**

- **CR01**: O sistema deve exibir as dicas e orientações do assistente imediatamente (em tempo real) após a interação do usuário com a tela ou botão correspondente.
- **CR02**: O sistema deve permitir que o usuário navegue pelas mensagens, oferecendo botões para avançar para a próxima dica, voltar para a anterior ou encerrar (pular) o assistente a qualquer momento.
- **CR03**: O sistema deve disponibilizar um botão de "Ajuda" ou ícone informativo (como um ponto de interrogação) que permita ao usuário reativar o assistente passo a passo sempre que desejar rever o tutorial.
- **CR04**: Os balões de mensagem ou a sobreposição visual do assistente devem focar no elemento da interface que está sendo explicado, escurecendo o restante da tela para direcionar a atenção do usuário.

**Regras de Negócio:**

- **RN01**: O conteúdo textual das mensagens do assistente deve ter no máximo 100 caracteres.
- **RN02**: O fluxo do assistente passo a passo deve ser acionado de forma automática apenas durante o primeiro acesso do usuário ao aplicativo ou quando uma funcionalidade completamente nova for lançada.
- **RN03**: A presença do assistente não deve obrigar o usuário a completar o tutorial para usar o aplicativo; a opção de "Pular" ou fechar a assistência deve respeitar a autonomia do viajante.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Conteúdo da mensagem | Mensagem com até 100 caracteres (1) | Mensagem vazia (2) | Mensagem com mais de 100 caracteres (3) |
| Acionamento do assistente | Primeiro acesso ou nova funcionalidade (4) | Assistente não exibido no primeiro acesso (5) | |
| Navegação no tutorial | Usuário pode avançar, voltar ou encerrar o tutorial (6) | Navegação parcialmente disponível (7) | Navegação indisponível (8) |
| Reativação do assistente | Tutorial reativado pelo botão de ajuda (9) | Botão de ajuda indisponível (10) | |
| Autonomia do usuário | Usuário pode pular o tutorial a qualquer momento (11) | Usuário obrigado a concluir o tutorial (12) | |

## Casos de Teste

| Casos de teste | Classes de equivalência | Entradas | Resultados esperados |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 4, 6, 9, 11 | **Usuário**: Primeiro acesso<br>**Mensagem**: Instrução curta (80 caracteres)<br>**Navegação**: Clique em "Pular" | O assistente renderiza os componentes perfeitamente e é fechado sem deixar rastros na interface. |
| Caso 2 | 2, 4, 6, 9, 11 | **Mensagem**: *[Em branco / Vazia]*<br>**Ação**: Sistema tenta renderizar passo | O passo do tutorial é suprimido para evitar a amostragem de balões de fala sem conteúdo. (Mensagem vazia) |
| Caso 3 | 3, 4, 6, 9, 11 | **Mensagem**: Texto longo (150 caracteres) | O layout quebra ou o texto sofre um corte abrupto com reticências. (Mensagem com mais de 100 caracteres) |
| Caso 4 | 1, 5, 6, 9, 11 | **Usuário**: Primeiro acesso (com dados locais limpos)<br>**Estado**: Disparador falha em abrir tela | O tutorial não inicia sozinho, exigindo que o usuário localize o menu de suporte manualmente. (Assistente não exibido no primeiro acesso) |
| Caso 5 | 1, 4, 7, 9, 11 | **Navegação**: Clique no comando "Voltar" | O aplicativo trava na tela atual devido à falha de callback do botão de navegação. (Navegação parcialmente disponível) |
| Caso 6 | 1, 4, 8, 9, 11 | **Navegação**: Botões de controle ausentes na tela | O usuário fica impossibilitado de fechar ou progredir, restando apenas reiniciar o app. (Navegação indisponível) |
| Caso 7 | 1, 4, 6, 10, 11 | **Estado**: Ícone de ajuda oculto/removido<br>**Ação**: Solicitar abertura manual | Ação impossibilitada por falta do elemento gráfico de acionamento. (Botão de ajuda indisponível) |
| Caso 8 | 1, 4, 6, 9, 12 | **Navegação**: Botão "Pular" ocultado pelo sistema | O fluxo impede a saída do usuário, gerando uma experiência de uso impositiva. (Usuário obrigado a concluir o tutorial) |

---

# Cancelamento de Passagem

**US13**: Enquanto viajante, desejo ter a opção de cancelar uma passagem adquirida diretamente pelo aplicativo, para que eu possa reaver o valor investido ou liberar o assento em caso de imprevistos ou alterações nos meus planos de viagem.

**Critérios de Aceitação:**

- **CR01**: O sistema deve exibir um botão de "Cancelar Reserva" visível na tela de detalhes do bilhete, ativo até o prazo limite estipulado nas regras de negócio.
- **CR02**: Ao acionar o cancelamento, o aplicativo deve exibir uma janela de confirmação alertando o usuário sobre as políticas de retenção de taxas, se houver.
- **CR03**: O sistema deve notificar o usuário na tela e por e-mail com o comprovante de solicitação de estorno e o prazo para crédito na conta bancária.
- **CR04**: Caso a passagem tenha sido comprada via boleto e ainda não compensada, o cancelamento deve ser imediato e sem ônus.

**Regras de Negócio:**

- **RN01**: O cancelamento automatizado com estorno direto só é permitido se solicitado com até 24 horas de antecedência do horário previsto para o embarque.
- **RN02**: Passageiros afetados por cancelamentos de viagens em massa disparados pelo Proprietário possuem direito a estorno integral (100%) automático, independente do prazo.

<div align="justify">

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Prazo para cancelamento | Solicitação realizada com pelo menos 24 horas de antecedência (1) | Solicitação realizada com menos de 24 horas de antecedência (2) | |
| Cancelamento por viagem cancelada | Viagem cancelada pelo proprietário com direito a estorno integral (3) | Viagem não cancelada pelo proprietário (4) | |
| Status do boleto | Boleto ainda não compensado (5) | Boleto já compensado (6) | |
| Estorno da passagem | Estorno realizado conforme as regras de negócio (7) | Estorno não realizado quando devido (8) | Estorno realizado indevidamente (9) |

## Casos de Teste

| Casos de teste | Classes de equivalência | Entradas | Resultados esperados |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 3, 5, 7 | **Prazo**: Solicitado com 48h de antecedência<br>**Motivo**: Desistência voluntária<br>**Status do boleto**: Não compensado | A passagem é cancelada de imediato, o assento retorna à venda e o boleto é invalidado. |
| Caso 2 | 2, 3, 5, 7 | **Prazo**: Solicitado faltando 5 hours para a partida | Ação bloqueada. O sistema informa as regras de restrição de cancelamento tardio. (Solicitação realizada com menos de 24 horas de antecedência) |
| Caso 3 | 1, 4, 5, 7 | **Motivo**: Reclamação de viagem não cancelada pelo dono<br>**Ação**: Forçar estorno integral | O sistema bloqueia o estorno integral automático por falta de conformidade regulatória. (Viagem não cancelada pelo proprietário) |
| Caso 4 | 1, 3, 6, 7 | **Status do boleto**: Já compensado no sistema<br>**Ação**: Solicitar cancelamento | O sistema altera a rotina interna para estorno bancário e devolução em vez de apenas anular a cobrança. (Boleto já compensado) |
| Caso 5 | 1, 3, 5, 8 | **Ação**: Executar cancelamento<br>**Estado**: Gateway financeiro fora do ar | A passagem é marcada como cancelada na plataforma, mas o reembolso financeiro entra em fila de erro. (Estorno não realizado quando devido) |
| Caso 6 | 1, 3, 5, 9 | **Estado da passagem**: Já utilizada em viagem anterior<br>**Ação**: Enviar comando de cancelamento | O back-end recusa a operação por violação temporal do ciclo de vida do bilhete. (Estorno realizado indevidamente) |

---

# Iniciar e Encerrar Viagem

**US14**: Enquanto proprietário ou comandante da embarcação, desejo dispor de um comando para iniciar e encerrar oficialmente uma viagem agendada, para que o aplicativo passe a transmitir os dados de localização geográfica (GPS) aos passageiros apenas durante o percurso planejado.

**Critérios de Aceitação:**

- **CR01**: O painel da agenda/calendário do proprietário deve exibir um botão "Iniciar Viagem" para rotas com status "Agendada" e que estejam no horário de partida.
- **CR02**: Ao clicar em "Iniciar Viagem", o status da rota no banco de dados deve mudar para "Em Andamento", liberando o acesso ao mapa para os passageiros.
- **CR03**: Durante todo o percurso, o aplicativo do condutor deve exibir um indicador visual claro de que a transmissão de localização está ativa ("Transmitindo sinal de GPS...").
- **CR04**: Ao chegar ao destino, o condutor deve clicar em "Encerrar Viagem", mudando o status da rota para "Finalizada" e interrompendo o consumo de dados de localização do dispositivo.

**Regras de Negócio:**

- **RN01**: O aplicativo só está autorizado a coletar e transmitir coordenadas de latitude e longitude para o servidor central enquanto o status da respectiva viagem for estritamente "Em Andamento".
- **RN02**: Caso o sinal de internet caia durante o trajeto, o aplicativo do condutor deve tentar restabelecer a conexão em background sem travar a interface de navegação do comando.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Status da viagem para início | Viagem com status "Agendada" e dentro do horário de partida (1) | Viagem não agendada (2) | Viagem fora do horário de partida (3) |
| Início da viagem | Comando "Iniciar Viagem" executado corretamente (4) | Comando não executado (5) | |
| Status da viagem para transmissão GPS | Viagem com status "Em Andamento" (6) | Viagem com status "Agendada" (7) | Viagem com status "Finalizada" (8) |
| Encerramento da viagem | Comando "Encerrar Viagem" executado ao final do percurso (9) | Viagem não encerrada após chegada ao destino (10) | |
| Conectividade durante a viagem | Conexão ativa ou restabelecida automaticamente (11) | Falha de conexão sem tentativa de reconexão (12) | |

## Casos de Teste

| Casos de teste | Classes de equivalência | Entradas | Resultados esperados |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 4, 6, 9, 11 | **Status para início**: "Agendada" (no horário)<br>**Comando**: "Iniciar Viagem"<br>**Status de rede**: Conexão ativa<br>**Comando final**: "Encerrar Viagem" (no destino) | A viagem muda de estado, a malha de rastreio GPS inicia a transmissão em tempo real e encerra sem falhas ao chegar. |
| Caso 2 | 2, 4, 6, 9, 11 | **Status para início**: "Em Análise"<br>**Comando**: "Iniciar Viagem" | O comando é desativado para impedir o início operacional de rotas sem aprovação prévia. (Viagem não agendada) |
| Caso 3 | 3, 4, 6, 9, 11 | **Status para início**: "Agendada" (antecedência de 5 dias)<br>**Comando**: "Iniciar Viagem" | Erro de validação temporal. O sistema bloqueia a inicialização precoce de cronogramas. (Viagem fora do horário de partida) |
| Caso 4 | 1, 5, 6, 9, 11 | **Comando**: "Iniciar Viagem"<br>**Conectividade**: Dispositivo totalmente sem sinal | O comando falha em propagar para a nuvem e a viagem permanece inalterada no servidor. (Comando não executado) |
| Caso 5 | 1, 4, 7, 9, 11 | **Status de transmissão**: "Agendada"<br>**Ação**: Enviar coordenadas geográficas | O servidor descarta os pacotes de GPS por inconsistência de estado operacional. (Viagem com status "Agendada") |
| Caso 6 | 1, 4, 8, 9, 11 | **Status de transmissão**: "Finalizada"<br>**Ação**: Enviar coordenadas geográficas | O receptor de dados bloqueia a entrada de telemetria após o fechamento da viagem. (Viagem com status "Finalizada") |
| Caso 7 | 1, 4, 6, 10, 11 | **Estado da viagem**: Barco atracou no destino<br>**Comando**: *[Nenhum - Esquecimento do comandante]* | O status da rota permanece ativo e o rastreador continua consumindo dados em segundo plano. (Viagem não encerrada após chegada ao destino) |
| Caso 8 | 1, 4, 6, 9, 12 | **Conectividade**: Queda de sinal de rede<br>**Ação do sistema**: Sem tentativas de reconexão | O mapa congela na última posição recebida, deixando os passageiros desinformados. (Falha de conexão sem tentativa de reconexão) |

---

# Bilhete Offline

**US15**: Enquanto viajante, desejo que os meus bilhetes de passagem sejam salvos automaticamente no armazenamento local do meu dispositivo após a compra, contendo todos os meus dados de identificação e os detalhes da rota, para que eu consiga apresentar a cédula de embarque digital ao proprietário e garantir meu acesso à embarcação de forma totalmente visual, mesmo sem conectividade com a internet.

**Critérios de Aceitação:**

- **CR01**: Imediatamente após a confirmação do pagamento ou compensação, o sistema deve realizar o download silencioso e salvar os dados do bilhete no cache interno do aplicativo.
- **CR02**: Se o usuário abrir o aplicativo sem conexão de rede ativa, a interface deve exibir um alerta discreto ("Modo Offline Ativo") e permitir o acesso imediato à tela de "Meus Bilhetes".
- **CR03**: A interface do bilhete em modo offline deve exibir, obrigatoriamente e de forma destacada, as informações completas de identificação do passageiro: Nome Completo, CPF e Número do Documento de Identidade (RG).
- **CR04**: O bilhete digital deve apresentar claramente os dados de validação da viagem: Nome da Embarcação, Número do Assento/Poltrona, Porto de Origem, Porto de Destino, Data e Horário de Embarque.
- **CR05**: O layout do bilhete deve ser projetado para validação estritamente visual, utilizando fontes de alta legibilidade e cores contrastantes para que o proprietário ou comandante consiga conferir os dados e liberar o embarque sem a necessidade de escaneamento de QR Code.
- **CR06**: O sistema deve disponibilizar um botão para gerar e abrir a versão em formato PDF do bilhete, mantendo a mesma estrutura de dados para conferência.

**Regras de Negócio:**

- **RN01**: O aplicativo está proibido de ocultar, bloquear ou exigir autenticação online para a exibição de bilhetes que já foram previamente baixados e armazenados no cache local do dispositivo.
- **RN02**: Os dados de identificação impressos no bilhete (Nome, CPF e RG) devem ser um reflexo exato dos dados inseridos e validados no formulário de compra, impedindo alterações posteriores pelo usuário após a emissão do bilhete.
- **RN03**: Toda a renderização de dados de acessibilidade (como o Modo de Alto Contraste da US06) deve persistir localmente,axing que a cédula de embarque offline mantenha as preferências visuais do usuário sem depender do servidor.

## Classes de Equivalência

| Condição de Entrada | Classe Válida | Classe Inválida | Classe Inválida |
|:---------------------:|:---------------:|:-----------------:|:-----------------:|
| Status do pagamento | Pagamento confirmado ou compensado (1) | Pagamento não confirmado (2) | |
| Armazenamento do bilhete | Bilhete salvo corretamente no cache local (3) | Bilhete não salvo no cache local (4) | |
| Acesso offline | Bilhete disponível sem conexão com a internet (5) | Bilhete indisponível sem internet (6) | |
| Dados de identificação | Nome, CPF e RG exibidos corretamente (7) | Dados incompletos (8) | Dados divergentes dos informados na compra (9) |
| Dados da viagem | Embarcação, assento, origem, destino, data e horário exibidos corretamente (10) | Dados da viagem incompletos (11) | Dados da viagem incorretos (12) |
| Preferências de acessibilidade | Configurações visuais mantidas no modo offline (13) | Configurações visuais não mantidas no modo offline (14) | |

## Casos de Teste

| Casos de teste | Classes de equivalência | Entradas | Resultados esperados |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 3, 5, 7, 10, 13 | **Pagamento**: Confirmado<br>**Cache**: Salvo localmente<br>**Rede**: Offline<br>**Dados**: Completos<br>**Acessibilidade**: Alto contraste ativo | O aplicativo abre a réplica visual estável do bilhete com dados e acessibilidade preservados através do cache. |
| Caso 2 | 2, 3, 5, 7, 10, 13 | **Pagamento**: Pendente / Não confirmado<br>**Rede**: Offline<br>**Ação**: Abrir bilhete eletrônico | A renderização de validação (QR Code) é suprimida para impedir embarques sem quitação. (Pagamento não confirmado) |
| Caso 3 | 1, 4, 5, 7, 10, 13 | **Cache**: Não gravado devido a erro de disco<br>**Rede**: Offline | A tela de passagens carrega vazia devido à indisponibilidade de persistência local. (Bilhete não salvo no cache local) |
| Caso 4 | 1, 3, 6, 7, 10, 13 | **Rede**: Offline<br>**Ação**: Forçar atualização de tela (Gestos) | A tela gera um aviso pop-up informando a impossibilidade de sincronizar dados sem rede. (Bilhete indisponível sem internet) |
| Caso 5 | 1, 3, 5, 8, 10, 13 | **Dados de ID**: Nome preenchido / CPF: *[Em branco]* | O bilhete exibe dados incompletos, podendo acarretar problemas na conferência visual do porto. (Dados incompletos) |
| Caso 6 | 1, 3, 5, 9, 10, 13 | **Dados de ID**: Cache exibindo dados de outro usuário | O sistema impede a exibição por quebra de segurança de dados privados. (Dados divergentes dos informados na compra) |
| Caso 7 | 1, 3, 5, 7, 11, 13 | **Dados da viagem**: Destino e data / Embarcação: *[Em branco]* | O bilhete falha em guiar o passageiro pela ausência de parâmetros logísticos básicos. (Dados da viagem incompletos) |
| Caso 8 | 1, 3, 5, 7, 12, 13 | **Dados da viagem**: Horário divergente do banco | O bilhete mostra o horário defasado do cache, desconsiderando correções feitas na nuvem. (Dados da viagem incorretos) |
| Caso 9 | 1, 3, 5, 7, 10, 14 | **Acessibilidade**: Ativada online<br>**Rede**: Offline<br>**Estado**: Cores voltaram ao padrão | A interface perde os estilos adaptados por incapacidade de carregar as folhas de estilo locais. (Configurações visuais não mantidas no modo offline) |

---

# Cadastro de Viajante

**US16**: Como viajante, desejo me cadastrar na plataforma informando meus dados, para que eu possa ter acesso às funcionalidades do aplicativo.

**Critérios de Aceitação:**

- **CR01**: O sistema deve permitir que o usuário insira o e-mail ou o telefone em um campo de texto único, identificando automaticamente o tipo de dado inserido (máscara de e-mail ou máscara de telefone com DDD) para direcionar o método de envio do código.
- **CR02**: O sistema deve exibir uma mensagem de erro clara em tela caso o formato do e-mail seja inválido ou o número de telefone não possua o padrão nacional de dígitos (DDD + 9 dígitos).
- **CR03**: O sistema deve verificar em tempo real se o e-mail ou telefone inseridos já possuem cadastro ativo. Caso sim, deve bloquear o avanço e sugerir o redirecionamento para a tela de recuperação de senha.
- **CR04**: Após inserir o e-mail ou telefone e avançar, o sistema deve direcionar o usuário para uma tela exclusiva de inserção do código de verificação de 4 dígitos.
- **CR05**: A tela de verificação deve disponibilizar um botão de "Reenviar código", que só fica ativo após uma contagem regressiva de 60 segundos.
- **CR06**: O sistema deve exibir um alerta visual de "Código incorreto ou expirado" caso o token digitado não seja idêntico ao enviado.
- **CR07**: A tela de inserção de dados pessoais (Nome, Sobrenome e Idade) só deve ser exibida ao usuário após a validação do código de verificação com sucesso.
- **CR08**: O sistema deve impedir a finalização do cadastro caso a idade inserida seja menor que 18 anos, exibindo um alerta sobre a restrição de idade da plataforma.
- **CR09**: O sistema deve disponibilizar campos para "Senha" e "Confirmar Senha" na mesma tela de inserção de dados pessoais.
- **CR10**: Os campos de senha devem possuir a opção visual de alternar visibilidade (ícone de "olho") para permitir que o usuário verifique o que digitou.
- **CR11**: O sistema deve exibir indicadores visuais em tempo real (checklists coloridos) apontando quais critérios de complexidade de senha foram atingidos.
- **CR12**: O sistema deve exibir uma mensagem de erro clara e impedir a submissão caso as senhas digitadas nos dois campos sejam diferentes.

**Regras de Negócio:**

- **RN01**: O e-mail e o número de telefone fornecidos devem ser chaves únicas no banco de dados. O sistema não pode permitir duas contas ativas utilizando o mesmo e-mail ou o mesmo número de telefone.
- **RN02**: Um número de telefone só pode estar ativado e vinculado a uma única conta de viajante por vez. Caso o usuário tente cadastrar um número já existente, o sistema deve bloquear a ação e oferecer um fluxo de recuperação de conta.
- **RN03**: O código de verificação enviado por SMS ou E-mail deve ter uma validade estrita de 5 minutos. Após esse período, o código expira e o usuário é obrigado a solicitar um novo envio.
- **RN04**: O sistema deve impor um intervalo mínimo de 60 segundos para que o usuário possa clicar em "Reenviar Código". Além disso, deve haver um limite máximo de 3 tentativas de reenvio por hora para o mesmo número/e-mail.
- **RN05**: A idade inserida pelo usuário deve ser maior ou igual a 18 anos. Caso a idade informada seja inferior a 18 anos, o sistema deve bloquear o avanço do cadastro e exibir uma mensagem informando que a plataforma é restrita para maiores de idade.
- **RN06**: O cadastro só poderá ser persistido se os campos Nome, Sobrenome, Idade e pelo menos um canal de contato verificado (E-mail ou Telefone) estiverem completamente preenchidos. O salvamento de dados em branco é proibido.
- **RN07**: A senha fornecida pelo usuário deve conter, obrigatoriamente: no mínimo 8 caracteres, pelo menos uma letra maiúscula, uma letra minúscula, um caractere numérico e um caractere especial (ex: `@`, `#`, `$`, `%`, `&`, `*`).
- **RN08**: Sob nenhuma circunstância a senha do usuário deve ser transmitida ou armazenada em formato de texto limpo (plano). O servidor deve aplicar um algoritmo de hash criptográfico forte com geração de *salt* (como BCrypt ou Argon2) antes de persistir o dado na base de dados.

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

## Casos de Teste

| Casos de teste | Classes de equivalência | Entradas | Resultados esperados |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 4, 7, 10, 13, 15, 17, 20 | **E-mail/Telefone**: "valido@email.com" / inédito<br>**Código**: Correto (inserido em 2 min)<br>**Idade**: 22 anos<br>**Campos**: Completos<br>**Senha**: "Forte@2026" / Confirmada | Conta gerada com sucesso, chaves de autenticação criadas e login automático executado. |
| Caso 2 | 2, 4, 7, 10, 13, 15, 17, 20 | **E-mail**: "viajantegmail.com" | O front-end bloqueia o envio exibindo alerta de formatação ausente. (E-mail em formato inválido) |
| Caso 3 | 3, 4, 7, 10, 13, 15, 17, 20 | **Telefone**: "92999" | O validador interrompe o avanço por contagem insuficiente de dígitos de celular. (Telefone em formato inválido) |
| Caso 4 | 1, 5, 7, 10, 13, 15, 17, 20 | **E-mail**: "usuario_ativo@email.com" | O sistema recusa o avanço antes da validação por duplicidade de índice no banco. (E-mail já cadastrado) |
| Caso 5 | 1, 6, 7, 10, 13, 15, 17, 20 | **Telefone**: "(92) 98888-8888" | O sistema intercepta o fluxo e informa que o contato já possui vínculo na base. (Telefone já cadastrado) |
| Caso 6 | 1, 4, 8, 10, 13, 15, 17, 20 | **Código de verificação**: "000000" | Mensagem de erro avisa sobre a divergência do token inserido. (Código incorreto) |
| Caso 7 | 1, 4, 9, 10, 13, 15, 17, 20 | **Código de verificação**: Digitado após 10 min | O servidor invalida o código por expiração do tempo útil do token. (Código expirado) |
| Caso 8 | 1, 4, 7, 11, 13, 15, 17, 20 | **Reenvio de código**: Clicado após 15 segundos | O botão permanece desativado até cumprir o intervalo mínimo anti-spam. (Reenvio antes de 60 segundos) |
| Caso 9 | 1, 4, 7, 12, 13, 15, 17, 20 | **Reenvio de código**: 4ª tentativa na mesma hora | O sistema suspende temporariamente os disparos para o contato. (Mais de 3 reenvios por hora) |
| Caso 10 | 1, 4, 7, 10, 13, 14, 15, 20 | **Data de nascimento**: "10/10/2015" | O sistema rejeita a continuidade informando a restrição de idade da plataforma. (Idade menor que 18 anos) |
| Caso 11 | 1, 4, 7, 10, 13, 15, 16, 20 | **Dados pessoais**: Nome preenchido / Sobrenome: *[Em branco]* | O formulário aponta a obrigatoriedade dos dados nominativos faltantes. (Algum campo obrigatório não preenchido) |
| Caso 12 | 1, 4, 7, 10, 13, 15, 17, 18 | **Senha**: "Ab1@" | O campo de senha rejeita a entrada pela baixa contagem de caracteres. (Senha com menos de 8 caracteres) |
| Caso 13 | 1, 4, 7, 10, 13, 15, 17, 19 | **Senha**: "12345678" | O sistema avisa que a composição falha nos critérios de segurança e símbolos. (Senha sem atender aos requisitos de complexidade) |
| Caso 14 | 1, 4, 7, 10, 13, 15, 17, 21 | **Senha**: "Forte@2026"<br>**Confirmação**: "Diferente@2026" | O envio é travado por incompatibilidade de strings nos campos de senha. (Senha e confirmação diferentes) |

---

# Cadastro de Proprietário

**US17**: Como Proprietário, desejo me cadastrar na plataforma informando meus dados, para que eu possa ter acesso às funcionalidades do aplicativo.

**Critérios de Aceitação:**

- **CR01**: O sistema deve permitir que o usuário insira o e-mail ou o telefone em um campo de texto único, identificando automaticamente o tipo de dado inserido para direcionar o método de envio do código.
- **CR02**: O sistema deve permitir que o usuário insira o CNPJ em um campo de texto dedicado com aplicação automática de máscara padrão de mercado (`00.000.000/0000-00`).
- **CR03**: O sistema deve validar a estrutura matemática do CNPJ (dígitos verificadores) e exibir uma mensagem de erro clara caso o formato do e-mail, telefone ou CNPJ sejam inválidos.
- **CR04**: O sistema deve verificar em tempo real se o e-mail, telefone ou CNPJ inseridos já possuem cadastro ativo. Caso sim, deve bloquear o avanço.
- **CR05**: Após validar o e-mail/telefone, o sistema deve direcionar o usuário para uma tela exclusiva de inserção do código de verificação de 4 dígitos.
- **CR06**: A tela de verificação deve disponibilizar um botão de "Reenviar código", ativo após contagem regressiva de 60 segundos.
- **CR07**: O sistema deve exibir um alerta visual de "Código incorreto ou expirado" caso o token digitado seja inválido.
- **CR08**: A tela de dados corporativos e do responsável (Razão Social, Nome Fantasia, Nome do Responsável e CPF) só deve ser exibida após a validação do código de verificação com sucesso.
- **CR09**: A tela de dados corporativos e do responsável deve conter campos para criação e confirmação da senha de acesso do administrador da conta.
- **CR10**: O sistema deve validar a correspondência exata entre os campos "Senha" e "Confirmar Senha", exibindo um alerta imediato de incompatibilidade se divergirem.
- **CR11**: O sistema deve impedir o clique no botão de conclusão enquanto todos os requisitos de segurança e complexidade da senha corporativa não forem atendidos.

**Regras de Negócio:**

- **RN01**: E-mail, Telefone e CNPJ são chaves únicas e imutáveis na base de dados, proibindo qualquer duplicidade.
- **RN02**: O sistema deve rejeitar cadastros de CNPJs que não estejam com a situação cadastral "Ativa" na Receita Federal.
- **RN03**: O código de verificação expira estritamente em 5 minutos. O reenvio possui cooldown de 60 segundos e limite de 3 tentativas por hora.
- **RN04**: Todo novo cadastro de Proprietário assume o status de "Em Análise", impedindo a publicação de rotas ou gerenciamento de viagens até que ocorra a validação cadastral pela plataforma.
- **RN05**: O cadastro comercial só é persistido se Razão Social, CNPJ, Nome do Responsável, CPF e um canal de contato validado estiverem preenchidos. Salvamentos parciais são proibidos.
- **RN06**: A senha do proprietário deve seguir os critérios estritos de segurança: mínimo de 8 caracteres, mesclando letras maiúsculas, minúsculas, números e caracteres especiais.
- **RN07**: O backend deve barrar a criação de senhas baseadas em sequências óbvias (ex: `12345678`) ou que contenham fragmentos explícitos dos dados cadastrados, como o próprio nome do responsável, a Razão Social ou os dígitos numéricos do CNPJ/CPF.
- **RN08**: Garantia de segurança em nível de banco de dados por meio de algoritmos de hash unidirecionais não reversíveis com *salt*, impossibilitando a leitura ou descriptografia da credencial por terceiros ou administradores da infraestrutura.

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

## Casos de Teste

| Casos de teste | Classes de equivalência | Entradas | Resultados esperados |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 4, 7, 10, 13, 16, 18, 21, 23 | **E-mail/Telefone**: válidos/inéditos<br>**CNPJ**: Ativo/inédito<br>**Código**: Correto<br>**Dados**: Completos<br>**Senha**: "Empresa@2026" / Confirmada | O cadastro corporativo é criado com status passivo, aguardando moderação humana dos documentos. |
| Caso 2 | 2, 4, 7, 10, 13, 16, 18, 21, 23 | **E-mail**: "dono_empresa.com" | O sistema invalida o campo pela ausência da estrutura básica de correio digital. (E-mail em formato inválido) |
| Caso 3 | 3, 4, 7, 10, 13, 16, 18, 21, 23 | **Telefone**: "texto123" | A máscara de entrada expurga os caracteres alfabéticos inválidos. (Telefone em formato inválido) |
| Caso 4 | 1, 5, 7, 10, 13, 16, 18, 21, 23 | **CNPJ**: "12.345.678/001" | O campo acusa erro estrutural por falta de numeração básica do documento jurídico. (CNPJ com formato inválido) |
| Caso 5 | 1, 6, 7, 10, 13, 16, 18, 21, 23 | **CNPJ**: "00.000.000/0001-00" (Inativo) | A API de back-end consulta a Receita Federal e rejeita a inscrição do CNPJ irregular. (CNPJ inativo ou irregular) |
| Caso 6 | 1, 4, 8, 10, 13, 16, 18, 21, 23 | **E-mail**: "proprietario_ativo@email.com" | O sistema bloqueia a criação indicando que o e-mail já encabeça outra frota. (E-mail já cadastrado) |
| Caso 7 | 1, 4, 9, 10, 13, 16, 18, 21, 23 | **CNPJ**: "11.222.333/0001-44" (Duplicado) | O validador rejeita a operação informando duplicidade cadastral de pessoa jurídica. (Telefone ou CNPJ já cadastrado) |
| Caso 8 | 1, 4, 7, 11, 13, 16, 18, 21, 23 | **Código de verificação**: "999999" | O avanço de tela é negado pela inconsistência numérica do token. (Código incorreto) |
| Caso 9 | 1, 4, 7, 12, 13, 16, 18, 21, 23 | **Código de verificação**: Inserido após 6 minutos | O token é recusado na validação por estourar o tempo regulamentar em nuvem. (Código expirado) |
| Caso 10 | 1, 4, 7, 10, 14, 16, 18, 21, 23 | **Reenvio de código**: Clicado com 20 segundos | A solicitação é ignorada até o encerramento do cronômetro de segurança de tela. (Reenvio antes de 60 segundos) |
| Caso 11 | 1, 4, 7, 10, 15, 16, 18, 21, 23 | **Reenvio de código**: 5ª tentativa consecutiva | O sistema suspende temporariamente os envios para evitar gargalos nos servidores. (Mais de 3 reenvios por hora) |
| Caso 12 | 1, 4, 7, 10, 13, 17, 16, 18, 21, 23 | **Dados cadastrais**: Razão Social: *[Em branco]* | O envio de arquivos é suspenso por falta de preenchimento dos metadados textuais obrigatórios. (Algum campo obrigatório não preenchido) |
| Caso 13 | 1, 4, 7, 10, 13, 16, 19, 21, 23 | **Senha**: "admin123" | O sistema notifica a fraqueza da senha por falta de alternância de caixa e símbolos. (Senha que não atende aos requisitos mínimos de complexidade) |
| Caso 14 | 1, 4, 7, 10, 13, 16, 20, 21, 23 | **Razão Social**: "Fluvial Tapajós"<br>**Senha**: "FluvialTapajos" | A política de segurança recusa a combinação por expor dados idênticos ao cadastro da empresa. (Senha baseada em dados óbvios do cadastro) |
| Caso 15 | 1, 4, 7, 10, 13, 16, 18, 22, 23 | **Senha**: "Empresa@2026"<br>**Confirmação**: "Errada@2026" | O sistema emite alerta visual e impede a finalização devido à discrepância de inputs. (Senha e confirmação diferentes) |
| Caso 16 | 1, 4, 7, 10, 13, 16, 18, 21, 24 | **Ação**: Injetar parâmetro direto para status "Aprovado" | A validação do banco de dados intercepta a tentativa e força o status default de segurança. (Cadastro liberado sem validação da plataforma) |

</div>

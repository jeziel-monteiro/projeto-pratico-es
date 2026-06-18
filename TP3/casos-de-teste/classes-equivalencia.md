# Classes de Equivalência
<div align="justify">
Esta seção apresenta as classes de equivalência e os casos de teste definidas para as histórias de usuário do sistema. A técnica foi aplicada com base nos critérios de aceitação e regras de negócio previamente especificados, considerando as principais condições de entrada válidas e inválidas para cada funcionalidade.
</div>

# Busca de Viagens

**US01**: Enquanto viajante, desejo buscar por viagens informando origem, destino e data, para encontrar opções de transporte disponíveis que atendam à minha necessidade.

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

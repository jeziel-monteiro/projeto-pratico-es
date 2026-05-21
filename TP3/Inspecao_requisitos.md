# Inspeção de Requisitos

<div align = "justify">

O objetivo desta etapa do trabalho é realizar, de forma prática, a validação e o refinamento do backlog do produto por meio de um processo formal de inspeção de requisitos. Com base no relatório de inspeção preenchido por outra equipe em anonimato a respeito das User Stories, critérios de aceitação e regras de negócio da esquipe, estruturamos uma auditoria interna para corrigir o backlog do sistema.

Aqui abaixo está os seguintes componentes corrigidos: 

## Inspeção 1

### Descrição do Problema

O requisito estabelece que o tempo de chegada deve ser recalculado quando houver "atrasos significativos", mas não define o que constitui um atraso significativo (ex: 5 minutos, 15 minutos ou 10% do tempo total da viagem).

**Trecho do Requisito**

> **US05**:"sempre que houver desvios na rota original ou atrasos significativos".

### Correção do Requisito

> **US05**: O tempo de chegada deve ser recalculado automaticamente e exibido na tela sempre que houver desvios na rota original ou atrasos significativos "**em relação ao que foi estipulado no cadastro da viagem pelo proprietário**".

A equipe adicionou a informação de que o tempo de chegada irá ser recalculado em relação ao que foi estipulado no cadastro da viagem. 

## Inspeção 2

### Descrição do Problema

O termo "mensagem clara" é subjetivo e ambíguo. O requisito não define o conteúdo, o formato (pop-up, banner, áudio) ou quais informações críticas devem constar no aviso de perda de sinal

**Trecho do Requisito**

> **US05**: "O sistema deve notificar o usuário através de uma mensagem clara caso o sinal de GPS seja perdido ou esteja instável."

### Correção do Requisito

> **US05**: O sistema deve notificar o usuário por meio de uma mensagem simples "**(Exemplo: "instabilidade na conexão com a internet") no centro da tela** "caso o sinal de GPS seja perdido ou esteja instável.

Foi adicionado um exemplo para dar possiveis ideias do conteúdo da mensagem a ser exibida ao usuário caso haja perda de sinal ou instabilidade.

## Inspeção 3

### Descrição do Problema

O sistema permite a escolha de "Boleto Bancário", mas todas as regras e critérios de sucesso focam em validação "em tempo real" e download imediato do bilhete, o que não se aplica ao boleto devido ao prazo de compensação bancária.

### Trecho do Requisito

> **US07**: "opções de pagamento habilitadas... como: 'Cartão de Crédito', 'PIX' e 'Boleto Bancário'".

### Correção do Requisito

> **US07**: "A opção "Boleto Bancário" só deve aparecer visível e selecionável se a data de embarque da viagem respeitar o prazo mínimo de antecedência configurado nas regras de negócio. Caso contrário, a opção deve ser ocultada ou aparecer desabilitada com um aviso informando o motivo (ex: "Indisponível: compras via boleto exigem X dias de antecedência para compensação")"

Foi adicionado mais critérios de aceitação e regras de neǵocio para prevenir incosistências como a trava de 72 horas garantindo que nenhum passageiro tente viajar com um boleto emitido poucas horas antes da partida.


### Descrição do Problema

## Inspeção 4

### Descrição do Problema

Os adjetivos utilizados para descrever as mensagens são subjetivos. O que é "curto" ou "simples" para um desenvolvedor pode não ser para o usuário, impossibilitando uma validação técnica objetiva.

### Trecho do Requisito

> USO12:"conteúdo textual... deve ser obrigatoriamente curto, simples e direto ao ponto".

### Correção do Requisito

> "O conteúdo textual das mensagens do assistente deve **ter no máximo 100 caracteres**."

O requisto foi alterado para mensurar a informação a ser exibida para o usuário.

## Inspeção 5

### Descrição do Problema

O termo "embarque aberto" é vago. Não define se isso se refere a um intervalo de tempo antes da partida (ex: 30 minutos antes) ou se é um status manual alterado pelo proprietário.

### Trecho do Requisito

> US01: "Listar apenas viagens com vagas disponíveis e com embarque aberto".

### Correção do Requisito

> US01: Listar apenas viagens com vagas disponíveis e com "**embarque que ainda não foi realizado a viagem**".

O requisito foi reformulado para deixar mais claro o proposito do User History.
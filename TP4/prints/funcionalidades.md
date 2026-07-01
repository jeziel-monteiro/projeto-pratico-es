#  Documentação de Telas e Fluxos 

<div align="justify">

Nesta primeira parte, mapeamos os fluxos iniciais do aplicativo: desde o primeiro acesso do usuário até o início do processo de compra da passagem. 

---

## 1.  Fluxo de Acesso e Autenticação (US016)

### Boas-vindas (Splash e Onboarding)
| Splash | Onboarding 1 | Onboarding 2 | Onboarding 3 |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/a15608bc-5688-474b-822b-a5337341628e" width="250"> | <img src="https://github.com/user-attachments/assets/60a9bf5f-9f2e-4d01-a489-da0277ab5157" width="250"> | <img src="https://github.com/user-attachments/assets/a6807aab-1be4-4fe1-8592-4a7b81a211dd" width="250"> | <img src="https://github.com/user-attachments/assets/f647c67a-3a13-428e-b818-756435e90f56" width="250"> |

**Descrição da Tela:** Telas de introdução ao aplicativo, apresentando a proposta de valor do Porto Certo: segurança, praticidade e facilidade para buscar embarcações e navegar pelos rios da Amazônia.

**Fluxo:** Ao abrir o app, o usuário visualiza a animação de Splash. Em seguida, é guiado por três telas de introdução (Onboarding). O usuário pode deslizar para ler os informativos, tocar em "Pular" para ir direto ao acesso, ou tocar em "Começar Agora" na última tela. Também há a opção direta de "Já tenho conta" para usuários recorrentes.

### Login e Recuperação de Senha
| Login | Recuperar Senha |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/59f5d92f-e4b1-47ed-9c58-edd5d8f1a9ed" width="250"> | <img src="https://github.com/user-attachments/assets/e3a55a89-bdab-412c-a0fd-b30941df6dda" width="250"> |

**Descrição da Tela:** Interface de autenticação segura e fluxo de recuperação de acesso para usuários que esqueceram suas credenciais.

**Fluxo:** Na tela de Login, o usuário insere seu E-mail e Senha. Caso tenha esquecido a senha, ele clica em "Esqueci minha senha" e é levado à tela de Recuperação, onde informa o e-mail cadastrado para receber um link de redefinição. Caso seja um novo usuário, o botão "Criar nova conta" o direciona para o formulário de registro.

### Cadastro de Novo Viajante
| Cadastro |
| :---: |
| <img src="https://github.com/user-attachments/assets/3504ba25-e510-4573-ba48-7625bdc95ef1" width="250"> |

**Descrição da Tela:** Formulário de registro exigindo dados pessoais (Nome, CPF, Telefone, E-mail e Senha) para garantir a integridade dos passageiros na plataforma.

**Fluxo:** O usuário preenche seus dados pessoais e de contato. O sistema valida os campos de acordo com as regras de negócio (ex: exigência de senha forte com no mínimo 8 caracteres). Ao clicar em "Criar Minha Conta", o usuário aceita os Termos de Uso e Políticas de Privacidade, e seu perfil é criado com sucesso.

---

## 2.  Fluxo de Busca de Viagens (US01 e US012)

### Home e Assistente Virtual
| Home | Assistente |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/605628ae-fdc2-4fc0-bcf0-2f2b14279e26" width="250"> | <img src="https://github.com/user-attachments/assets/5dedc14d-9467-4d39-aefc-43a28ae7ff00" width="250"> |

**Descrição da Tela:** A Home é o painel principal do viajante, exibindo viagens em destaque e uma busca rápida. O Assistente atua como um chat interativo opcional para ajudar na escolha do destino.

**Fluxo:** Na Home, o usuário logado pode visualizar *cards* com embarcações em destaque. Um *tooltip* educativo incentiva o uso da barra de busca. Alternativamente, o usuário pode interagir com o Assistente (chatbot), que sugere rotas populares (como Manaus, Santarém, Parintins) de forma conversacional e permite avançar facilmente para as opções disponíveis.

### Busca e Resultados de Viagens
| Busca | Resultados |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/f9a5373a-9c70-457e-957c-d59103694bd3"  width="250"> | <img src="https://github.com/user-attachments/assets/f8f4dcac-33dd-41be-812b-2c2ca267e4e4" width="250"> |

**Descrição da Tela:** Telas dedicadas à pesquisa de rotas. O usuário informa os parâmetros da viagem e recebe uma lista de embarcações disponíveis, filtradas de acordo com sua necessidade.

**Fluxo:** Na tela de Busca, o usuário define a Origem, o Destino e a Data da viagem, ou escolhe uma "Cidade Popular" em atalhos rápidos. Ao buscar, ele é levado à tela de Resultados, onde visualiza uma lista de barcos. Cada *card* mostra a rota, nota da embarcação, data, horário de saída e preço. O usuário pode tocar em "Comprar" ou em "Detalhes" para saber mais.

---

## 3.  Detalhes da Embarcação (US010)

### Perfil, Avaliações e Próximas Viagens
| Perfil da Embarcação | Próximas Viagens | Avaliações |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/2862dd41-d364-4fdb-9269-c23f424d3000" width="250"> | <img src="https://github.com/user-attachments/assets/ebf08bd7-e893-44aa-90c5-888136b359fd" width="250"> | <img src="https://github.com/user-attachments/assets/e91203ed-4951-4fd7-a37b-7011c02929de" width="250"> |

**Descrição da Tela:** Visão detalhada do transporte, oferecendo transparência sobre as comodidades do barco, o calendário de saídas e a reputação da embarcação.

**Fluxo:** Ao clicar em "Detalhes" de um barco, o usuário entra no Perfil da Embarcação. Lá, ele verifica a capacidade de passageiros, velocidade, registro e comodidades (Wi-Fi, Ar-condicionado, Refeição, etc.). Rolando a tela, o usuário tem acesso à lista de "Próximas Viagens" daquele barco específico e pode ler as "Avaliações" deixadas por outros viajantes, garantindo total confiança antes da compra.

---

## 4.  Fluxo de Compra e Acomodação (US02) - Início

### Dados da Viagem e Acomodação
| Dados da Viagem | Acomodação |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/32479ed4-700f-4c38-aaf3-4fce399a200d" width="250"> | <img src="https://github.com/user-attachments/assets/651c001d-b803-4ae6-ac68-532f8adfb3f2" width="250"> |

**Descrição da Tela:** As primeiras etapas do funil de conversão (checkout). O usuário define os portos exatos de subida e descida e escolhe como vai viajar (Rede, Camarote, etc.).

**Fluxo:** Na tela de Compra, o usuário confirma o barco selecionado e escolhe os pontos exatos de Embarque e Desembarque (ex: embarcar em Manaus e desembarcar em Itacoatiara). Em seguida, avança para a tela de Acomodação, onde seleciona o tipo de espaço desejado (local para armar rede, assento padrão ou camarote privativo), escolha esta que definirá o preço final da passagem.

---

## 5.  Meus Bilhetes e Rastreamento (US015 e US05)

### Cédula de Embarque (Digital)
| Bilhete |
| :---: |
| <img src="https://github.com/user-attachments/assets/67a6ae8d-ce81-445e-ba15-ae62b48dc971" width="250"> |

**Descrição da Tela:** O documento oficial de embarque do passageiro, gerado automaticamente após a aprovação do pagamento.

**Fluxo:** A tela exibe um QR Code (ou código de barras) para leitura no momento do embarque. Também mostra de forma clara o nome do passageiro, a embarcação, o número do assento/rede e os horários. Este bilhete fica salvo no dispositivo para acesso *offline*, garantindo que o utilizador consiga embarcar mesmo sem internet no porto.

### Gestão de Viagens e Mapa em Tempo Real
| Minhas Viagens | Rastreamento (Mapa) |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/6a6b0114-2e39-419c-8632-801b8f9ca463" width="250"> | <img src="https://github.com/user-attachments/assets/a90875c6-8589-435d-bc17-8f0b669131a0" width="250"> | 

**Descrição da Tela:** Área pessoal do viajante para gerir reservas e acompanhar o deslocamento da embarcação via satélite/GPS.

**Fluxo:** Na aba "Minhas Viagens", o utilizador acede ao histórico de viagens passadas e futuras. Aqui, ele pode solicitar o cancelamento e estorno de uma viagem futura (US013). Para viagens em andamento, ele pode clicar em "Rastrear", abrindo um mapa interativo que mostra a localização atualizada da embarcação, o tempo estimado de chegada e eventuais alertas meteorológicos.

---

## 6.  Perfil, Configurações e Demais Telas (US06 e US08)

### Perfil e Configurações

| Perfil | Configurações | Favoritos |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/cb1e3ebf-67f7-4aaf-8940-c6630a86a37e" width="250"> | <img src="https://github.com/user-attachments/assets/5772eb4b-5dd5-4a3d-bc02-04be6b352c19" width="250"> | <img src="https://github.com/user-attachments/assets/4cc43f5a-1dd5-4edd-bb4d-f2434c65a99a" width="250"> |   

**Descrição do Ecrã:** Área pessoal do viajante para gerir os seus dados, preferências da aplicação e rotas guardadas.

**Fluxo:** No ecrã de Perfil, o utilizador pode visualizar e editar as suas informações pessoais. Em Configurações, ajusta as preferências da aplicação, como notificações e segurança da conta. Na aba de Favoritos, encontra rapidamente as embarcações e rotas que guardou (clicando no ícone de coração), facilitando pesquisas e compras futuras.


### Acessibilidade, Termos e Privacidade

| Acessibilidade | Termos de Uso | Privacidade |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/79b5837f-53e8-466b-baa7-83d1ac76b47c" width="250"> | <img src="https://github.com/user-attachments/assets/d5a018ee-c94e-4cf8-ae3b-362024e5023c" width="250"> | <img src="https://github.com/user-attachments/assets/ad084e38-a323-4d9d-b300-8fc61c7ffb92" width="250"> |

**Descrição da Tela:** Telas de suporte focadas na inclusão digital e na transparência legal do aplicativo Porto Certo.

**Fluxo:** - **Acessibilidade:** Permite ao usuário ativar recursos como o "Modo de Alto Contraste" (mudando as cores para facilitar a leitura) e otimizar o app para leitores de tela (VoiceOver/TalkBack).
- **Termos de Uso e Privacidade:** Telas informativas e estáticas onde o viajante pode consultar as regras de utilização da plataforma, seus direitos e como seus dados pessoais são armazenados e protegidos.

</div>

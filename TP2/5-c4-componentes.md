# Diagrama de Componentes 

O objetivo deste diagrama é detalhar os blocos de construção internos de um único Container, revelando como as funcionalidades são agrupadas arquiteturalmente. Ele não chega ao nível minucioso de classes ou linhas de código de programação, mas mapeia os componentes lógicos de negócio (como controladores, serviços e repositórios), suas responsabilidades únicas, o encapsulamento das regras e como eles se comunicam através de interfaces claras para fazer o contêiner funcionar.

## **App Mobile do Viajante**

## Explicação geral do diagrama modelado

<img width="16384" height="10337" alt="viajante" src="https://github.com/user-attachments/assets/f917efb9-126f-4e23-83ac-2159a0387979" />

<br>
<br>

O diagrama modelado para o App Mobile do Viajante ilustra a separação de responsabilidades entre a interface com o usuário, a regra de negócio e a comunicação de dados. Globalmente, o fluxo demonstra o passageiro interagindo com cinco componentes visuais e de controle distintos (que lidam com cadastro, buscas, emissão de bilhetes e carteira). Para evitar acoplamento, nenhum desses componentes visuais acessa a nuvem diretamente; todos eles delegam o tráfego de dados para uma Camada de Repositório centralizada. O diagrama também destaca a resiliência do sistema com um cache de dados local e ilustra as saídas do aplicativo para consumir APIs especializadas, como mapas e pagamentos.

## Detalhamento por Partes

### Acesso e Gestão de Credenciais

<img width="7710" height="3350" alt="logineseguranca" src="https://github.com/user-attachments/assets/abf304f6-47f7-4c7f-9f1b-6d08dd43fd1c" />

<br>
<br>

Nesta parte do diagrama, observamos a porta de entrada do aplicativo. O usuário interage com dois controladores dedicados exclusivamente à segurança. O Controlador de Cadastro e Login captura e valida localmente as credenciais, enquanto o Controlador de Redefinição de Senha gerencia as solicitações de recuperação de conta. Ambos se comunicam com o repositório para validar a sessão, isolando a regra de validação visual das chamadas de rede.

### Núcleo de Negócios (Busca e Compra)

<img width="7810" height="3410" alt="buscaeemissao" src="https://github.com/user-attachments/assets/9f4a6645-69bb-4e51-8d58-0a4ed6592bc4" />

<br>
<br>

O Componente de Busca e Rotas processa a pesquisa por datas e portos de origem/destino. Assim que o usuário escolhe a viagem, o fluxo avança para o Componente de Emissão de Passagens, que é responsável por gerenciar a escolha de assentos (redes ou camarotes), validar os dados do passageiro e iniciar a etapa financeira para garantir a reserva no sistema.

### Resiliência e Persistência Offline

<img width="7810" height="3410" alt="buscaeemissao" src="https://github.com/user-attachments/assets/7fd82eca-c898-4582-ac88-c1b44563ee8b" />

<br> 
<br>

Esta seção destaca o diferencial arquitetural pensado para o contexto amazônico. O componente Meus Bilhetes (Carteira) renderiza os QR Codes de embarque. Para garantir que o passageiro consiga abrir essa carteira em portos remotos sem conexão de internet, tanto a Camada de Repositório quanto a Carteira interagem com a Persistência Offline do Firestore, que atua como um banco de dados local temporário, armazenando os dados essenciais baixados previamente.

### Comunicação com Sistemas Externos e Repositório Central

<img width="9220" height="1220" alt="externos" src="https://github.com/user-attachments/assets/57d33946-b75b-460c-a29d-1594c6f78247" />

<br>
<br>

O detalhamento final evidencia como o aplicativo delega responsabilidades especializadas para infraestruturas externas:

- A Camada de Repositório age como o canal único de comunicação com o ecossistema principal do Porto Certo (o Firebase na nuvem), sincronizando leituras e escritas via SDK.

- O componente de busca envia coordenadas diretamente para o Serviço de Mapas (Mapbox) para renderizar o trajeto de forma visual.

- O componente de passagens aciona o SDK seguro do Gateway de Pagamento (Mercado Pago) para realizar transações financeiras sem que o cartão do cliente transite pelos nossos servidores, garantindo conformidade com padrões de segurança.

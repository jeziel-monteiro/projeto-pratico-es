# Refatorações

<div align="justify">

Uma **refatoração** reorganiza a estrutura interna do código para melhorar sua
legibilidade, manutenção ou extensibilidade, preservando o comportamento
observável do sistema. Algumas branches analisadas também incluem correções
visuais ou evolução de funcionalidade. Nesses casos, o documento identifica
separadamente a técnica de refatoração presente e a mudança de comportamento.

As técnicas foram relacionadas à nomenclatura usual do catálogo de
refatorações apresentado em *Engenharia de Software Moderna*, principalmente:

- **Extract Function**;
- **Move Function**;
- **Extract Class/Module**;
- **Change Function Declaration**;
- **Replace Magic Literal**;
- **Move Statements**.

Também foi considerada a aplicação de **injeção de dependência** para reduzir
acoplamento e melhorar a testabilidade.

## Resumo das refatorações

| Refatoração | Técnica principal | Natureza | Commit principal |
|---|---|---|---|
| Separação da fábrica de telas | Extract Function + Move Function | Estrutural | `refactor: separa fabrica de telas do shell principal` |
| Modularização do fluxo de compra | Extract Class/Module | Estrutural | `:books: docs: refactor: modulariza fluxo de compra e pagamento` |
| Modularização de perfil e acessibilidade | Extract Class/Module | Estrutural | `refactor: modulariza telas de perfil e acessibilidade` |
| Centralização do alto contraste | Change Function Declaration + Replace Magic Literal | Estrutural e funcional | `:sparkles: feat: aplica alto contraste global no app do viajante`<br>`fix: completa alto contraste global no app do viajante` |
| Remoção do nome fixo da tela inicial | Replace Magic Literal + injeção de dependência | Estrutural e funcional | `refactor: exibe nome do usuário autenticado na home`<br>`fix: exibe primeiro nome na tela inicial` |
| Reorganização dos campos de busca | Move Statements | Estrutural e visual | `refactor: alinha botão de inverter rota`<br>`fix: alinha botão à borda dos campos` |
| Expansão do cabeçalho de login | Reorganização da árvore de widgets | Correção visual | `fix: expande cabeçalho da tela de login` |
| Abstração da origem das imagens | Extract Function | Estrutural e funcional | `refactor: adiciona imagens fluviais às viagens` |

> **Resultado:** foram registradas oito intervenções, incluindo mais de cinco
> aplicações de refatoração e pelo menos cinco técnicas distintas.

## Refatorações realizadas

### Separação da fábrica de telas do shell principal

**Branch:** `refactor/modularizar-shell-navegacao`  
**Commits:** `refactor: separa fabrica de telas do shell principal` (dois commits)  
**Merge em `develop`:** `Merge pull request #50 from jeziel-monteiro/refactor/modularizar-shell-navegacao`
— Pull Request #50

#### Problema identificado

O método `_buildScreen()` estava dentro de
`PortoCertoShell` e concentrava a criação de todas as telas do aplicativo. O
shell acumulava duas responsabilidades: manter o estado e a navegação global e,
ao mesmo tempo, conhecer os construtores e dependências de todas as telas.

O grande `switch` tornava o arquivo `porto_certo_app.dart` extenso, fortemente
acoplado às funcionalidades e mais sujeito a conflitos durante o
desenvolvimento paralelo.

#### Motivação

Separar a composição das telas da gestão de estado permite que o shell permaneça
focado na navegação. A fábrica pode evoluir independentemente quando novas telas
ou dependências forem adicionadas.

#### Técnica aplicada

- **Extract Function:** extração da lógica de `_buildScreen()`;
- **Move Function:** movimentação da construção das telas para outro módulo;
- separação de responsabilidades.

#### Descrição da melhoria

Foi criado o arquivo
[`porto_certo_screen_factory.dart`](TP4/lib/app/porto_certo_screen_factory.dart),
com a função `buildPortoCertoScreen()`. O método do shell passou apenas a
encaminhar o estado e os callbacks necessários:

```dart
Widget _buildScreen() {
  return buildPortoCertoScreen(
    screen: _screen,
    nav: _nav,
    favoriteIds: _favorites,
    // Demais estados e callbacks...
  );
}
```

O `switch` com a instanciação das telas foi movido para a fábrica. Uma revisão
posterior (`refactor: separa fabrica de telas do shell principal`) removeu
imports e parâmetros que se tornaram desnecessários.

#### Arquivos afetados

- `TP4/lib/app/porto_certo_app.dart`;
- `TP4/lib/app/porto_certo_screen_factory.dart`.

#### Impacto no sistema

- redução de aproximadamente 129 linhas no shell na primeira extração;
- menor acoplamento entre navegação e criação de telas;
- redução do risco de conflitos no arquivo principal;
- inclusão de novas rotas em um local específico;
- preservação do comportamento de navegação existente.

---

### Modularização do fluxo de compra e pagamento

**Branch:** `refactor/modularizar-compra-pagamento`  
**Commit:** `:books: docs: refactor: modulariza fluxo de compra e pagamento`  
**Merges:** `Merge pull request #46 from jeziel-monteiro/refactor/modularizar-compra-pagamento`
em `main` e
`Merge pull request #54 from jeziel-monteiro/refactor/modularizar-compra-pagamento`
em `develop` — Pull Requests #46 e #54

#### Problema identificado

O arquivo `purchase_screens.dart` possuía mais de **3.100 linhas** e reunia
todo o fluxo de compra: passageiro, acomodação, resumo, seleção do pagamento,
PIX, boleto, cartão, resultado e bilhete. O arquivo também continha widgets
auxiliares utilizados por diferentes etapas.

Essa concentração dificultava localizar responsabilidades, revisar alterações,
testar etapas isoladamente e trabalhar em paralelo.

#### Motivação

Cada etapa do fluxo representa uma responsabilidade própria e deve poder ser
mantida sem exigir a leitura ou alteração de todo o módulo de compra.

#### Técnica aplicada

- **Extract Class/Module:** cada tela foi extraída para seu próprio arquivo;
- **Move Function:** comportamentos específicos acompanharam suas respectivas
  telas;
- extração de componentes compartilhados.

#### Descrição da melhoria

As telas foram distribuídas no diretório
`TP4/lib/features/purchase/screens/`:

```text
screens/
├── accommodation_screen.dart
├── boleto_screen.dart
├── credit_card_screen.dart
├── passenger_screen.dart
├── payment_result_screen.dart
├── payment_screen.dart
├── pix_screen.dart
├── summary_screen.dart
└── ticket_screen.dart
```

Os componentes reutilizados foram movidos para
`widgets/purchase_widgets.dart`. O arquivo original foi mantido como ponto de
exportação dos novos módulos, preservando os imports já utilizados pelo
restante da aplicação.

#### Arquivos afetados

- `TP4/lib/features/purchase/purchase_screens.dart`;
- `TP4/lib/features/purchase/screens/*.dart`;
- `TP4/lib/features/purchase/widgets/purchase_widgets.dart`.

#### Impacto no sistema

- redução do arquivo agregador de cerca de 3.142 linhas para poucos exports;
- maior coesão de cada etapa da compra;
- componentes compartilhados centralizados;
- manutenção e revisão de código mais simples;
- preservação da API pública do módulo e do fluxo funcional.

---

### Modularização das telas de perfil e acessibilidade

**Branch:** `refactor/modularizar-perfil-acessibilidade`  
**Commit:** `refactor: modulariza telas de perfil e acessibilidade`  
**Merge em `develop`:** `Merge pull request #51 from jeziel-monteiro/refactor/modularizar-perfil-acessibilidade`
— Pull Request #51

#### Problema identificado

O arquivo `profile_screens.dart` possuía aproximadamente **1.746 linhas** e
reunia perfil, configurações, alteração de senha, acessibilidade e ajuda. Além
das telas, o mesmo arquivo continha widgets auxiliares e lógica de acesso a
dados.

#### Motivação

O módulo apresentava baixa coesão: funcionalidades diferentes compartilhavam
um único arquivo apenas por pertencerem à área de perfil. Isso aumentava o custo
de manutenção e a probabilidade de conflitos.

#### Técnica aplicada

- **Extract Class/Module:** extração das classes de tela;
- **Move Function:** deslocamento da lógica para o módulo responsável;
- extração de widgets compartilhados.

#### Descrição da melhoria

O módulo passou a ter a seguinte organização:

```text
profile/
├── profile_screens.dart
├── screens/
│   ├── accessibility_screen.dart
│   ├── change_password_screen.dart
│   ├── help_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
└── widgets/
    └── profile_widgets.dart
```

`profile_screens.dart` tornou-se um agregador de exports, permitindo que os
consumidores existentes continuassem usando o mesmo ponto de importação.

#### Arquivos afetados

- `TP4/lib/features/profile/profile_screens.dart`;
- `TP4/lib/features/profile/screens/*.dart`;
- `TP4/lib/features/profile/widgets/profile_widgets.dart`.

#### Impacto no sistema

- redução do arquivo monolítico para cinco exports;
- separação clara entre telas e componentes compartilhados;
- maior facilidade para localizar e testar responsabilidades;
- menor possibilidade de conflitos entre alterações independentes;
- comportamento e contratos externos preservados.

---

### Centralização e propagação do alto contraste

**Branch:** `refactor/alto-contraste-global`  
**Commits:** `:sparkles: feat: aplica alto contraste global no app do viajante`
e `fix: completa alto contraste global no app do viajante`  
**Merge em `develop`:** `Merge pull request #44 from jeziel-monteiro/refactor/alto-contraste-global`
— Pull Request #44

#### Problema identificado

O alto contraste era tratado de forma parcial. Diversos componentes utilizavam
cores fixas de `AppColors`, ignorando o tema ativo, e a preferência do usuário
não era reaplicada de forma consistente ao iniciar uma sessão ou retornar à
tela inicial.

#### Motivação

Espalhar condicionais e cores específicas por várias telas cria duplicação e
torna futuras mudanças de acessibilidade difíceis. A definição visual deveria
ter uma única fonte de verdade.

#### Técnica aplicada

- **Change Function Declaration:** `AppTheme.light()` recebeu o parâmetro
  `highContrast`;
- **Replace Magic Literal:** cores fixas foram substituídas por propriedades de
  `Theme.of(context).colorScheme`;
- centralização de configuração no tema;
- extração do carregamento da preferência para
  `_loadHighContrastPreference()`.

#### Descrição da melhoria

`AppTheme` passou a produzir tanto o tema padrão quanto o tema de alto
contraste:

```dart
static ThemeData light({bool highContrast = false}) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: highContrast ? Colors.yellow : AppColors.primary,
    brightness: highContrast ? Brightness.dark : Brightness.light,
  );
  // Configuração dos componentes...
}
```

O shell aplica o tema globalmente, enquanto botões, cartões, campos, chips,
cabeçalhos, indicadores e cartões de viagem passaram a consumir as cores
semânticas do tema. A preferência também é recuperada do perfil do viajante.

Foi adicionado `app_theme_test.dart` para verificar tanto a paleta padrão quanto
a combinação preta, branca e amarela do modo de alto contraste.

#### Arquivos afetados

- `TP4/lib/app/porto_certo_app.dart`;
- `TP4/lib/core/theme/app_theme.dart`;
- componentes de `TP4/lib/core/widgets/`;
- telas de autenticação, onboarding, perfil, compra e viagem;
- `TP4/test/app_theme_test.dart`.

#### Impacto no sistema

- fonte única para as decisões de tema;
- remoção de várias cores rígidas dos componentes;
- alto contraste aplicado de maneira uniforme;
- preferência persistida e recuperada durante a navegação;
- cobertura automatizada para evitar regressões visuais básicas.

> Esta intervenção também evolui o comportamento de acessibilidade; portanto,
> não é uma refatoração puramente comportamentalmente neutra.

---

### Substituição do nome fixo pelo usuário autenticado

**Branch:** `refactor/nome-usuario-home`  
**Commits:** `refactor: exibe nome do usuário autenticado na home`, integração
`Resolve conflito entre nome do usuário e alto contraste` e ajuste
`fix: exibe primeiro nome na tela inicial`

#### Problema identificado

A tela inicial exibia o literal `"Ana Carolina"` para qualquer usuário. Além de
incorreto, o valor estava acoplado à camada de apresentação. A `HomeScreen`
também criava internamente seu repositório, dificultando testes isolados.

#### Motivação

A interface deve receber o nome obtido durante a autenticação, sem conhecer os
detalhes de recuperação do perfil. O repositório precisa ser substituível em
testes.

#### Técnica aplicada

- **Replace Magic Literal:** remoção do nome estático;
- **Change Function Declaration:** inclusão de `travelerName` nos construtores;
- injeção de dependência opcional para `TravelRepository`;
- **Extract Function:** criação posterior de `_buildGreetingName()`.

#### Descrição da melhoria

Login e cadastro passaram a comunicar o nome carregado por meio do callback
`onTravelerNameLoaded`. O shell mantém esse dado e o fornece à tela inicial:

```dart
HomeScreen(
  travelerName: _travelerName,
  // Demais dependências...
)
```

A apresentação passou a normalizar o valor, exibir apenas o primeiro nome e
usar `"Viajante Porto Certo"` como fallback. A tela também aceita um repositório
alternativo para testes.

Foi criado `home_screen_test.dart`, que confirma a exibição do usuário
autenticado e a remoção do nome fixo.

#### Arquivos afetados

- `TP4/lib/app/porto_certo_app.dart`;
- `TP4/lib/features/auth/auth_screens.dart`;
- `TP4/lib/features/travel/travel_screens.dart`;
- `TP4/test/home_screen_test.dart`.

#### Impacto no sistema

- apresentação coerente com a sessão autenticada;
- eliminação de dado fictício da interface;
- fluxo de dados explícito entre autenticação, shell e home;
- tela inicial testável sem acesso real à API;
- tratamento consistente para nomes vazios ou compostos.

> A remoção do literal e a injeção de dependência são refatorações; a
> personalização da saudação é uma melhoria funcional.

---

### Reorganização dos campos e do botão de inversão da busca

**Branch:** `refactor/alinhamento-icone-setas-busca`  
**Commits:** `refactor: alinha botão de inverter rota` e
`fix: alinha botão à borda dos campos`  
**Merge em `develop`:** `Merge pull request #47 from jeziel-monteiro/refactor/alinhamento-icone-setas-busca`
— Pull Request #47

#### Problema identificado

Os campos de origem e destino eram irmãos externos ao `Stack`, enquanto o botão
de inversão estava relacionado somente ao primeiro campo. Essa estrutura
dificultava posicionar o controle entre os dois campos e produzia desalinhamento
visual.

#### Motivação

Os elementos que participam do mesmo posicionamento devem pertencer ao mesmo
contexto de layout. Isso torna explícita a relação entre os campos e o botão.

#### Técnica aplicada

- **Move Statements:** os dois campos foram movidos para uma única `Column`
  dentro do `Stack`;
- reorganização da composição de widgets;
- inclusão de descrição semântica por `tooltip`.

#### Descrição da melhoria

Antes, somente o campo de origem estava no `Stack`. Depois, origem e destino
foram agrupados em uma `Column`, permitindo posicionar o botão sobre a região
entre ambos:

```dart
Stack(
  clipBehavior: Clip.none,
  children: [
    Column(
      children: [
        PcTextField(label: 'Origem', ...),
        PcTextField(label: 'Destino', ...),
      ],
    ),
    Positioned(
      right: -24,
      top: 73,
      child: IconButton.filledTonal(
        tooltip: 'Inverter origem e destino',
        ...
      ),
    ),
  ],
)
```

O segundo commit refinou o deslocamento horizontal para alinhar o botão à borda
dos campos.

#### Arquivo afetado

- `TP4/lib/features/travel/travel_screens.dart`.

#### Impacto no sistema

- hierarquia de widgets coerente com a relação visual;
- alinhamento mais previsível;
- manutenção do comportamento de inversão;
- melhoria de acessibilidade com a descrição do botão.

> A reorganização estrutural preserva a ação existente, mas os valores de
> posicionamento representam uma correção visual.

---

### Expansão do cabeçalho da tela de login

**Branch:** `refactor/preenchimento-topo-login`  
**Commit:** `fix: expande cabeçalho da tela de login`  
**Merge em `develop`:** `Merge pull request #48 from jeziel-monteiro/refactor/preenchimento-topo-login`
— Pull Request #48

#### Problema identificado

O contêiner decorado do cabeçalho assumia a largura de seu conteúdo em alguns
contextos, fazendo com que o gradiente não ocupasse toda a largura disponível.

#### Motivação

O cabeçalho deve controlar explicitamente sua restrição horizontal, sem
depender do tamanho intrínseco da coluna interna.

#### Técnica aplicada

- reorganização da árvore de widgets;
- encapsulamento do conteúdo em um componente de restrição (`SizedBox`).

#### Descrição da melhoria

Foi introduzido um `SizedBox(width: double.infinity)` entre o `DecoratedBox` e o
`SafeArea`. O conteúdo, os espaçamentos e a hierarquia textual foram
preservados.

#### Arquivo afetado

- `TP4/lib/features/auth/auth_screens.dart`.

#### Impacto no sistema

- gradiente preenchendo toda a largura da tela;
- restrição de layout explícita;
- nenhuma alteração na autenticação ou na navegação.

> Trata-se principalmente de uma correção de layout registrada em uma branch
> de refatoração, e não de uma refatoração de domínio.

---

### Abstração da origem das imagens das embarcações

**Branch:** `refactor/imagens-embarcacoes-amazonicas`  
**Commit:** `refactor: adiciona imagens fluviais às viagens`  
**Merge em `develop`:** `Merge pull request #55 from jeziel-monteiro/refactor/imagens-embarcacoes-amazonicas`
— Pull Request #55

#### Problema identificado

`NetworkImageBox` assumia que toda imagem vinha da rede e mantinha o tratamento
de erro como callback anônimo dentro de `build()`. Isso impedia o uso
transparente de imagens locais e duplicaria o fallback caso uma segunda
estratégia de carregamento fosse adicionada.

Além disso, a API sempre apresentava a primeira foto da embarcação, sem permitir
que uma viagem específica tivesse imagem própria.

#### Motivação

O componente visual deve escolher a estratégia de carregamento sem expor essa
decisão aos seus consumidores. O tratamento de falha deve permanecer único, e
o modelo deve suportar uma imagem específica por viagem.

#### Técnica aplicada

- **Extract Function:** extração do fallback para `_buildError()`;
- encapsulamento da decisão entre `Image.asset` e `Image.network`;
- extensão compatível do modelo de dados.

#### Descrição da melhoria

O componente passou a selecionar a origem pelo prefixo da URL:

```dart
final image = url.startsWith('assets/')
    ? Image.asset(url, errorBuilder: _buildError)
    : Image.network(url, errorBuilder: _buildError);
```

O fallback visual foi extraído e reutilizado pelas duas estratégias. No
backend, `Trip` recebeu o campo opcional `imageUrl`; o presenter prioriza a
imagem da viagem e mantém a foto da embarcação como alternativa:

```typescript
imageUrl: trip.imageUrl ?? trip.vessel.photos[0]?.url ?? null
```

A migração, o seed e o `pubspec.yaml` foram atualizados, e três imagens locais
de embarcações amazônicas foram adicionadas.

#### Arquivos afetados

- `TP4/lib/core/widgets/network_image_box.dart`;
- `TP4/backend/prisma/schema.prisma`;
- `TP4/backend/prisma/migrations/20260630202000_add_trip_image_url/migration.sql`;
- `TP4/backend/prisma/seed.ts`;
- `TP4/backend/src/modules/trips/trip.presenter.ts`;
- `TP4/pubspec.yaml`;
- `TP4/assets/images/*.png`.

#### Impacto no sistema

- um único componente suporta imagens locais e remotas;
- tratamento de erro reutilizado;
- viagens podem ter identidade visual própria;
- fallback mantém compatibilidade com fotos de embarcações;
- redução da dependência de serviços externos de imagem.

> A extração do fallback e o encapsulamento da origem são refatorações. A
> inclusão do campo `imageUrl` e dos novos assets é uma evolução funcional.

## Rastreabilidade no Git

| Branch | Commits de implementação | Integração conhecida |
|---|---|---|
| `refactor/modularizar-shell-navegacao` | `refactor: separa fabrica de telas do shell principal`<br>`refactor: separa fabrica de telas do shell principal` | PR #50 — `Merge pull request #50 from jeziel-monteiro/refactor/modularizar-shell-navegacao` em `develop` |
| `refactor/modularizar-compra-pagamento` | `:books: docs: refactor: modulariza fluxo de compra e pagamento` | PR #46 — `Merge pull request #46 from jeziel-monteiro/refactor/modularizar-compra-pagamento` em `main`;<br>PR #54 — `Merge pull request #54 from jeziel-monteiro/refactor/modularizar-compra-pagamento` em `develop` |
| `refactor/modularizar-perfil-acessibilidade` | `refactor: modulariza telas de perfil e acessibilidade` | PR #51 — `Merge pull request #51 from jeziel-monteiro/refactor/modularizar-perfil-acessibilidade` em `develop` |
| `refactor/alto-contraste-global` | `:sparkles: feat: aplica alto contraste global no app do viajante`<br>`fix: completa alto contraste global no app do viajante` | PR #44 — `Merge pull request #44 from jeziel-monteiro/refactor/alto-contraste-global` em `develop` |
| `refactor/nome-usuario-home` | `refactor: exibe nome do usuário autenticado na home`<br>`Resolve conflito entre nome do usuário e alto contraste`<br>`fix: exibe primeiro nome na tela inicial` | incorporada ao histórico de `develop` |
| `refactor/alinhamento-icone-setas-busca` | `refactor: alinha botão de inverter rota`<br>`fix: alinha botão à borda dos campos` | PR #47 — `Merge pull request #47 from jeziel-monteiro/refactor/alinhamento-icone-setas-busca` em `develop` |
| `refactor/preenchimento-topo-login` | `fix: expande cabeçalho da tela de login` | PR #48 — `Merge pull request #48 from jeziel-monteiro/refactor/preenchimento-topo-login` em `develop` |
| `refactor/imagens-embarcacoes-amazonicas` | `refactor: adiciona imagens fluviais às viagens` | PR #55 — `Merge pull request #55 from jeziel-monteiro/refactor/imagens-embarcacoes-amazonicas` em `develop` |

</div>

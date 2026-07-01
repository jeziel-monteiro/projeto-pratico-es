import 'package:flutter/material.dart';
import '../../../app/app_state.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/pc_text_field.dart';
import '../../../core/widgets/section_title.dart';
import '../widgets/profile_widgets.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _search = TextEditingController();
  int? _openIndex;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faqs = const [
      (
        'Como compro uma passagem?',
        'Acesse Buscar, informe origem, destino e data. Escolha a viagem, preencha os dados do passageiro e conclua o pagamento.',
      ),
      (
        'Como cancelo minha reserva?',
        'Acesse Minhas Viagens, selecione a viagem e toque em Cancelar. O reembolso segue a política exibida no bilhete.',
      ),
      (
        'O bilhete digital funciona offline?',
        'Sim. O bilhete é salvo no dispositivo após a compra e fica disponível sem internet.',
      ),
      (
        'Quais formas de pagamento são aceitas?',
        'PIX, Cartão de Crédito e Boleto Bancário.',
      ),
      (
        'Qual a diferença entre Rede e Camarote?',
        'Rede é inclusa no bilhete. Camarote tem cabine privativa e custo adicional.',
      ),
    ];

    final filtered = faqs
        .where(
          (item) =>
              _search.text.isEmpty ||
              item.$1.toLowerCase().contains(_search.text.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Central de Ajuda',
            backTo: AppScreen.profile,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcTextField(
                  label: 'Buscar dúvidas',
                  hint: 'Buscar dúvidas...',
                  icon: Icons.search,
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _HelpAction(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat ao Vivo',
                      color: AppColors.teal,
                      onTap: () {},
                    ),
                    _HelpAction(
                      icon: Icons.phone_outlined,
                      label: 'Ligar Agora',
                      color: AppColors.primary,
                      onTap: () {},
                    ),
                    _HelpAction(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Bilhete Digital',
                      color: AppColors.accent,
                      onTap: () => widget.nav(AppScreen.ticket),
                    ),
                    _HelpAction(
                      icon: Icons.navigation_outlined,
                      label: 'Rastreamento',
                      color: AppColors.success,
                      onTap: () => widget.nav(AppScreen.tracking),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Orientações de Compra'),
                      ProfileMenuRow(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Como comprar passagens',
                        onTap: () => widget.nav(AppScreen.guidePurchase),
                      ),
                      ProfileMenuRow(
                        icon: Icons.credit_card,
                        label: 'Guia de Pagamentos',
                        onTap: () => widget.nav(AppScreen.guidePayment),
                      ),
                      ProfileMenuRow(
                        icon: Icons.airline_seat_flat_angled,
                        label: 'Tipos de Acomodação',
                        onTap: () => widget.nav(AppScreen.guideAccommodation),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Perguntas Frequentes'),
                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Nenhum resultado encontrado.',
                            style: TextStyle(color: AppColors.muted),
                          ),
                        )
                      else
                        ...List.generate(filtered.length, (index) {
                          final item = filtered[index];
                          final open = _openIndex == index;
                          return ExpansionTile(
                            initiallyExpanded: open,
                            onExpansionChanged: (value) => setState(
                              () => _openIndex = value ? index : null,
                            ),
                            tilePadding: EdgeInsets.zero,
                            title: Text(
                              item.$1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  item.$2,
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key, required this.nav, required this.topic});

  final AppNavigator nav;
  final GuideTopic topic;

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

enum GuideTopic { purchase, payment, accommodation }

class _GuideScreenState extends State<GuideScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final content = _guideContent(widget.topic);
    final step = content.steps[_index];
    final last = _index == content.steps.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: content.title,
            backTo: AppScreen.help,
            nav: widget.nav,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      content.steps.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: i == _index ? 34 : 16,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: i <= _index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PcCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.10,
                            ),
                            child: Icon(
                              step.icon,
                              color: AppColors.primary,
                              size: 38,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            step.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            step.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.muted,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (_index > 0) ...[
                        Expanded(
                          child: PcButton(
                            label: 'Anterior',
                            variant: PcButtonVariant.outline,
                            onPressed: () => setState(() => _index--),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: PcButton(
                          label: last ? 'Concluir' : 'Próximo',
                          icon: last
                              ? Icons.check_circle_outline
                              : Icons.arrow_forward,
                          onPressed: () {
                            if (last) {
                              widget.nav(AppScreen.help);
                            } else {
                              setState(() => _index++);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  Widget build(BuildContext context) {
    return LegalScreen(
      nav: nav,
      title: 'Termos de Uso',
      subtitle: 'Última atualização: 01/06/2026',
      sections: const [
        (
          '1. Aceitação dos Termos',
          'Ao utilizar o aplicativo Porto Certo Viagens, você concorda integralmente com estes Termos de Uso.',
        ),
        (
          '2. Uso do Serviço',
          'O aplicativo destina-se à compra de passagens fluviais, consulta de itinerários e rastreamento de embarcações.',
        ),
        (
          '3. Cadastro e Responsabilidades',
          'O usuário é responsável pela veracidade das informações fornecidas no cadastro e no embarque.',
        ),
        (
          '4. Pagamentos e Cancelamentos',
          'Cancelamentos solicitados com mais de 24h de antecedência têm reembolso integral.',
        ),
        ('5. Contato', 'Dúvidas: suporte@portocerto.com.br - (92) 3000-0000.'),
      ],
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  Widget build(BuildContext context) {
    return LegalScreen(
      nav: nav,
      title: 'Política de Privacidade',
      subtitle: 'LGPD Conforme - Última atualização: 01/06/2026',
      sections: const [
        (
          '1. Dados Coletados',
          'Coletamos nome, CPF, email, telefone, dados de pagamento tokenizados, localização durante uso e histórico de viagens.',
        ),
        (
          '2. Finalidade',
          'Os dados são usados para reservas, bilhetes, rastreamento, recomendações e cumprimento de obrigações legais.',
        ),
        (
          '3. Compartilhamento',
          'Podemos compartilhar dados com operadores parceiros, gateways de pagamento e autoridades quando exigido por lei.',
        ),
        (
          '4. Seus Direitos',
          'Você pode acessar, corrigir, excluir ou solicitar portabilidade dos seus dados.',
        ),
        (
          '5. Segurança',
          'Utilizamos criptografia, autenticação segura e controles de acesso para proteger seus dados.',
        ),
      ],
    );
  }
}

class LegalScreen extends StatelessWidget {
  const LegalScreen({
    super.key,
    required this.nav,
    required this.title,
    required this.subtitle,
    required this.sections,
  });

  final AppNavigator nav;
  final String title;
  final String subtitle;
  final List<(String, String)> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(title: title, backTo: AppScreen.login, nav: nav),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...sections.map(
                        (section) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.$1,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                section.$2,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpAction extends StatelessWidget {
  const _HelpAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideContent {
  const _GuideContent({required this.title, required this.steps});

  final String title;
  final List<_GuideStep> steps;
}

class _GuideStep {
  const _GuideStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

_GuideContent _guideContent(GuideTopic topic) {
  return switch (topic) {
    GuideTopic.purchase => const _GuideContent(
      title: 'Como Comprar uma Passagem',
      steps: [
        _GuideStep(
          icon: Icons.search,
          title: '1. Busque a viagem',
          description:
              'Informe origem, destino e data. Datas passadas são bloqueadas automaticamente.',
        ),
        _GuideStep(
          icon: Icons.directions_boat,
          title: '2. Escolha a embarcação',
          description:
              'Compare preços, horários, avaliações e comodidades antes de comprar.',
        ),
        _GuideStep(
          icon: Icons.place_outlined,
          title: '3. Selecione o trecho',
          description:
              'Escolha o ponto de embarque e desembarque. O preço é ajustado conforme a distância.',
        ),
        _GuideStep(
          icon: Icons.payment,
          title: '4. Confirme e pague',
          description:
              'Revise o resumo e escolha PIX, cartão ou boleto para concluir a compra.',
        ),
      ],
    ),
    GuideTopic.payment => const _GuideContent(
      title: 'Guia de Pagamentos',
      steps: [
        _GuideStep(
          icon: Icons.qr_code_2,
          title: 'PIX',
          description:
              'Pagamento instantâneo, sem taxa adicional e com confirmação em segundos.',
        ),
        _GuideStep(
          icon: Icons.credit_card,
          title: 'Cartão de Crédito',
          description:
              'Aceita cartões principais. Taxa de 2% sobre o valor total.',
        ),
        _GuideStep(
          icon: Icons.description_outlined,
          title: 'Boleto Bancário',
          description:
              'Vencimento em 1 dia útil. A confirmação pode levar algumas horas.',
        ),
        _GuideStep(
          icon: Icons.security,
          title: 'Segurança',
          description:
              'Transações protegidas com criptografia e dados sensíveis tokenizados.',
        ),
      ],
    ),
    GuideTopic.accommodation => const _GuideContent(
      title: 'Tipos de Acomodação',
      steps: [
        _GuideStep(
          icon: Icons.airline_seat_flat_angled,
          title: 'Rede',
          description:
              'Inclusa no bilhete, no convés da embarcação, com ventilação natural.',
        ),
        _GuideStep(
          icon: Icons.meeting_room_outlined,
          title: 'Camarote',
          description:
              'Cabine privativa com cama, ar-condicionado e tomada USB.',
        ),
        _GuideStep(
          icon: Icons.luggage_outlined,
          title: 'Bagagem',
          description:
              'Cada passageiro tem direito a 30kg de bagagem sem custo adicional.',
        ),
      ],
    ),
  };
}

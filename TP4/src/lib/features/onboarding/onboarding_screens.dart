import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../app/app_state.dart';
import '../../core/assets/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/network_image_box.dart';
import '../../core/widgets/pc_button.dart';
import '../../core/widgets/pc_chip.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(milliseconds: 2400),
      () => widget.nav(AppScreen.onboarding),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.navy, AppColors.primary, AppColors.secondary],
          ),
        ),
        child: Stack(
          children: [
            const _SplashBubbles(),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                painter: _WavePainter(),
                size: const Size(double.infinity, 150),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.logo,
                      width: 190,
                      height: 190,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sua jornada pela Amazônia começa aqui',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: index == 1 ? 24 : 8,
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.42),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _index = 0;

  static const _slides = [
    _OnboardingSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1774453262743-451850856acf?w=900&h=700&fit=crop',
      title: 'Navegue com Segurança',
      subtitle:
          'Viaje pelos rios da Amazônia com conforto, pontualidade e total segurança.',
    ),
    _OnboardingSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1558484779-3092f73da26e?w=900&h=700&fit=crop',
      title: 'Encontre as Melhores Viagens',
      subtitle:
          'Compare preços, horários e embarcações com poucos toques na tela.',
    ),
    _OnboardingSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1632022083836-e0f2abb5a212?w=900&h=700&fit=crop',
      title: 'Viaje com Praticidade',
      subtitle:
          'Compre sua passagem, acompanhe em tempo real e leve o bilhete no celular.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_index];
    final last = _index == _slides.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: NetworkImageBox(
                      url: slide.imageUrl,
                      borderRadius: 0,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.92),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.paddingOf(context).top + 12,
                    right: 18,
                    child: TextButton(
                      onPressed: () => widget.nav(AppScreen.login),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.82),
                      ),
                      child: const Text(
                        'Pular',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 11,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                child: Column(
                  children: [
                    Text(
                      slide.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 26,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      slide.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: i == _index ? 32 : 8,
                          height: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: i == _index
                                ? AppColors.primary
                                : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PcButton(
                      label: last ? 'Começar Agora' : 'Próximo',
                      icon: Icons.arrow_forward,
                      full: true,
                      onPressed: () {
                        if (last) {
                          widget.nav(AppScreen.login);
                        } else {
                          setState(() => _index++);
                        }
                      },
                    ),
                    if (!last) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => widget.nav(AppScreen.login),
                        child: const Text(
                          'Já tenho conta',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  int _step = 0;
  String _destination = '';

  final _cities = const [
    'Manaus',
    'Santarem',
    'Belem',
    'Parintins',
    'Tefe',
    'Itacoatiara',
  ];

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Olá! Para onde você quer viajar hoje?', _cities),
      (
        'Ótimo. De onde você vai sair?',
        _cities.where((city) => city != _destination).toList(),
      ),
      (
        'Perfeito. Quando você vai viajar?',
        const ['Hoje', 'Amanhã', 'Esta semana', 'Escolher data'],
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.waves, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assistente Porto Certo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Online agora',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              itemCount: _step + 1,
              itemBuilder: (context, index) {
                final step = steps[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.waves,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(18),
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18),
                                ),
                              ),
                              child: Text(
                                step.$1,
                                style: const TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 14,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (index == _step)
                        Padding(
                          padding: const EdgeInsets.only(left: 39, top: 10),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: step.$2.map((option) {
                              return PcChip(
                                label: option,
                                onTap: () {
                                  if (index == 0) _destination = option;
                                  if (index < steps.length - 1) {
                                    setState(() => _step++);
                                  } else {
                                    widget.nav(AppScreen.results);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: PcButton(
                label: 'Buscar manualmente',
                icon: Icons.chevron_right,
                full: true,
                variant: PcButtonVariant.ghost,
                onPressed: () => widget.nav(AppScreen.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
}

class _SplashBubbles extends StatelessWidget {
  const _SplashBubbles();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(6, (index) {
        final size = 64.0 + (index * 42);
        return Positioned(
          top: 80.0 + (index * 72),
          left: (index.isEven ? 28.0 : 160.0) + (index * 12),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.20);
    final path = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.18,
        size.width * 0.5,
        size.height * 0.45,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.72,
        size.width,
        size.height * 0.45,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo_tp4/app/porto_certo_app.dart';

void main() {
  testWidgets('Porto Certo inicia no splash', (tester) async {
    await tester.pumpWidget(const PortoCertoApp());

    expect(find.text('Sua jornada pela Amazônia começa aqui'), findsOneWidget);
    expect(find.text('Bem-vindo de volta'), findsNothing);
  });

  testWidgets('Splash navega para onboarding apos o timer', (tester) async {
    await tester.pumpWidget(const PortoCertoApp());
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    expect(find.text('Navegue com Segurança'), findsOneWidget);
  });
}

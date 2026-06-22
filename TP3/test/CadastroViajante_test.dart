// test/cadastro_viajante_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../lib/src/cadastro_viajante_service.dart';

void main() {
  group('US16 - Automação do Cadastro de Viajante', () {
    final service = CadastroViajanteService();

    test('Caso 1: Conta gerada com sucesso para maior de idade (Classe 13, 15)', () {
      expect(
        () => service.completarCadastro(
          'João', 'Silva', 'joao@email.com', 
          '15/05/2000', // Adulto (Nascido em 2000) -> Classe 13
          'Forte@2026', 'Forte@2026'
        ),
        returnsNormally,
      );
    });

    test('Caso 10: Cadastro rejeitado por restrição de idade (Classe 14)', () {
      expect(
        () => service.completarCadastro(
          'João', 'Silva', 'joao@email.com', 
          '10/10/2015', // Menor de idade (Nascido em 2015) -> Classe 14
          'Forte@2026', 'Forte@2026'
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'mensagem', contains('Restrição de idade'))),
      );
    });

    test('Caso Extra: Cadastro rejeitado por senhas divergentes (Classe 21)', () {
      expect(
        () => service.completarCadastro(
          'João', 'Silva', 'joao@email.com', 
          '15/05/2000', 
          'Forte@2026', 'Fraca123'
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'mensagem', contains('As senhas não coincidem'))),
      );
    });
  });
}
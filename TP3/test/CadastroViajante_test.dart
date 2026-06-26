// test/cadastro_viajante_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../lib/src/cadastro_viajante_service.dart';

void main() {
  group('US16 - Automação do Cadastro de Viajante', () {
    final service = CadastroViajanteService();

    test('Caso 1: Conta gerada com sucesso para maior de idade (Classe 13, 15)', () {
      expect(
        () => service.completarCadastro(
          'João', 'Silva', 
          'joao.caso1@email.com', // E-mail único para este teste
          '15/05/2000', 
          'Forte@2026', 'Forte@2026'
        ),
        returnsNormally,
      );
    });

    test('Caso 10: Cadastro rejeitado por restrição de idade (Classe 14)', () {
      expect(
        () => service.completarCadastro(
          'João', 'Silva', 
          'joao.crianca@email.com', // E-mail único para este teste
          '10/10/2015', 
          'Forte@2026', 'Forte@2026'
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'mensagem', contains('Restrição de idade'))),
      );
    });

    test('Caso Extra: Cadastro rejeitado por senhas divergentes (Classe 21)', () {
      expect(
        () => service.completarCadastro(
          'João', 'Silva', 
          'joao.errosenha@email.com', // E-mail único para este teste
          '15/05/2000', 
          'Forte@2026', 'Fraca123'
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'mensagem', contains('As senhas não coincidem'))),
      );
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo_tp4/features/travel/validation/trip_search_validator.dart';

void main() {
  group('US01 - Busca de viagens', () {
    test('processa busca com origem, destino e data válidos', () {
      final result = TripSearchValidator.validate(
        origin: 'Manaus',
        destination: 'Parintins',
        date: '20/12/2026',
      );

      expect(result.isValid, isTrue);
      expect(result.date, DateTime(2026, 12, 20));
    });

    test('rejeita busca com filtro obrigatório em branco', () {
      final result = TripSearchValidator.validate(
        origin: 'Manaus',
        destination: '',
        date: '20/12/2026',
      );

      expect(result.isValid, isFalse);
      expect(result.message, contains('Preencha todos os campos'));
    });

    test('rejeita dados inválidos para busca', () {
      final result = TripSearchValidator.validate(
        origin: '1234',
        destination: r'@#$%',
        date: '32/13/2026',
      );

      expect(result.isValid, isFalse);
      expect(result.message, contains('Dados inválidos'));
    });

    test('rejeita data inexistente', () {
      final result = TripSearchValidator.validate(
        origin: 'Manaus',
        destination: 'Parintins',
        date: '32/13/2026',
      );

      expect(result.isValid, isFalse);
      expect(result.message, contains('data válida'));
    });

    test('aceita cidades compostas e com acentos', () {
      final result = TripSearchValidator.validate(
        origin: 'Santarém',
        destination: 'Santana/Macapá',
        date: '09/07/2026',
      );

      expect(result.isValid, isTrue);
    });
  });
}

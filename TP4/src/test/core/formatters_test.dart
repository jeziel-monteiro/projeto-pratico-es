import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo_tp4/core/utils/formatters.dart';

void main() {
  group('formatPhone', () {
    test('formata celular com DDD e nono dígito', () {
      expect(formatPhone('92999999999'), '(92) 99999-9999');
    });

    test('limita telefone a 11 dígitos', () {
      expect(formatPhone('92999999999123'), '(92) 99999-9999');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo_tp4/features/auth/validation/register_validator.dart';

void main() {
  group('US16 - Cadastro de viajante', () {
    final today = DateTime(2026, 6, 30);

    test('aceita cadastro de viajante maior de idade', () {
      final result = RegisterValidator.validate(
        const RegisterFormInput(
          fullName: 'João Silva',
          cpf: '123.456.789-00',
          birthDate: '15/05/2000',
          email: 'joao.caso1@email.com',
          password: 'Forte@2026',
          confirmPassword: 'Forte@2026',
        ),
        now: today,
      );

      expect(result.isValid, isTrue);
    });

    test('rejeita cadastro por restrição de idade', () {
      final result = RegisterValidator.validate(
        const RegisterFormInput(
          fullName: 'João Silva',
          cpf: '123.456.789-00',
          birthDate: '10/10/2015',
          email: 'joao.crianca@email.com',
          password: 'Forte@2026',
          confirmPassword: 'Forte@2026',
        ),
        now: today,
      );

      expect(result.isValid, isFalse);
      expect(result.errors['birthDate'], contains('Restrição de idade'));
    });

    test('rejeita cadastro com senhas divergentes', () {
      final result = RegisterValidator.validate(
        const RegisterFormInput(
          fullName: 'João Silva',
          cpf: '123.456.789-00',
          birthDate: '15/05/2000',
          email: 'joao.errosenha@email.com',
          password: 'Forte@2026',
          confirmPassword: 'Fraca123',
        ),
        now: today,
      );

      expect(result.isValid, isFalse);
      expect(result.errors['confirm'], contains('As senhas não coincidem'));
    });

    test('rejeita nome com números, símbolos ou emoji', () {
      final result = RegisterValidator.validate(
        const RegisterFormInput(
          fullName: 'João 🚢 Silva 123',
          cpf: '123.456.789-00',
          birthDate: '15/05/2000',
          email: 'joao@email.com',
          password: 'Forte@2026',
          confirmPassword: 'Forte@2026',
        ),
        now: today,
      );

      expect(result.isValid, isFalse);
      expect(result.errors['name'], contains('Use apenas letras'));
    });

    test('rejeita email com emoji ou formato inválido', () {
      final result = RegisterValidator.validate(
        const RegisterFormInput(
          fullName: 'João Silva',
          cpf: '123.456.789-00',
          birthDate: '15/05/2000',
          email: 'joao🚢@email.com',
          password: 'Forte@2026',
          confirmPassword: 'Forte@2026',
        ),
        now: today,
      );

      expect(result.isValid, isFalse);
      expect(result.errors['email'], contains('Email inválido'));
    });

    test('rejeita telefone com quantidade inválida de dígitos', () {
      final result = RegisterValidator.validate(
        const RegisterFormInput(
          fullName: 'João Silva',
          cpf: '123.456.789-00',
          birthDate: '15/05/2000',
          email: 'joao@email.com',
          phone: '929999999999',
          password: 'Forte@2026',
          confirmPassword: 'Forte@2026',
        ),
        now: today,
      );

      expect(result.isValid, isFalse);
      expect(result.errors['phone'], contains('Telefone inválido'));
    });
  });
}

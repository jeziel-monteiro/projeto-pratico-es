// test/busca_viagens_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../lib/src/busca_viagens_service.dart';

void main() {
  group('US01 - Automação da Busca de Viagens', () {
    final service = BuscaViagemService();

    test('Caso 1: Busca processada com sucesso (Classes 1, 4, 6)', () {
      final viagens = service.buscar('Manaus', 'Parintins', '20/12/2026');
      
      expect(viagens.isNotEmpty, true);
      expect(viagens.first.vagasDisponiveis, greaterThan(0));
    });

    test('Caso 2: Busca rejeitada por filtro em branco (Classes 2, 4, 6)', () {
      expect(
        () => service.buscar('Manaus', '', '20/12/2026'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'erro', contains('obrigatórios'))),
      );
    });

    test('Caso 3: Dados inválidos para busca (Classes 3, 4, 6)', () {
      expect(
        () => service.buscar('1234', '@#\$%', '32/13/2026'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'erro', contains('inválidos'))),
      );
    });

    test('Caso 4: Viagem sem vagas disponíveis (Classes 1, 5, 6)', () {
      // Usando Tefé para simular o esgotamento conforme a tabela
      final viagens = service.buscar('Manaus', 'Tefé', '15/11/2026');
      
      expect(viagens.isNotEmpty, true);
      expect(viagens.first.vagasDisponiveis, 0); // Vagas esgotadas
      expect(viagens.first.status, 'Esgotada');
    });

    test('Caso 5: Embarque já iniciado ou realizado (Classes 1, 4, 7)', () {
      // Data no passado deve retornar lista vazia
      final viagens = service.buscar('Manaus', 'Coari', '10/01/2016');
      
      expect(viagens.isEmpty, true); // O sistema processa, mas não lista as viagens
    });
  });
}
// test/cadastro_viagem_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart'; // Para formatar datas dinâmicas no teste
import '../lib/src/cadastro_viagem_service.dart';

void main() {
  group('US09 - Automação do Cadastro de Viagem (Proprietário)', () {
    final service = CadastroViagemService();

    // Gera uma data válida (2 dias no futuro) para evitar que o teste expire se for rodado no mês que vem
    final dataFutura = DateTime.now().add(const Duration(days: 2));
    final dataFormatada = DateFormat('dd/MM/yyyy').format(dataFutura);

    test('Caso 1: Cadastro aceito (Embarcação homologada, limite respeitado)', () {
      expect(
        () => service.cadastrarViagem(
          embarcacaoId: 'e1', // Expresso Tapajós (Homologado, Cap: 50)
          origem: 'Manaus',
          destino: 'Parintins',
          dataStr: dataFormatada,
          horarioStr: '20:00',
          tipoViagem: 'Única',
          diasSemana: [],
          assentosVenda: 50, // Respeita o limite exato
          preco: 150.0,
        ),
        returnsNormally,
      );
    });

    test('Caso 3: Bloqueio de Embarcação não homologada (Classe 3)', () {
      expect(
        () => service.cadastrarViagem(
          embarcacaoId: 'e2', // Cisne Branco (Em Análise)
          origem: 'Manaus',
          destino: 'Parintins',
          dataStr: dataFormatada,
          horarioStr: '20:00',
          tipoViagem: 'Única',
          diasSemana: [],
          assentosVenda: 50,
          preco: 150.0,
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'erro', contains('não está homologada'))),
      );
    });

    test('Caso 8: Bloqueio de antecedência menor que 12 horas (Classe 11)', () {
      // Cria uma data para apenas 2 horas no futuro
      final dataCritica = DateTime.now().add(const Duration(hours: 2));
      final dataCriticaStr = DateFormat('dd/MM/yyyy').format(dataCritica);
      final horaCriticaStr = DateFormat('HH:mm').format(dataCritica);

      expect(
        () => service.cadastrarViagem(
          embarcacaoId: 'e1',
          origem: 'Manaus',
          destino: 'Parintins',
          dataStr: dataCriticaStr,
          horarioStr: horaCriticaStr,
          tipoViagem: 'Única',
          diasSemana: [],
          assentosVenda: 50,
          preco: 150.0,
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'erro', contains('mínimo, 12 horas de antecedência'))),
      );
    });

    test('Caso 9: Excesso de lotação (Classe 13)', () {
      expect(
        () => service.cadastrarViagem(
          embarcacaoId: 'e1', // Capacidade máxima é 50
          origem: 'Manaus',
          destino: 'Parintins',
          dataStr: dataFormatada,
          horarioStr: '20:00',
          tipoViagem: 'Única',
          diasSemana: [],
          assentosVenda: 55, // 5 lugares além do limite
          preco: 150.0,
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'erro', contains('Excesso de Lotação'))),
      );
    });
  });
}
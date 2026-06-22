// lib/src/cadastro_viagem_service.dart

// 1. Simulação da Entidade Embarcação (Vinda do Banco de Dados)
class Embarcacao {
  final String id;
  final String status; // Ex: 'Validada', 'Em Análise'
  final String nome;
  final int capacidadeMax;

  Embarcacao(this.id, this.status, this.nome, this.capacidadeMax);
}

// 2. O Controlador/Serviço da US09
class CadastroViagemService {
  
  // Banco de Dados em Memória: O proprietário tem dois barcos na frota
  final List<Embarcacao> frotaProprietario = [
    Embarcacao('e1', 'Validada', 'Expresso Tapajós', 50),
    Embarcacao('e2', 'Em Análise', 'Cisne Branco', 120),
  ];

  void cadastrarViagem({
    required String embarcacaoId,
    required String origem,
    required String destino,
    required String dataStr,
    required String horarioStr,
    required String tipoViagem,
    required List<String> diasSemana,
    required int assentosVenda,
    required double preco,
  }) {
    
    // Caso 10: O Proprietário tem embarcações na frota? (Proteção extra)
    if (frotaProprietario.isEmpty) {
      throw Exception("Acesso bloqueado. Adicione e homologue uma embarcação primeiro.");
    }

    // Caso 2: Embarcação em branco (Não selecionada)
    if (embarcacaoId.isEmpty) {
      throw Exception("Erro: Deve selecionar uma embarcação para a viagem.");
    }

    // Busca o barco no banco de dados simulado
    final barco = frotaProprietario.firstWhere(
      (e) => e.id == embarcacaoId,
      orElse: () => throw Exception("Embarcação não encontrada no sistema."),
    );

    // Caso 3: Embarcação não validada (Ex: "Em Análise")
    if (barco.status != 'Validada') {
      throw Exception("Operação bloqueada: A embarcação selecionada não está homologada pela Capitania dos Portos.");
    }

    // Caso 4: Campos obrigatórios vazios
    if (origem.isEmpty || destino.isEmpty || dataStr.isEmpty || horarioStr.isEmpty) {
      throw Exception("Todos os campos obrigatórios (Origem, Destino, Data e Horário) devem ser preenchidos.");
    }

    // Caso 5: Caracteres inválidos nos portos de origem e destino
    if (origem.contains(RegExp(r'[0-9@#\$%]')) || destino.contains(RegExp(r'[0-9@#\$%]'))) {
      throw Exception("Dados inválidos. Utilize apenas letras para definir os portos.");
    }

    // Caso 6: Tipo de viagem não definido
    if (tipoViagem != 'Única' && tipoViagem != 'Recorrente') {
      throw Exception("O tipo de viagem (Única ou Recorrente) tem de ser definido obrigatoriamente.");
    }

    // Caso 7: Viagem Recorrente sem dias da semana
    if (tipoViagem == 'Recorrente' && diasSemana.isEmpty) {
      throw Exception("Viagens recorrentes exigem a seleção de pelo menos um dia da semana.");
    }

    // Processamento de Data e Hora
    final partesData = dataStr.split('/');
    final partesHora = horarioStr.split(':');
    
    if (partesData.length != 3 || partesHora.length != 2) {
      throw Exception("Formato de data (DD/MM/AAAA) ou hora (HH:MM) inválido.");
    }

    final dia = int.tryParse(partesData[0]) ?? 0;
    final mes = int.tryParse(partesData[1]) ?? 0;
    final ano = int.tryParse(partesData[2]) ?? 0;
    final hora = int.tryParse(partesHora[0]) ?? 0;
    final minuto = int.tryParse(partesHora[1]) ?? 0;

    final dataHoraSaida = DateTime(ano, mes, dia, hora, minuto);
    final agora = DateTime.now();

    // Caso 8: Mínimo de 12 horas de antecedência
    if (dataHoraSaida.difference(agora).inHours < 12) {
      throw Exception("Regra de Segurança: A viagem tem de ser programada com, no mínimo, 12 horas de antecedência.");
    }

    // Caso 9: Quantidade de assentos superior à capacidade
    if (assentosVenda > barco.capacidadeMax) {
      throw Exception("Excesso de Lotação: Tentativa de vender $assentosVenda passagens num barco com capacidade para ${barco.capacidadeMax} lugares.");
    }

    // Validação monetária básica
    if (preco <= 0) {
      throw Exception("O valor do bilhete tem de ser superior a zero.");
    }

    // SUCESSO! A viagem passou em todas as métricas rigorosas de segurança.
  }
}
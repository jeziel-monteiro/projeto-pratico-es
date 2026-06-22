// lib/src/busca_viagens_service.dart

class Viagem {
  final String origem;
  final String destino;
  final String data;
  final int vagasDisponiveis;
  final String status;

  Viagem(this.origem, this.destino, this.data, this.vagasDisponiveis, this.status);
}

class BuscaViagemService {
  List<Viagem> buscar(String origem, String destino, String data) {
    // Caso 2: Filtro em branco (Classe 2)
    if (origem.isEmpty || destino.isEmpty || data.isEmpty) {
      throw Exception("Preencha todos os filtros obrigatórios.");
    }

    // Caso 3: Cidades com números/símbolos (Classe 3)
    if (origem.contains(RegExp(r'[0-9@#\$%]')) || destino.contains(RegExp(r'[0-9@#\$%]'))) {
      throw Exception("Dados inválidos para busca. Use apenas letras.");
    }

    // Validação de formato de data (Ainda Caso 3)
    final partesData = data.split('/');
    if (partesData.length != 3) {
      throw Exception("Formato inválido. Use DD/MM/AAAA.");
    }

    final dia = int.tryParse(partesData[0]);
    final mes = int.tryParse(partesData[1]);
    final ano = int.tryParse(partesData[2]);

    if (dia == null || mes == null || ano == null || dia < 1 || dia > 31 || mes < 1 || mes > 12) {
      throw Exception("Dados inválidos para busca. Esta data não existe.");
    }

    // Caso 5: Embarque já iniciado ou no passado (Classe 7)
    // O sistema processa, mas não lista as viagens (retorna lista vazia)
    final dataBusca = DateTime(ano, mes, dia);
    final hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    
    if (dataBusca.isBefore(hoje)) {
      return []; // Retorna vazio
    }

    // Caso 4: Viagem sem vagas disponíveis (Classe 5) - Simulando Tefé
    if (destino.toLowerCase() == 'tefé') {
      return [Viagem(origem, destino, data, 0, "Esgotada")];
    }

    // Caso 1: Caminho Feliz - Viagem com vagas (Classe 4) - Simulando Parintins e outros
    return [Viagem(origem, destino, data, 50, "Agendada")];
  }
}
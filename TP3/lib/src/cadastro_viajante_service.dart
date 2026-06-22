// lib/src/cadastro_viajante_service.dart

class CadastroViajanteService {
  // BANCO DE DADOS SIMULADO (Em Memória)
  // Já começamos com um usuário ativo para testar a Classe de Equivalência 5
  final Set<String> _contatosCadastrados = {'usuario_ativo@email.com'};

  void completarCadastro(String nome, String sobrenome, String contato, String dataNascimentoStr, String senha, String confirmacao) {
    if (nome.isEmpty || sobrenome.isEmpty || contato.isEmpty || dataNascimentoStr.isEmpty || senha.isEmpty || confirmacao.isEmpty) {
      throw Exception("Todos os campos obrigatórios devem ser preenchidos.");
    }

    final partesData = dataNascimentoStr.split('/');
    if (partesData.length != 3) {
      throw Exception("Formato de data de nascimento inválido. Use DD/MM/AAAA.");
    }

    final dia = int.tryParse(partesData[0]);
    final mes = int.tryParse(partesData[1]);
    final ano = int.tryParse(partesData[2]);

    if (dia == null || mes == null || ano == null || dia < 1 || dia > 31 || mes < 1 || mes > 12) {
      throw Exception("Data de nascimento inválida. Verifique o dia e o mês.");
    }

    final dataNasc = DateTime(ano, mes, dia);
    final hoje = DateTime.now();
    int idade = hoje.year - dataNasc.year;
    
    if (hoje.month < dataNasc.month || (hoje.month == dataNasc.month && hoje.day < dataNasc.day)) {
      idade--;
    }

    if (idade < 18) {
      throw Exception("Restrição de idade: O usuário deve ter 18 anos ou mais para se cadastrar.");
    }

    bool isEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(contato);
    bool isTelefone = RegExp(r'^\d{8,15}$').hasMatch(contato.replaceAll(RegExp(r'\D'), '')); 
    
    if (!isEmail && !isTelefone) {
      throw Exception("O formato do E-mail ou Telefone é inválido.");
    }

    // =========================================================
    // A MÁGICA DA UNICIDADE: Verificando no banco de dados falso
    // =========================================================
    if (_contatosCadastrados.contains(contato)) {
      throw Exception("Este e-mail ou telefone já está cadastrado em nossa base.");
    }

    if (senha.length < 8) {
      throw Exception("A senha deve ter no mínimo 8 caracteres.");
    }

    if (!RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])').hasMatch(senha)) {
      throw Exception("A senha deve conter letras maiúsculas, minúsculas, números e símbolos especiais.");
    }

    if (senha != confirmacao) {
      throw Exception("As senhas não coincidem. Tente novamente.");
    }

    // =========================================================
    // SUCESSO: Se passou por tudo, salvamos o novo contato na lista!
    // Na próxima vez que tentarem usar este dado, o sistema bloqueará.
    // =========================================================
    _contatosCadastrados.add(contato);
  }
}
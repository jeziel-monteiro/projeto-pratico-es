// lib/telas/cadastro_viagem_tela.dart
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:porto_certo/src/cadastro_viagem_service.dart';
import '../lib/src/cadastro_viagem_service.dart'; // Importa a Regra de Negócio

class CadastroViagemTela extends StatefulWidget {
  const CadastroViagemTela({super.key});

  @override
  State<CadastroViagemTela> createState() => _CadastroViagemTelaState();
}

class _CadastroViagemTelaState extends State<CadastroViagemTela> {
  final _rotaCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();
  final _service = CadastroViagemService();

  // CRIANDO A MÁSCARA DE DATA (##/##/####)
  final _mascaraData = MaskTextInputFormatter(
    mask: '##/##/####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  void _executarCadastro() {
    try {
      double precoDigitado = double.tryParse(_precoCtrl.text.replaceAll(',', '.')) ?? 0.0;
      
      // Converte a data do formato DD/MM/AAAA para o formato DateTime nativo do Dart
      final partesData = _dataCtrl.text.split('/');
      DateTime dataDigitada;
      if (partesData.length == 3) {
        final dia = int.tryParse(partesData[0]) ?? 0;
        final mes = int.tryParse(partesData[1]) ?? 0;
        final ano = int.tryParse(partesData[2]) ?? 0;
        dataDigitada = DateTime(ano, mes, dia);
      } else {
        throw Exception("Formato de data inválido.");
      }

      // Valida na Regra de Negócio
      _service.cadastrar(_rotaCtrl.text, dataDigitada, precoDigitado);
      
      // SUCESSO
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✔️ Viagem disponibilizada na plataforma com sucesso!'), 
        backgroundColor: Colors.green,
      ));
      
      // Limpa os campos após o sucesso
      _rotaCtrl.clear();
      _dataCtrl.clear();
      _precoCtrl.clear();

    } catch (e) {
      // ERRO
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('❌ ${e.toString().replaceAll("Exception: ", "")}'), 
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.anchor, size: 60, color: Color(0xFF023E8A)),
                const SizedBox(height: 16),
                const Text('Disponibilizar Rota', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF023E8A))),
                const SizedBox(height: 30),
                
                TextField(
                  controller: _rotaCtrl, 
                  decoration: const InputDecoration(labelText: 'Rota (ex: Manaus -> Tefé)', prefixIcon: Icon(Icons.map))
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: _dataCtrl, 
                  keyboardType: TextInputType.number,
                  inputFormatters: [_mascaraData], // Injeta a máscara
                  decoration: const InputDecoration(labelText: 'Data de Saída', hintText: 'DD/MM/AAAA', prefixIcon: Icon(Icons.calendar_month))
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: _precoCtrl, 
                  keyboardType: TextInputType.numberWithOptions(decimal: true), 
                  decoration: const InputDecoration(labelText: 'Valor do Bilhete (R\$)', prefixIcon: Icon(Icons.monetization_on))
                ),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20)),
                  onPressed: _executarCadastro,
                  child: const Text('CADASTRAR VIAGEM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
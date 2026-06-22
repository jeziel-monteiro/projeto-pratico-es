import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../src/busca_viagens_service.dart';

class BuscaViagemTela extends StatefulWidget {
  const BuscaViagemTela({super.key});

  @override
  State<BuscaViagemTela> createState() => _BuscaViagemTelaState();
}

class _BuscaViagemTelaState extends State<BuscaViagemTela> {
  final _origemCtrl = TextEditingController();
  final _destinoCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final _service = BuscaViagemService();

  // CRIANDO A MÁSCARA DE DATA (##/##/####)
  final _mascaraData = MaskTextInputFormatter(
    mask: '##/##/####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  void _executarBusca() {
    try {
      final viagens = _service.buscar(_origemCtrl.text, _destinoCtrl.text, _dataCtrl.text);
      
      // Caso 5: Data no passado (Lista vazia retornada)
      if (viagens.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ℹ️ A busca foi processada, mas não há viagens listadas para esta data.'), 
          backgroundColor: Colors.orange,
        ));
      } 
      // Caso 4: Viagem esgotada (0 vagas)
      else if (viagens.first.vagasDisponiveis == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('⚠️ Viagens para esta data estão esgotadas.'), 
          backgroundColor: Colors.orange,
        ));
      } 
      // Caso 1: Sucesso total
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('✔️ Busca realizada com sucesso! ${viagens.first.vagasDisponiveis} vagas para ${viagens.first.destino}.'), 
          backgroundColor: Colors.green,
        ));
      }

    } catch (e) {
      // Casos 2 e 3: Erros de validação
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
                const Icon(Icons.map_outlined, size: 60, color: Color(0xFF023E8A)),
                const SizedBox(height: 16),
                const Text('Encontre sua Viagem', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF023E8A))),
                const SizedBox(height: 30),
                TextField(controller: _origemCtrl, decoration: const InputDecoration(labelText: 'Origem (ex: Manaus)', prefixIcon: Icon(Icons.location_on))),
                const SizedBox(height: 16),
                TextField(controller: _destinoCtrl, decoration: const InputDecoration(labelText: 'Destino (ex: Parintins)', prefixIcon: Icon(Icons.flag))),
                const SizedBox(height: 16),
                
                // CAMPO DE DATA COM A MÁSCARA APLICADA
                TextField(
                  controller: _dataCtrl, 
                  keyboardType: TextInputType.number, // Abre o teclado numérico no celular
                  inputFormatters: [_mascaraData], // Injeta a formatação
                  decoration: const InputDecoration(
                    labelText: 'Data da Viagem', 
                    hintText: 'DD/MM/AAAA', // Texto de ajuda
                    prefixIcon: Icon(Icons.calendar_today)
                  )
                ),
                
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20)),
                  onPressed: _executarBusca,
                  child: const Text('BUSCAR PASSAGENS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
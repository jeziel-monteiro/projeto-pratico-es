// lib/telas/cadastro_viagem_tela.dart
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../src/cadastro_viagem_service.dart';

class CadastroViagemTela extends StatefulWidget {
  const CadastroViagemTela({super.key});

  @override
  State<CadastroViagemTela> createState() => _CadastroViagemTelaState();
}

class _CadastroViagemTelaState extends State<CadastroViagemTela> {
  final _origemCtrl = TextEditingController();
  final _destinoCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final _horarioCtrl = TextEditingController();
  final _assentosCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();
  
  final _service = CadastroViagemService();

  // Variáveis de Estado para os Menus de Seleção
  String _embarcacaoSelecionada = '';
  String _tipoViagem = 'Única';
  final List<String> _diasSelecionados = [];

  // Máscaras Visuais
  final _mascaraData = MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });
  final _mascaraHora = MaskTextInputFormatter(mask: '##:##', filter: { "#": RegExp(r'[0-9]') });

  final List<String> _diasDaSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  void _executarCadastro() {
    try {
      int assentos = int.tryParse(_assentosCtrl.text) ?? 0;
      double preco = double.tryParse(_precoCtrl.text.replaceAll(',', '.')) ?? 0.0;

      // Chama o "Cérebro" do sistema
      _service.cadastrarViagem(
        embarcacaoId: _embarcacaoSelecionada,
        origem: _origemCtrl.text,
        destino: _destinoCtrl.text,
        dataStr: _dataCtrl.text,
        horarioStr: _horarioCtrl.text,
        tipoViagem: _tipoViagem,
        diasSemana: _diasSelecionados,
        assentosVenda: assentos,
        preco: preco,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✔️ Viagem homologada e disponível para venda!'), 
        backgroundColor: Colors.green,
      ));
    } catch (e) {
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
                const Text('Nova Rota Comercial', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF023E8A))),
                const SizedBox(height: 30),
                
                // SELEÇÃO DE EMBARCAÇÃO (Simulando busca no BD)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Selecione a Embarcação', prefixIcon: Icon(Icons.directions_boat)),
                  value: _embarcacaoSelecionada.isEmpty ? null : _embarcacaoSelecionada,
                  items: const [
                    DropdownMenuItem(value: 'e1', child: Text('Expresso Tapajós (50 lugares)')),
                    DropdownMenuItem(value: 'e2', child: Text('Cisne Branco (120 lugares)')),
                  ],
                  onChanged: (value) => setState(() => _embarcacaoSelecionada = value!),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(child: TextField(controller: _origemCtrl, decoration: const InputDecoration(labelText: 'Origem'))),
                    const SizedBox(width: 16),
                    Expanded(child: TextField(controller: _destinoCtrl, decoration: const InputDecoration(labelText: 'Destino'))),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: TextField(controller: _dataCtrl, inputFormatters: [_mascaraData], keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Data Inicial', hintText: 'DD/MM/AAAA', prefixIcon: Icon(Icons.calendar_month)))),
                    const SizedBox(width: 16),
                    Expanded(child: TextField(controller: _horarioCtrl, inputFormatters: [_mascaraHora], keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Horário', hintText: 'HH:MM', prefixIcon: Icon(Icons.access_time)))),
                  ],
                ),
                const SizedBox(height: 16),

                // TIPO DE VIAGEM E DIAS DA SEMANA
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Frequência da Viagem', prefixIcon: Icon(Icons.repeat)),
                  value: _tipoViagem,
                  items: const [
                    DropdownMenuItem(value: 'Única', child: Text('Viagem Única (Não se repete)')),
                    DropdownMenuItem(value: 'Recorrente', child: Text('Viagem Recorrente (Semanal)')),
                  ],
                  onChanged: (value) => setState(() => _tipoViagem = value!),
                ),
                
                // SÓ MOSTRA OS DIAS SE FOR RECORRENTE
                if (_tipoViagem == 'Recorrente') ...[
                  const Padding(padding: EdgeInsets.only(top: 16.0, bottom: 8.0), child: Text('Dias da Semana:', style: TextStyle(fontWeight: FontWeight.bold))),
                  Wrap(
                    spacing: 8.0,
                    children: _diasDaSemana.map((dia) {
                      return FilterChip(
                        label: Text(dia),
                        selected: _diasSelecionados.contains(dia),
                        onSelected: (selecionado) {
                          setState(() { selecionado ? _diasSelecionados.add(dia) : _diasSelecionados.remove(dia); });
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: TextField(controller: _assentosCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Assentos à Venda', prefixIcon: Icon(Icons.airline_seat_recline_normal)))),
                    const SizedBox(width: 16),
                    Expanded(child: TextField(controller: _precoCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Preço (R\$)', prefixIcon: Icon(Icons.monetization_on)))),
                  ],
                ),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20)),
                  onPressed: _executarCadastro,
                  child: const Text('DISPONIBILIZAR PASSAGENS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// lib/telas/cadastro_viajante_tela.dart
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // PACOTE DA MÁSCARA
import '../src/cadastro_viajante_service.dart';
import 'verificacao_codigo_tela.dart';

class CadastroViajanteTela extends StatefulWidget {
  const CadastroViajanteTela({super.key});

  @override
  State<CadastroViajanteTela> createState() => _CadastroViajanteTelaState();
}

class _CadastroViajanteTelaState extends State<CadastroViajanteTela> {
  final _nomeCtrl = TextEditingController();
  final _sobrenomeCtrl = TextEditingController();
  final _contatoCtrl = TextEditingController();
  final _dataNascimentoCtrl = TextEditingController(); // Alterado para Data de Nascimento
  final _senhaCtrl = TextEditingController();
  final _confirmacaoCtrl = TextEditingController();
  final _service = CadastroViajanteService();

  // CRIANDO A MÁSCARA DE DATA DE NASCIMENTO (IGUAL À BUSCA)
  final _mascaraDataNasc = MaskTextInputFormatter(
    mask: '##/##/####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  void _executarCadastro() {
    try {
      _service.completarCadastro(
        _nomeCtrl.text, _sobrenomeCtrl.text, _contatoCtrl.text, 
        _dataNascimentoCtrl.text, _senhaCtrl.text, _confirmacaoCtrl.text
      );
      
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VerificacaoCodigoTela(contato: _contatoCtrl.text),
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
                const Icon(Icons.person_add_alt_1, size: 60, color: Color(0xFF023E8A)),
                const SizedBox(height: 16),
                const Text('Criar Conta - Viajante', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF023E8A))),
                const SizedBox(height: 30),
                
                Row(
                  children: [
                    Expanded(child: TextField(controller: _nomeCtrl, decoration: const InputDecoration(labelText: 'Nome'))),
                    const SizedBox(width: 16),
                    Expanded(child: TextField(controller: _sobrenomeCtrl, decoration: const InputDecoration(labelText: 'Sobrenome'))),
                  ],
                ),
                const SizedBox(height: 16),
                
                // NOVO CAMPO COM MÁSCARA AUTOMÁTICA DE BARRAS
                TextField(
                  controller: _dataNascimentoCtrl, 
                  keyboardType: TextInputType.number,
                  inputFormatters: [_mascaraDataNasc], // Adiciona o formatador automático
                  decoration: const InputDecoration(
                    labelText: 'Data de Nascimento', 
                    hintText: 'DD/MM/AAAA',
                    prefixIcon: Icon(Icons.cake)
                  )
                ),
                const SizedBox(height: 16),
                
                TextField(controller: _contatoCtrl, decoration: const InputDecoration(labelText: 'E-mail ou Telefone (com DDD)', prefixIcon: Icon(Icons.contact_mail))),
                const SizedBox(height: 16),
                TextField(controller: _senhaCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Senha Segura', prefixIcon: Icon(Icons.lock))),
                const SizedBox(height: 16),
                TextField(controller: _confirmacaoCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar Senha', prefixIcon: Icon(Icons.lock_outline))),
                
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20)),
                  onPressed: _executarCadastro,
                  child: const Text('AVANÇAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
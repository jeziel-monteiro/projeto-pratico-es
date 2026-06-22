// lib/telas/verificacao_codigo_tela.dart
import 'package:flutter/material.dart';

class VerificacaoCodigoTela extends StatefulWidget {
  final String contato;
  const VerificacaoCodigoTela({super.key, required this.contato});

  @override
  State<VerificacaoCodigoTela> createState() => _VerificacaoCodigoTelaState();
}

class _VerificacaoCodigoTelaState extends State<VerificacaoCodigoTela> {
  final _codigoCtrl = TextEditingController();

  void _validarCodigo() {
    // Classes 7 e 8: Validação do Código Mockado
    if (_codigoCtrl.text == '123456') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✔️ Conta verificada e ativada com sucesso! Bem-vindo ao Porto Certo.'),
        backgroundColor: Colors.green,
      ));
      // Retorna para a tela inicial
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('❌ Código incorreto ou expirado. Tente novamente.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificação de Segurança', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF023E8A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0FBFC), Color(0xFFCAF0F8)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
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
                    const Icon(Icons.security, size: 60, color: Color(0xFF023E8A)),
                    const SizedBox(height: 16),
                    Text(
                      'Enviamos um código para\n${widget.contato}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _codigoCtrl,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(labelText: 'Código de 6 dígitos', counterText: ''),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20)),
                      onPressed: _validarCodigo,
                      child: const Text('VALIDAR CÓDIGO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aguarde 60 segundos para reenviar o código.'), backgroundColor: Colors.orange));
                      },
                      child: const Text('Reenviar código (00:59)', style: TextStyle(color: Colors.grey)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
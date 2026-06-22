import 'package:flutter/material.dart';

import 'telas/busca_viagem_tela.dart';
import 'telas/cadastro_viajante_tela.dart';
import 'telas/cadastro_viagem_tela.dart';

void main() {
  runApp(const PortoCertoApp());
}

class PortoCertoApp extends StatelessWidget {
  const PortoCertoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Porto Certo',
      debugShowCheckedModeBanner: false,
      // TEMA NÁUTICO PREMIUM
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF023E8A), // Azul Marinho
          primary: const Color(0xFF023E8A),
          secondary: const Color(0xFF00B4D8), // Ciano
        ),
        useMaterial3: true,
        // Estilo global das caixas de texto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: const Color(0xFF00B4D8),
        ),
        // Estilo global dos botões
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B4D8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
        ),
      ),
      home: const NavegacaoPrincipal(),
    );
  }
}

class NavegacaoPrincipal extends StatefulWidget {
  const NavegacaoPrincipal({super.key});

  @override
  State<NavegacaoPrincipal> createState() => _NavegacaoPrincipalState();
}

class _NavegacaoPrincipalState extends State<NavegacaoPrincipal> {
  int _indiceAtual = 0;

  final List<Widget> _telas = [
    const BuscaViagemTela(),
    const CadastroViajanteTela(),
    const CadastroViagemTela(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.directions_boat, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text('PORTO CERTO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ],
        ),
        backgroundColor: const Color(0xFF023E8A),
        elevation: 10,
        centerTitle: true,
      ),
      // Fundo Degradê Náutico
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0FBFC), Color(0xFFCAF0F8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _telas[_indiceAtual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) => setState(() => _indiceAtual = index),
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF023E8A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar Viagens'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Viajante'),
          BottomNavigationBarItem(icon: Icon(Icons.anchor), label: 'Proprietário'),
        ],
      ),
    );
  }
}
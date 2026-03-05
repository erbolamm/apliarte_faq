import 'package:apliarte_faq/apliarte_faq.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalcaApp Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C5CE7),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CalcaApp'), centerTitle: true),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate_rounded, size: 80, color: Color(0xFF6C5CE7)),
            SizedBox(height: 16),
            Text(
              'CalcaApp',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Toca el botón 💬 para probar el asistente',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
      // ¡Así de fácil! Una línea para integrar el FAQ
      floatingActionButton: const ApliFaqButton(
        markdownAsset: 'assets/ayuda.md',
        appName: 'CalcaApp',
        themeColor: Color(0xFF6C5CE7),
      ),
    );
  }
}

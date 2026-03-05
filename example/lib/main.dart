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
      body: Stack(
        children: [
          // Contenido central
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calculate_rounded,
                  size: 80,
                  color: Color(0xFF6C5CE7),
                ),
                SizedBox(height: 16),
                Text(
                  'CalcaApp',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '¿Tienes dudas?',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
          // Flecha animada apuntando al FAB
          const Positioned(right: 24, bottom: 90, child: _AnimatedArrow()),
        ],
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

/// Flecha animada que apunta al FAB con texto "Toca aquí"
class _AnimatedArrow extends StatefulWidget {
  const _AnimatedArrow();

  @override
  State<_AnimatedArrow> createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<_AnimatedArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Toca aquí 👇',
                  style: TextStyle(
                    color: Color(0xFF6C5CE7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_downward_rounded,
                color: Color(0xFF6C5CE7),
                size: 28,
              ),
            ],
          ),
        );
      },
    );
  }
}

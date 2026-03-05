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
      title: 'apliarte_faq — Ejemplo',
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
      appBar: AppBar(
        title: const Text('apliarte_faq'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Icon(Icons.chat_rounded, size: 64, color: Color(0xFF6C5CE7)),
          const SizedBox(height: 12),
          const Text(
            'apliarte_faq',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Asistente FAQ offline para Flutter',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 15),
          ),
          const SizedBox(height: 24),

          // Sección: Uso básico
          const _SectionHeader(
            icon: Icons.rocket_launch_rounded,
            title: 'Uso básico',
            subtitle: 'ApliFaqButton con parámetros mínimos',
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Solo markdownAsset + appName',
            code: 'ApliFaqButton(\n'
                '  markdownAsset: \'assets/ayuda.md\',\n'
                '  appName: \'MiApp\',\n'
                ')',
            onTap: () => _navigateTo(
              context,
              'Uso básico',
              const ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sección: themeColor
          const _SectionHeader(
            icon: Icons.palette_rounded,
            title: 'themeColor',
            subtitle: 'Cambiar color con un solo parámetro',
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Color azul',
            code: 'ApliFaqButton(\n'
                '  markdownAsset: \'assets/ayuda.md\',\n'
                '  appName: \'MiApp\',\n'
                '  themeColor: Colors.blue,\n'
                ')',
            onTap: () => _navigateTo(
              context,
              'themeColor: azul',
              const ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
                themeColor: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Color verde',
            code: 'themeColor: Colors.teal',
            onTap: () => _navigateTo(
              context,
              'themeColor: verde',
              const ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
                themeColor: Colors.teal,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Color rojo',
            code: 'themeColor: Colors.redAccent',
            onTap: () => _navigateTo(
              context,
              'themeColor: rojo',
              const ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
                themeColor: Colors.redAccent,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sección: sheetHeight
          const _SectionHeader(
            icon: Icons.height_rounded,
            title: 'sheetHeight',
            subtitle: 'Controlar la altura del bottom sheet',
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Altura 50% (0.5)',
            code: 'sheetHeight: 0.5',
            onTap: () => _navigateTo(
              context,
              'sheetHeight: 0.5',
              const ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
                sheetHeight: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Altura 95% (0.95)',
            code: 'sheetHeight: 0.95',
            onTap: () => _navigateTo(
              context,
              'sheetHeight: 0.95',
              const ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
                sheetHeight: 0.95,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sección: Tema oscuro
          const _SectionHeader(
            icon: Icons.dark_mode_rounded,
            title: 'ApliFaqTheme.dark()',
            subtitle: 'Tema oscuro predefinido',
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Tema oscuro',
            code: 'theme: ApliFaqTheme.dark()',
            onTap: () => _navigateTo(
              context,
              'Tema oscuro',
              ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
                theme: ApliFaqTheme.dark(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Oscuro + copyWith',
            code: 'theme: ApliFaqTheme.dark().copyWith(\n'
                '  primaryColor: Colors.cyan,\n'
                '  greetingText: \'Modo oscuro 🌙\',\n'
                ')',
            onTap: () => _navigateTo(
              context,
              'Oscuro + copyWith',
              ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
                theme: ApliFaqTheme.dark().copyWith(
                  primaryColor: Colors.cyan,
                  greetingText:
                      '¡Modo oscuro activado! 🌙 ¿En qué puedo ayudarte?',
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sección: Tema personalizado completo
          const _SectionHeader(
            icon: Icons.brush_rounded,
            title: 'ApliFaqTheme personalizado',
            subtitle: 'Control total del aspecto visual',
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Tema rosa + icono custom',
            code: 'theme: ApliFaqTheme(\n'
                '  primaryColor: Colors.pink,\n'
                '  bubbleRadius: 24.0,\n'
                '  fabIcon: Icons.help_outline,\n'
                '  hintText: \'¿Tienes alguna duda?\',\n'
                '  greetingText: \'¡Hey! 👋\',\n'
                ')',
            onTap: () => _navigateTo(
              context,
              'Tema personalizado',
              const ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
                theme: ApliFaqTheme(
                  primaryColor: Colors.pink,
                  userBubbleColor: Colors.pink,
                  bubbleRadius: 24.0,
                  fabIcon: Icons.help_outline,
                  hintText: '¿Tienes alguna duda?',
                  greetingText: '¡Hey! 👋 Pregúntame sobre el paquete.',
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Tema naranja profesional',
            code: 'theme: ApliFaqTheme(\n'
                '  primaryColor: Colors.deepOrange,\n'
                '  backgroundColor: Color(0xFFFFF3E0),\n'
                '  assistantBubbleColor: Color(0xFFFFE0B2),\n'
                '  fabIcon: Icons.support_agent,\n'
                ')',
            onTap: () => _navigateTo(
              context,
              'Tema naranja',
              const ApliFaqButton(
                markdownAsset: 'assets/ayuda.md',
                appName: 'apliarte_faq',
                theme: ApliFaqTheme(
                  primaryColor: Colors.deepOrange,
                  userBubbleColor: Colors.deepOrange,
                  backgroundColor: Color(0xFFFFF3E0),
                  assistantBubbleColor: Color(0xFFFFE0B2),
                  assistantTextColor: Color(0xFF4E342E),
                  fabIcon: Icons.support_agent,
                  greetingText: '¡Hola! Soy tu soporte técnico. 🔧',
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sección: FaqEngine directo
          const _SectionHeader(
            icon: Icons.engineering_rounded,
            title: 'FaqEngine directo',
            subtitle: 'Usar el motor sin el widget de chat',
          ),
          const SizedBox(height: 8),
          _DemoCard(
            title: 'Chat embebido en pantalla completa',
            code: 'FaqEngine.fromAsset(\'assets/ayuda.md\')\n'
                '→ ApliFaqChat(engine: engine, ...)',
            onTap: () => _navigateToEngineDemo(context),
          ),

          const SizedBox(height: 32),

          // Footer
          Text(
            'Creado por Javier Mateo (erbolamm)\nApliArte.com · España · 2026',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const SizedBox(height: 16),
        ],
      ),
      // Botón FAQ por defecto para probar directamente
      floatingActionButton: const ApliFaqButton(
        markdownAsset: 'assets/ayuda.md',
        appName: 'apliarte_faq',
        themeColor: Color(0xFF6C5CE7),
      ),
    );
  }

  void _navigateTo(BuildContext context, String title, Widget fab) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _DemoScreen(title: title, fab: fab),
      ),
    );
  }

  void _navigateToEngineDemo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _EngineDirectScreen()),
    );
  }
}

// --- Pantalla de demo genérica ---

class _DemoScreen extends StatelessWidget {
  final String title;
  final Widget fab;

  const _DemoScreen({required this.title, required this.fab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app_rounded,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Toca el botón para ver\nesta configuración en acción',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: fab,
    );
  }
}

// --- Pantalla con FaqEngine + ApliFaqChat embebido ---

class _EngineDirectScreen extends StatefulWidget {
  const _EngineDirectScreen();

  @override
  State<_EngineDirectScreen> createState() => _EngineDirectScreenState();
}

class _EngineDirectScreenState extends State<_EngineDirectScreen> {
  FaqEngine? _engine;

  @override
  void initState() {
    super.initState();
    _loadEngine();
  }

  Future<void> _loadEngine() async {
    final engine = await FaqEngine.fromAsset('assets/ayuda.md');
    if (mounted) setState(() => _engine = engine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FaqEngine directo'),
        actions: [
          if (_engine != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                label: Text('${_engine!.sectionCount} secciones'),
                avatar: const Icon(Icons.article_rounded, size: 18),
              ),
            ),
        ],
      ),
      body: _engine == null
          ? const Center(child: CircularProgressIndicator())
          : ApliFaqChat(
              engine: _engine!,
              appName: 'apliarte_faq',
              theme: const ApliFaqTheme(
                primaryColor: Color(0xFF00B894),
                userBubbleColor: Color(0xFF00B894),
                greetingText: '¡Chat embebido directamente en la pantalla! '
                    'Pregúntame sobre el paquete apliarte_faq.',
              ),
            ),
    );
  }
}

// --- Widgets auxiliares ---

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6C5CE7), size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String code;
  final VoidCallback onTap;

  const _DemoCard({
    required this.title,
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Color(0xFF2D3436),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

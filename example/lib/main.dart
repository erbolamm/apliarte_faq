import 'package:flutter/material.dart';
import 'package:apliarte_faq/apliarte_faq.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const FaqShowcaseApp());

class FaqShowcaseApp extends StatelessWidget {
  const FaqShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'apliarte_faq',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const ShowcaseHome(),
    );
  }

  ThemeData _theme(Brightness b) => ThemeData(
    useMaterial3: true,
    brightness: b,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C5CE7),
      brightness: b,
    ),
    textTheme: GoogleFonts.interTextTheme(
      b == Brightness.dark ? ThemeData.dark().textTheme : null,
    ),
    scaffoldBackgroundColor:
        b == Brightness.dark ? const Color(0xFF0F0F1A) : const Color(0xFFF8F9FC),
  );
}

// ─────────────────────────────────────────────────────────────
// SECTIONS
// ─────────────────────────────────────────────────────────────

enum Section {
  overview('Inicio', Icons.home_rounded),
  features('Características', Icons.star_rounded),
  usage('Cómo usar', Icons.code_rounded);

  final String label;
  final IconData icon;
  const Section(this.label, this.icon);
}

// ─────────────────────────────────────────────────────────────
// HOME
// ─────────────────────────────────────────────────────────────

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({super.key});

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),
      destinations: [
        for (final s in Section.values)
          NavigationDestination(icon: Icon(s.icon), label: s.label),
      ],
      smallBody: (_) => _body(context),
      body: (_) => _body(context),
      largeBody: (_) => _body(context),
    );
  }

  Widget _body(BuildContext context) => _SectionPage(section: Section.values[_selectedIndex]);
}

class _SectionPage extends StatelessWidget {
  final Section section;
  const _SectionPage({required this.section});

  @override
  Widget build(BuildContext context) {
    switch (section) {
      case Section.overview: return const _OverviewPage();
      case Section.features: return const _FeaturesPage();
      case Section.usage: return const _UsagePage();
    }
  }
}

// ─────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  final Section section;
  const _PageHeader(this.section);
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: t.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(section.icon, color: t.colorScheme.primary, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(section.label,
              style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          Text(_subtitle(section),
              style: TextStyle(color: t.colorScheme.onSurface.withValues(alpha: 0.5))),
        ]),
      ),
      _ThemeToggle(),
    ]);
  }

  String _subtitle(Section s) {
    switch (s) {
      case Section.overview: return 'FAQ offline para Flutter';
      case Section.features: return '100% offline, sin IA, cero dependencias';
      case Section.usage: return 'Integración en 3 líneas';
    }
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isDark
            ? const Icon(Icons.light_mode, key: ValueKey('l'))
            : const Icon(Icons.dark_mode, key: ValueKey('d')),
      ),
      tooltip: isDark ? 'Modo claro' : 'Modo oscuro',
      onPressed: () => _rebuild(context, isDark ? ThemeMode.light : ThemeMode.dark),
    );
  }

  void _rebuild(BuildContext context, ThemeMode mode) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => MaterialApp(
          title: 'apliarte_faq', debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true, brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7), brightness: Brightness.light),
            textTheme: GoogleFonts.interTextTheme(),
            scaffoldBackgroundColor: const Color(0xFFF8F9FC),
          ),
          darkTheme: ThemeData(
            useMaterial3: true, brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7), brightness: Brightness.dark),
            textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
            scaffoldBackgroundColor: const Color(0xFF0F0F1A),
          ),
          themeMode: mode,
          home: const ShowcaseHome(),
        ),
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}

Widget _page(BuildContext context, Section s, List<Widget> children) => SingleChildScrollView(
  padding: const EdgeInsets.all(32),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _PageHeader(s),
    const SizedBox(height: 28),
    ...children,
    const SizedBox(height: 48),
  ]),
);

Widget _featureRow(String text, IconData icon) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 6),
  child: Row(children: [
    Icon(icon, size: 20, color: const Color(0xFF6C5CE7)),
    const SizedBox(width: 12),
    Text(text, style: const TextStyle(fontSize: 15)),
  ]),
);

// ─────────────────────────────────────────────────────────────
// 0 — OVERVIEW
// ─────────────────────────────────────────────────────────────

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _PageHeader(Section.overview),
        const SizedBox(height: 28),
        // Hero
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(40, 48, 40, 40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF2D1B69), const Color(0xFF0F0F1A)]
                  : [const Color(0xFF6C5CE7), const Color(0xFF5A4BD1), const Color(0xFF1A1A2E)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: [
            Icon(Icons.quiz_rounded, size: 56, color: Colors.white.withValues(alpha: 0.9)),
            const SizedBox(height: 16),
            const Text('apliarte_faq',
                style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Asistente FAQ offline para apps Flutter',
                style: TextStyle(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('100% offline · Sin IA · Cero dependencias · 17 idiomas',
                style: TextStyle(color: Colors.white60, fontSize: 13), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
              _badge('v1.0.5', const Color(0xFF22C55E)),
              _badge('Offline', const Color(0xFF6366F1)),
              _badge('17 idiomas', const Color(0xFFF59E0B)),
              _badge('TF-IDF', const Color(0xFF8B5CF6)),
              _badge('MIT', const Color(0xFFEC4899)),
            ]),
          ]),
        ),
        const SizedBox(height: 32),
        // Features cards
        Text('¿Qué es?',
            style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('Un widget que añade un botón de ayuda flotante. El usuario toca y busca '
            'respuestas en un archivo .md local. Sin servidores, sin APIs, sin internet.',
            style: TextStyle(color: t.colorScheme.onSurface.withValues(alpha: 0.5))),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _MiniCard(Icons.offline_bolt, '100% Offline', 'Sin internet ni servidores')),
          const SizedBox(width: 12),
          Expanded(child: _MiniCard(Icons.privacy_tip, 'Privacidad total', 'Los datos nunca salen del dispositivo')),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _MiniCard(Icons.language, '17 idiomas', 'UI y búsqueda multilingüe')),
          const SizedBox(width: 12),
          Expanded(child: _MiniCard(Icons.auto_fix_high, 'TF-IDF', 'Fuzzy matching + acentos')),
        ]),
        // Demo en vivo
        const SizedBox(height: 32),
        Text('Demo en vivo',
            style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('Probá el botón FAQ flotante que aparece abajo a la derecha.',
            style: TextStyle(color: t.colorScheme.onSurface.withValues(alpha: 0.5))),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: _DemoFrame(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_rounded, size: 48, color: t.colorScheme.primary.withValues(alpha: 0.3)),
                      const SizedBox(height: 8),
                      const Text('Contenido de la app', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const Positioned(
                  right: 16,
                  bottom: 80,
                  child: ApliFaqButton(
                    markdownAsset: 'assets/ayuda.md',
                    appName: 'Demo App',
                    themeColor: Color(0xFF6C5CE7),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Share + Support + Footer
        const SizedBox(height: 48), _ShareSection(),
        const SizedBox(height: 48), _SupportSection(),
        const SizedBox(height: 48), _FooterSection(),
        const SizedBox(height: 48),
      ]),
    );
  }

  Widget _badge(String l, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: c.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.withValues(alpha: 0.3), width: 0.5),
    ),
    child: Text(l, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}

class _MiniCard extends StatelessWidget {
  final IconData icon; final String title, subtitle;
  const _MiniCard(this.icon, this.title, this.subtitle);
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: const Color(0xFF6C5CE7)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ]),
    ),
  );
}

class _DemoFrame extends StatelessWidget {
  final Widget child;
  const _DemoFrame({required this.child});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.dividerColor),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: child),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 1 — FEATURES
// ─────────────────────────────────────────────────────────────

class _FeaturesPage extends StatelessWidget {
  const _FeaturesPage();
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return _page(context, Section.features, [
      Card(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Características', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _featureRow('100% offline — Sin internet ni servidores externos', Icons.offline_bolt),
          _featureRow('Cero dependencias — Solo Flutter, nada más', Icons.clean_hands),
          _featureRow('Privacidad total — Datos nunca salen del dispositivo', Icons.privacy_tip),
          _featureRow('Motor TF-IDF — Búsqueda inteligente con fuzzy matching', Icons.auto_fix_high),
          _featureRow('Markdown renderer — Texto formateado con negritas, bullets, código', Icons.article),
          _featureRow('17 idiomas — UI y stopwords traducidos', Icons.language),
          _featureRow('Personalizable — Colores, textos, tema claro/oscuro', Icons.palette),
        ]),
      )),
      const SizedBox(height: 16),
      Card(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Idiomas soportados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _langChip('🇪🇸 Español'), _langChip('🇬🇧 English'), _langChip('🇫🇷 Français'),
            _langChip('🇩🇪 Deutsch'), _langChip('🇧🇷 Português'), _langChip('🇮🇹 Italiano'),
            _langChip('🇷🇺 Русский'), _langChip('🇨🇳 中文'), _langChip('🇯🇵 日本語'),
            _langChip('🇰🇷 한국어'), _langChip('🇸🇦 العربية'), _langChip('🇮🇳 हिन्दी'),
            _langChip('🇹🇷 Türkçe'), _langChip('🇵🇱 Polski'), _langChip('🇻🇳 Tiếng Việt'),
            _langChip('🇮🇩 Bahasa'), _langChip('🇮🇷 فارسی'),
          ]),
        ]),
      )),
    ]);
  }

  Widget _langChip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: const TextStyle(fontSize: 13)),
  );
}

// ─────────────────────────────────────────────────────────────
// 2 — HOW TO USE
// ─────────────────────────────────────────────────────────────

class _UsagePage extends StatelessWidget {
  const _UsagePage();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _page(context, Section.usage, [
      Card(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Instalación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _CodeLine(r"flutter pub add apliarte_faq"),
            ]),
          ),
        ]),
      )),
      const SizedBox(height: 16),
      Card(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Uso básico', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _CodeLine(r"import 'package:apliarte_faq/apliarte_faq.dart';"),
              _CodeLine(''),
              _CodeLine("// Agregalo como FAB:"),
              _CodeLine("Scaffold("),
              _CodeLine("  floatingActionButton: ApliFaqButton("),
              _CodeLine("    markdownAsset: 'assets/ayuda.md',"),
              _CodeLine("    appName: 'Mi App',"),
              _CodeLine("  ),"),
              _CodeLine(")"),
            ]),
          ),
          const SizedBox(height: 12),
          const Text('Creá un archivo `assets/ayuda.md` con tus FAQs en formato Markdown.',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
        ]),
      )),
      const SizedBox(height: 16),
      Card(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Personalización', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _CodeLine("ApliFaqButton("),
              _CodeLine("  markdownAsset: 'assets/ayuda.md',"),
              _CodeLine("  appName: 'Mi App',"),
              _CodeLine("  themeColor: Color(0xFF6C5CE7), // color primario"),
              _CodeLine("  // Tema claro/oscuro automático"),
              _CodeLine(")"),
            ]),
          ),
        ]),
      )),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          icon: const Icon(Icons.open_in_new),
          label: const Text('Ver en GitHub'),
          onPressed: () => launchUrl(Uri.parse('https://github.com/erbolamm/apliarte_faq')),
        ),
      ),
    ]);
  }
}

class _CodeLine extends StatelessWidget {
  final String text;
  const _CodeLine(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(
    fontFamily: 'monospace', fontSize: 13, color: Color(0xFFA6E3A1), height: 1.6,
  ));
}

// ─────────────────────────────────────────────────────────────
// SHARE · SUPPORT · FOOTER
// ─────────────────────────────────────────────────────────────

const _shareUrl = 'https://pub.dev/packages/apliarte_faq';
const _shareText = 'apliarte_faq%20%E2%80%94%20Asistente%20FAQ%20offline%20para%20Flutter.%20100%25%20offline%2C%20sin%20IA%2C%20sin%20dependencias.';

class _ShareSection extends StatelessWidget {
  const _ShareSection();
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Comparte', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Text('Ayudá a que más gente lo conozca.',
          style: TextStyle(color: t.colorScheme.onSurface.withValues(alpha: 0.5))),
      const SizedBox(height: 24),
      Wrap(spacing: 12, runSpacing: 12, children: [
        _ShareBtn('𝕏 Twitter', 'https://twitter.com/intent/tweet?text=$_shareText&url=$_shareUrl'),
        _ShareBtn('💼 LinkedIn', 'https://www.linkedin.com/sharing/share-offsite/?url=$_shareUrl'),
        _ShareBtn('🟠 Reddit', 'https://www.reddit.com/submit?url=$_shareUrl&title=apliarte_faq'),
        _ShareBtn('💬 WhatsApp', 'https://api.whatsapp.com/send?text=$_shareText%20$_shareUrl'),
      ]),
    ]);
  }
}

class _ShareBtn extends StatelessWidget {
  final String label, url;
  const _ShareBtn(this.label, this.url);
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    icon: const Icon(Icons.open_in_new, size: 16), label: Text(label),
    onPressed: () => launchUrl(Uri.parse(url)),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      side: BorderSide(color: Theme.of(context).dividerColor),
    ),
  );
}

class _SupportSection extends StatelessWidget {
  const _SupportSection();
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Apoya el proyecto', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Text('Herramienta gratuita y open source. Si te ahorra tiempo, un café ayuda.',
          style: TextStyle(color: t.colorScheme.onSurface.withValues(alpha: 0.5))),
      const SizedBox(height: 24),
      Wrap(spacing: 12, runSpacing: 12, children: [
        _SupportBtn('PayPal', Icons.payment, 'https://paypal.me/erbolamm'),
        _SupportBtn('Ko-fi', Icons.coffee, 'https://ko-fi.com/C0C11TWR1K'),
        _SupportBtn('Twitch Tip', Icons.live_tv, 'https://streamelements.com/apliarte/tip'),
      ]),
    ]);
  }
}

class _SupportBtn extends StatelessWidget {
  final String label, url; final IconData icon;
  const _SupportBtn(this.label, this.icon, this.url);
  @override
  Widget build(BuildContext context) => FilledButton.tonalIcon(
    icon: Icon(icon, size: 18), label: Text(label),
    onPressed: () => launchUrl(Uri.parse(url)),
  );
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: t.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Text('v1.0.5  ·  Hecho por Javier Mateo (ApliArte)',
            textAlign: TextAlign.center,
            style: TextStyle(color: t.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13)),
        const SizedBox(height: 8),
        Wrap(spacing: 16, runSpacing: 8, alignment: WrapAlignment.center, children: [
          _footerBtn('GitHub', 'https://github.com/erbolamm/apliarte_faq'),
          _footerBtn('pub.dev', 'https://pub.dev/packages/apliarte_faq'),
          _footerBtn('apliarte.com', 'https://apliarte.com'),
          _footerBtn('MIT License', 'https://github.com/erbolamm/apliarte_faq/blob/main/LICENSE'),
        ]),
      ]),
    );
  }
}

Widget _footerBtn(String label, String url) => TextButton(
  onPressed: () => launchUrl(Uri.parse(url)),
  child: Text(label, style: const TextStyle(fontSize: 13)),
);

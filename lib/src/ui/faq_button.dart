import 'package:flutter/material.dart';

import '../engine/faq_engine.dart';
import '../engine/faq_locale.dart';
import 'faq_chat.dart';
import 'faq_theme.dart';

/// Botón flotante que abre el chat FAQ.
///
/// Es como un `FloatingActionButton` que al tocar abre un
/// `showModalBottomSheet` con el chat completo.
///
/// ## Uso
///
/// ```dart
/// Scaffold(
///   body: MiApp(),
///   floatingActionButton: ApliFaqButton(
///     markdownAsset: 'assets/ayuda.md',
///     appName: 'CalcaApp',
///   ),
/// );
/// ```
class ApliFaqButton extends StatefulWidget {
  /// Ruta al asset Markdown con la documentación.
  final String markdownAsset;

  /// Nombre de la app (se muestra en el header del chat).
  final String appName;

  /// Color principal (shortcut para el tema).
  final Color? themeColor;

  /// Tema completo del chat (override de [themeColor]).
  final ApliFaqTheme? theme;

  /// Idioma del asistente (textos UI + stopwords de búsqueda).
  final FaqLocale? locale;

  /// Altura del bottom sheet (0.0 a 1.0).
  final double sheetHeight;

  const ApliFaqButton({
    super.key,
    required this.markdownAsset,
    required this.appName,
    this.themeColor,
    this.theme,
    this.locale,
    this.sheetHeight = 0.85,
  });

  @override
  State<ApliFaqButton> createState() => _ApliFaqButtonState();
}

class _ApliFaqButtonState extends State<ApliFaqButton>
    with SingleTickerProviderStateMixin {
  FaqEngine? _engine;
  bool _loading = false;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _loadEngine();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadEngine() async {
    setState(() => _loading = true);
    try {
      _engine = await FaqEngine.fromAsset(
        widget.markdownAsset,
        locale: widget.locale,
      );
    } catch (e) {
      debugPrint('ApliFaqButton: Error loading FAQ: $e');
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  ApliFaqTheme get _effectiveTheme {
    if (widget.theme != null) return widget.theme!;
    final locale = widget.locale;
    if (widget.themeColor != null && locale != null) {
      return ApliFaqTheme(
        primaryColor: widget.themeColor!,
        hintText: locale.hintText,
        greetingText: locale.greeting,
      );
    }
    if (widget.themeColor != null) {
      return ApliFaqTheme(primaryColor: widget.themeColor!);
    }
    if (locale != null) {
      return ApliFaqTheme(
        hintText: locale.hintText,
        greetingText: locale.greeting,
      );
    }
    return const ApliFaqTheme();
  }

  void _openChat() {
    if (_engine == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * widget.sheetHeight,
        child: ApliFaqChat(
          engine: _engine!,
          appName: widget.appName,
          theme: _effectiveTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _effectiveTheme;

    return ListenableBuilder(
      listenable: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.05);

        return Transform.scale(
          scale: _engine != null ? scale : 1.0,
          child: FloatingActionButton(
            onPressed: _loading ? null : _openChat,
            backgroundColor: theme.primaryColor,
            child: _loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(theme.fabIcon, color: Colors.white),
          ),
        );
      },
    );
  }
}

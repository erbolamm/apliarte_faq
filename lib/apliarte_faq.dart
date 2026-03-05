/// Asistente FAQ offline para apps Flutter.
///
/// Responde preguntas de usuarios desde un archivo `.md`.
/// 100% offline, sin IA, sin dependencias externas.
///
/// ## Uso rápido
///
/// ```dart
/// import 'package:apliarte_faq/apliarte_faq.dart';
///
/// Scaffold(
///   body: MiApp(),
///   floatingActionButton: ApliFaqButton(
///     markdownAsset: 'assets/ayuda.md',
///     appName: 'MiApp',
///   ),
/// );
/// ```
library apliarte_faq;

export 'src/engine/faq_engine.dart';
export 'src/engine/models.dart';
export 'src/engine/markdown_parser.dart';
export 'src/ui/faq_button.dart';
export 'src/ui/faq_chat.dart';
export 'src/ui/faq_theme.dart';

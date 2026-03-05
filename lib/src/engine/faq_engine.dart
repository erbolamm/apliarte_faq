import 'package:flutter/services.dart';

import 'faq_locale.dart';
import 'markdown_parser.dart';
import 'models.dart';
import 'search_index.dart';

/// Motor principal del FAQ. Carga un `.md` y responde preguntas.
///
/// Es como un `ChangeNotifier` que encapsula toda la lógica de negocio:
/// parsea el Markdown, construye el índice, y busca.
class FaqEngine {
  final List<FaqSection> _sections;
  final SearchIndex _index;
  final FaqLocale locale;

  FaqEngine._(this._sections, this._index, this.locale);

  /// Crea un [FaqEngine] desde un string Markdown.
  ///
  /// [locale] determina el idioma del UI y los stopwords de búsqueda.
  /// Si no se especifica, usa español.
  factory FaqEngine.fromString(String markdown, {FaqLocale? locale}) {
    final effectiveLocale = locale ?? FaqLocale.es;
    const parser = MarkdownParser();
    final sections = parser.parse(markdown);
    final index = SearchIndex(sections, stopWords: effectiveLocale.stopWords);
    return FaqEngine._(sections, index, effectiveLocale);
  }

  /// Crea un [FaqEngine] desde un asset del proyecto.
  ///
  /// ```dart
  /// final engine = await FaqEngine.fromAsset(
  ///   'assets/ayuda.md',
  ///   locale: FaqLocale.en, // inglés
  /// );
  /// ```
  static Future<FaqEngine> fromAsset(
    String assetPath, {
    FaqLocale? locale,
  }) async {
    final markdown = await rootBundle.loadString(assetPath);
    return FaqEngine.fromString(markdown, locale: locale);
  }

  /// Todas las secciones del documento.
  List<FaqSection> get sections => List.unmodifiable(_sections);

  /// Cantidad de secciones indexadas.
  int get sectionCount => _sections.length;

  /// Busca las secciones más relevantes para la pregunta del usuario.
  List<FaqResult> search(String query, {int maxResults = 3}) {
    if (query.trim().isEmpty) return [];
    return _index.search(query, maxResults: maxResults);
  }

  /// Genera una respuesta formateada para una pregunta.
  String answer(String question, {String? notFoundMessage}) {
    final results = search(question);

    if (results.isEmpty) {
      return notFoundMessage ?? locale.notFoundMessage;
    }

    final best = results.first;

    // Score alto → respuesta directa
    if (best.score >= 0.6) {
      return '📌 **${best.section.title}**\n\n${best.section.content}';
    }

    // Score medio → respuesta con contexto
    if (best.score >= 0.3) {
      final buffer = StringBuffer();
      buffer.writeln('📌 **${best.section.title}**\n');
      buffer.writeln(best.section.content);

      if (results.length > 1 && results[1].score >= 0.2) {
        buffer.writeln('\n---\n');
        buffer.writeln('→ **${results[1].section.title}**');
      }
      return buffer.toString().trim();
    }

    // Score bajo → múltiples opciones
    final buffer = StringBuffer();
    for (final result in results.take(3)) {
      buffer.writeln('• **${result.section.title}**');
      buffer.writeln('  ${_truncate(result.section.content, 120)}');
      buffer.writeln();
    }
    return buffer.toString().trim();
  }

  /// Devuelve sugerencias de preguntas basadas en los títulos.
  List<String> get suggestions {
    return _sections
        .where((s) => s.level <= 2)
        .take(5)
        .map((s) => '${_toQuestion(s.title)}?')
        .toList();
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    final cut = text.substring(0, maxLength);
    final lastSpace = cut.lastIndexOf(' ');
    if (lastSpace > maxLength * 0.7) {
      return '${cut.substring(0, lastSpace)}...';
    }
    return '$cut...';
  }

  String _toQuestion(String title) {
    final lower = title.toLowerCase();
    if (lower.startsWith('cómo') ||
        lower.startsWith('qué') ||
        lower.startsWith('por qué') ||
        lower.startsWith('cuándo') ||
        lower.startsWith('how') ||
        lower.startsWith('what') ||
        lower.startsWith('why')) {
      return '¿$lower';
    }
    return '¿${locale.questionPrefix} $lower';
  }
}

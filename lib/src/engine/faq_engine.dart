import 'package:flutter/services.dart';

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

  FaqEngine._(this._sections, this._index);

  /// Crea un [FaqEngine] desde un string Markdown.
  factory FaqEngine.fromString(String markdown) {
    const parser = MarkdownParser();
    final sections = parser.parse(markdown);
    final index = SearchIndex(sections);
    return FaqEngine._(sections, index);
  }

  /// Crea un [FaqEngine] desde un asset del proyecto.
  ///
  /// ```dart
  /// final engine = await FaqEngine.fromAsset('assets/ayuda.md');
  /// ```
  static Future<FaqEngine> fromAsset(String assetPath) async {
    final markdown = await rootBundle.loadString(assetPath);
    return FaqEngine.fromString(markdown);
  }

  /// Todas las secciones del documento.
  List<FaqSection> get sections => List.unmodifiable(_sections);

  /// Cantidad de secciones indexadas.
  int get sectionCount => _sections.length;

  /// Busca las secciones más relevantes para la pregunta del usuario.
  ///
  /// Devuelve hasta [maxResults] resultados ordenados por relevancia.
  List<FaqResult> search(String query, {int maxResults = 3}) {
    if (query.trim().isEmpty) return [];
    return _index.search(query, maxResults: maxResults);
  }

  /// Genera una respuesta formateada para una pregunta.
  ///
  /// Si encuentra resultados, devuelve el contenido de la sección
  /// más relevante. Si no, devuelve un mensaje de "no encontrado".
  String answer(String question, {String? notFoundMessage}) {
    final results = search(question);

    if (results.isEmpty) {
      return notFoundMessage ??
          'No he encontrado información sobre eso. '
              '¿Puedes reformular tu pregunta?';
    }

    final best = results.first;

    // Si la puntuación es muy baja, avisar
    if (best.score < 0.3 && results.length > 1) {
      final buffer = StringBuffer();
      buffer.writeln('He encontrado varias posibles respuestas:\n');
      for (final result in results) {
        buffer.writeln('**${result.section.title}**');
        buffer.writeln(_truncate(result.section.content, 150));
        buffer.writeln();
      }
      return buffer.toString().trim();
    }

    return '**${best.section.title}**\n\n${best.section.content}';
  }

  /// Devuelve sugerencias de preguntas basadas en los títulos.
  List<String> get suggestions {
    return _sections
        .where((s) => s.level <= 2)
        .take(5)
        .map((s) => '¿${_toQuestion(s.title)}?')
        .toList();
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  String _toQuestion(String title) {
    final lower = title.toLowerCase();
    if (lower.startsWith('cómo') ||
        lower.startsWith('qué') ||
        lower.startsWith('por qué') ||
        lower.startsWith('cuándo')) {
      return lower;
    }
    return 'Qué es $lower';
  }
}

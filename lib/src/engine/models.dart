/// Modelos de datos para el motor FAQ.
library;

/// Una sección del documento de ayuda, extraída de un header Markdown.
class FaqSection {
  /// Título de la sección (texto del header `##`).
  final String title;

  /// Contenido de la sección (texto debajo del header).
  final String content;

  /// Nivel del header (1 = `#`, 2 = `##`, 3 = `###`).
  final int level;

  /// Índice original en el documento.
  final int index;

  const FaqSection({
    required this.title,
    required this.content,
    required this.level,
    required this.index,
  });

  /// Texto completo (título + contenido) para búsqueda.
  String get fullText => '$title\n$content';

  @override
  String toString() => 'FaqSection($title)';
}

/// Resultado de una búsqueda FAQ con puntuación de relevancia.
class FaqResult {
  /// La sección encontrada.
  final FaqSection section;

  /// Puntuación de relevancia (0.0 a 1.0).
  final double score;

  const FaqResult({required this.section, required this.score});

  @override
  String toString() => 'FaqResult(${section.title}, score: $score)';
}

/// Mensaje en el chat FAQ.
class FaqMessage {
  /// Texto del mensaje.
  final String text;

  /// Si es del usuario (true) o del asistente (false).
  final bool isUser;

  /// Timestamp del mensaje.
  final DateTime timestamp;

  FaqMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

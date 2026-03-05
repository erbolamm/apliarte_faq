import 'models.dart';

/// Parser que convierte un archivo Markdown en secciones buscables.
///
/// Divide el documento por headers (`#`, `##`, `###`) y crea
/// una [FaqSection] por cada uno.
class MarkdownParser {
  const MarkdownParser();

  /// Parsea un string Markdown y devuelve una lista de secciones.
  List<FaqSection> parse(String markdown) {
    final lines = markdown.split('\n');
    final sections = <FaqSection>[];

    String currentTitle = '';
    int currentLevel = 0;
    final buffer = StringBuffer();
    int sectionIndex = 0;

    for (final line in lines) {
      final headerMatch = RegExp(r'^(#{1,3})\s+(.+)$').firstMatch(line);

      if (headerMatch != null) {
        // Guardar sección anterior si existe
        if (currentTitle.isNotEmpty) {
          sections.add(
            FaqSection(
              title: currentTitle,
              content: buffer.toString().trim(),
              level: currentLevel,
              index: sectionIndex++,
            ),
          );
        }

        // Nueva sección
        currentLevel = headerMatch.group(1)!.length;
        currentTitle = headerMatch.group(2)!.trim();
        buffer.clear();
      } else {
        buffer.writeln(line);
      }
    }

    // Última sección
    if (currentTitle.isNotEmpty) {
      sections.add(
        FaqSection(
          title: currentTitle,
          content: buffer.toString().trim(),
          level: currentLevel,
          index: sectionIndex,
        ),
      );
    }

    return sections;
  }
}

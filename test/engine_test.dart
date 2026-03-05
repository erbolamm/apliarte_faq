import 'package:apliarte_faq/apliarte_faq.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarkdownParser', () {
    const parser = MarkdownParser();

    test('parsea headers de nivel 2', () {
      const md = '''
## Primera sección

Contenido de la primera sección.

## Segunda sección

Contenido de la segunda sección.
''';

      final sections = parser.parse(md);
      expect(sections, hasLength(2));
      expect(sections[0].title, 'Primera sección');
      expect(sections[0].level, 2);
      expect(sections[1].title, 'Segunda sección');
    });

    test('parsea headers de distintos niveles', () {
      const md = '''
# Título principal

Intro.

## Subtítulo

Contenido.

### Sub-subtítulo

Más contenido.
''';

      final sections = parser.parse(md);
      expect(sections, hasLength(3));
      expect(sections[0].level, 1);
      expect(sections[1].level, 2);
      expect(sections[2].level, 3);
    });

    test('devuelve lista vacía para markdown sin headers', () {
      const md = 'Solo texto sin headers';
      final sections = parser.parse(md);
      expect(sections, isEmpty);
    });
  });

  group('FaqEngine', () {
    late FaqEngine engine;

    setUp(() {
      const md = '''
## Cómo empezar

Para empezar a usar la app, abre el menú principal.

## Cómo guardar

Tus datos se guardan automáticamente.

## Contactar soporte

Escríbenos a soporte@apliarte.com.
''';
      engine = FaqEngine.fromString(md);
    });

    test('tiene el número correcto de secciones', () {
      expect(engine.sectionCount, 3);
    });

    test('busca secciones relevantes', () {
      final results = engine.search('empezar');
      expect(results, isNotEmpty);
      expect(results.first.section.title, contains('empezar'));
    });

    test('devuelve respuesta formateada', () {
      final answer = engine.answer('cómo empezar');
      expect(answer, contains('empezar'));
    });

    test('devuelve mensaje de no encontrado', () {
      final answer = engine.answer('xyzabc123');
      expect(answer, contains('No he encontrado'));
    });

    test('genera sugerencias', () {
      final suggestions = engine.suggestions;
      expect(suggestions, isNotEmpty);
      expect(suggestions.first, contains('?'));
    });
  });
}

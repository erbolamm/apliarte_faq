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

Para empezar a usar la app, abre el menú principal y selecciona
la opción que necesites. El proceso es muy sencillo.

## Cómo guardar mis datos

Tus datos se guardan automáticamente cada vez que haces un cambio.
No necesitas pulsar ningún botón de guardar.

## Contactar soporte técnico

Escríbenos a soporte@apliarte.com o visita nuestra web.
Respondemos en menos de 24 horas.

## La app funciona sin internet

Sí, la aplicación funciona completamente offline.
Solo necesitas internet para sincronizar datos con la nube.
''';
      engine = FaqEngine.fromString(md);
    });

    test('tiene el número correcto de secciones', () {
      expect(engine.sectionCount, 4);
    });

    test('busca secciones por coincidencia exacta', () {
      final results = engine.search('empezar');
      expect(results, isNotEmpty);
      expect(results.first.section.title, contains('empezar'));
    });

    test('busca sin importar acentos (cómo → como)', () {
      final results = engine.search('como empezar');
      expect(results, isNotEmpty);
      expect(results.first.section.title.toLowerCase(), contains('empezar'));
    });

    test('busca con errores tipográficos (fuzzy match)', () {
      final results = engine.search('guarrdar datos');
      expect(results, isNotEmpty);
      expect(results.first.section.title.toLowerCase(), contains('guardar'));
    });

    test('busca con sinónimos parciales por stemming', () {
      final results = engine.search('aplicacion offline');
      expect(results, isNotEmpty);
      // Debería encontrar la sección sobre funcionar sin internet
    });

    test('devuelve respuesta formateada con emoji', () {
      final answer = engine.answer('cómo empiezo');
      expect(answer, isNotEmpty);
      expect(answer, isNot(contains('No he encontrado')));
    });

    test('devuelve mensaje de no encontrado para basura', () {
      final answer = engine.answer('xyzabc123 qwerty asdf');
      expect(answer, contains('No he encontrado'));
    });

    test('genera sugerencias con formato de pregunta', () {
      final suggestions = engine.suggestions;
      expect(suggestions, isNotEmpty);
      expect(suggestions.length, lessThanOrEqualTo(5));
      for (final s in suggestions) {
        expect(s, contains('?'));
        expect(s, startsWith('¿'));
      }
    });

    test('no devuelve resultados para query vacía', () {
      final results = engine.search('');
      expect(results, isEmpty);
      final results2 = engine.search('   ');
      expect(results2, isEmpty);
    });

    test('respuesta de alta confianza es directa', () {
      final answer = engine.answer('guardar datos');
      expect(answer, contains('📌'));
      expect(answer, contains('guardar'));
    });
  });
}

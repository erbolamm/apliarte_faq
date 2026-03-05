import 'dart:math';

import 'models.dart';

/// Índice de búsqueda TF-IDF con fuzzy matching y normalización de acentos.
///
/// Piensa en esto como un `Map<String, List<double>>` donde cada palabra
/// tiene un peso por documento, pero con "tolerancia a errores" integrada.
class SearchIndex {
  final List<FaqSection> _sections;
  final Set<String> _extraStopWords;
  late final Map<int, Map<String, double>> _tfidf;

  SearchIndex(this._sections, {Set<String>? stopWords})
    : _extraStopWords = stopWords ?? const {} {
    _buildIndex();
  }

  void _buildIndex() {
    final docCount = _sections.length;
    if (docCount == 0) {
      _tfidf = {};
      return;
    }

    // Contar en cuántos documentos aparece cada término (DF)
    final docFrequency = <String, int>{};
    final termsByDoc = <int, Map<String, int>>{};
    final allTerms = <String>{};

    for (var i = 0; i < _sections.length; i++) {
      final terms = _tokenize(_sections[i].fullText);
      final termCounts = <String, int>{};

      for (final term in terms) {
        termCounts[term] = (termCounts[term] ?? 0) + 1;
      }

      termsByDoc[i] = termCounts;

      for (final term in termCounts.keys) {
        docFrequency[term] = (docFrequency[term] ?? 0) + 1;
        allTerms.add(term);
      }
    }

    // Calcular TF-IDF para cada documento
    _tfidf = {};
    for (var i = 0; i < _sections.length; i++) {
      final terms = termsByDoc[i]!;
      final totalTerms = terms.values.fold<int>(0, (a, b) => a + b);
      final tfidfDoc = <String, double>{};

      for (final entry in terms.entries) {
        final tf = entry.value / totalTerms;
        final idf = log((docCount + 1) / (docFrequency[entry.key]! + 1)) + 1;
        tfidfDoc[entry.key] = tf * idf;
      }

      _tfidf[i] = tfidfDoc;
    }
  }

  /// Busca las secciones más relevantes para la consulta dada.
  List<FaqResult> search(String query, {int maxResults = 3}) {
    if (_sections.isEmpty) return [];

    final queryTerms = _tokenize(query);
    if (queryTerms.isEmpty) return [];

    final scores = <int, double>{};

    for (var i = 0; i < _sections.length; i++) {
      double score = 0;
      final docTfidf = _tfidf[i] ?? {};

      for (final queryTerm in queryTerms) {
        // 1. Coincidencia exacta (peso completo)
        if (docTfidf.containsKey(queryTerm)) {
          score += docTfidf[queryTerm]! * 2.0;
          continue; // Ya encontró exacto, no buscar fuzzy
        }

        // 2. Coincidencia por prefijo (peso medio)
        double bestPrefixScore = 0;
        for (final docTerm in docTfidf.keys) {
          if (docTerm.length >= 3 && queryTerm.length >= 3) {
            if (docTerm.startsWith(queryTerm) ||
                queryTerm.startsWith(docTerm)) {
              final prefixScore = docTfidf[docTerm]! * 0.7;
              if (prefixScore > bestPrefixScore) {
                bestPrefixScore = prefixScore;
              }
            }
          }
        }

        if (bestPrefixScore > 0) {
          score += bestPrefixScore;
          continue; // Ya encontró prefijo, no buscar fuzzy
        }

        // 3. Búsqueda difusa — Levenshtein (peso bajo)
        final fuzzyMatch = _findFuzzyMatch(queryTerm, docTfidf);
        if (fuzzyMatch != null) {
          score += fuzzyMatch * 0.4;
        }
      }

      // Bonus por coincidencia en el título (×2)
      final titleTerms = _tokenize(_sections[i].title);
      for (final queryTerm in queryTerms) {
        for (final titleTerm in titleTerms) {
          if (titleTerm == queryTerm) {
            score *= 2.0;
          } else if (_levenshtein(titleTerm, queryTerm) <= 2) {
            score *= 1.5;
          }
        }
      }

      if (score > 0) {
        scores[i] = score;
      }
    }

    // Ordenar por puntuación descendente
    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Normalizar scores a 0-1
    final maxScore = sorted.isEmpty ? 1.0 : sorted.first.value;

    return sorted
        .take(maxResults)
        .map(
          (e) => FaqResult(
            section: _sections[e.key],
            score: maxScore > 0 ? e.value / maxScore : 0,
          ),
        )
        .toList();
  }

  /// Encuentra la mejor coincidencia fuzzy para un término en un documento.
  /// Retorna el score TF-IDF del término encontrado, o null si no hay match.
  double? _findFuzzyMatch(String queryTerm, Map<String, double> docTfidf) {
    if (queryTerm.length < 3) return null;

    double? bestScore;
    int bestDistance = 3; // Máximo 2 errores permitidos

    for (final docTerm in docTfidf.keys) {
      if (docTerm.length < 3) continue;

      // Solo comparar términos de longitud similar (±2)
      if ((docTerm.length - queryTerm.length).abs() > 2) continue;

      final distance = _levenshtein(queryTerm, docTerm);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestScore = docTfidf[docTerm]!;
      }
    }

    return bestScore;
  }

  /// Calcula la distancia de Levenshtein entre dos strings.
  /// Mide cuántas operaciones (insertar, borrar, sustituir) se necesitan
  /// para transformar [a] en [b].
  static int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    // Optimización: solo necesitamos 2 filas de la matriz
    var previous = List<int>.generate(b.length + 1, (i) => i);
    var current = List<int>.filled(b.length + 1, 0);

    for (var i = 1; i <= a.length; i++) {
      current[0] = i;
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        current[j] = [
          current[j - 1] + 1, // inserción
          previous[j] + 1, // borrado
          previous[j - 1] + cost, // sustitución
        ].reduce(min);
      }
      // Intercambiar filas
      final temp = previous;
      previous = current;
      current = temp;
    }

    return previous[b.length];
  }

  /// Tokeniza un texto en términos normalizados.
  /// Quita acentos, pasa a minúsculas, y elimina stopwords.
  List<String> _tokenize(String text) {
    return _normalize(text)
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 2)
        .where((t) => !_stopWords.contains(t) && !_extraStopWords.contains(t))
        .map(_stem)
        .toList();
  }

  /// Normaliza el texto: minúsculas + quita acentos + quita puntuación.
  static String _normalize(String text) {
    var result = text.toLowerCase();
    // Quitar acentos
    result = result
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
    // Quitar puntuación, mantener espacios y alfanuméricos
    result = result.replaceAll(RegExp(r'[^\w\s]'), ' ');
    return result;
  }

  /// Stemming muy básico para español: quita sufijos comunes.
  /// No es perfecto pero ayuda bastante para búsqueda.
  static String _stem(String word) {
    if (word.length <= 4) return word;

    // Sufijos más largos primero
    const suffixes = [
      'aciones',
      'iciones',
      'amente',
      'mente',
      'cion',
      'sion',
      'ando',
      'endo',
      'iendo',
      'ador',
      'edor',
      'izar',
      'idad',
      'ivos',
      'ivas',
      'ible',
      'able',
      'ente',
      'ante',
      'ares',
      'ores',
      'iones',
      'mente',
    ];

    for (final suffix in suffixes) {
      if (word.endsWith(suffix) && word.length - suffix.length >= 3) {
        return word.substring(0, word.length - suffix.length);
      }
    }

    // Quitar plurales simples
    if (word.endsWith('es') && word.length > 4) {
      return word.substring(0, word.length - 2);
    }
    if (word.endsWith('s') && word.length > 4) {
      return word.substring(0, word.length - 1);
    }

    return word;
  }

  /// Palabras vacías que no aportan relevancia a la búsqueda.
  static const _stopWords = {
    // Español — artículos, preposiciones, conjunciones
    'los', 'las', 'una', 'uno', 'del', 'que', 'por', 'para', 'con',
    'sin', 'desde', 'hasta', 'como', 'mas', 'pero', 'este', 'esta',
    'estos', 'estas', 'ese', 'esa', 'esos', 'esas', 'son',
    'hay', 'ser', 'tiene', 'puede', 'tambien', 'cuando', 'donde',
    'todo', 'toda', 'todos', 'todas', 'otro', 'otra', 'otros',
    'muy', 'tan', 'solo', 'bien', 'aqui', 'asi', 'nos', 'les',
    'cual', 'quien', 'cada', 'entre', 'sobre', 'tras', 'ante',
    'bajo', 'hacia', 'segun', 'durante', 'mediante',
    'mis', 'tus', 'sus', 'nuestro', 'nuestra',
    'quiero', 'necesito', 'puedo', 'tengo', 'hago',
    // Inglés
    'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can',
    'her', 'was', 'one', 'our', 'out', 'has', 'have', 'with',
    'this', 'that', 'from', 'they', 'been', 'will', 'more',
    'what', 'how', 'why', 'when', 'where', 'which',
  };
}

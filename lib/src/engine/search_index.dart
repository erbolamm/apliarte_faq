import 'dart:math';

import 'models.dart';

/// Índice de búsqueda TF-IDF (Term Frequency - Inverse Document Frequency).
///
/// Piensa en esto como un `Map<String, List<double>>` donde cada palabra
/// tiene un peso por documento. Como un `ValueNotifier` pero para relevancia.
class SearchIndex {
  final List<FaqSection> _sections;
  late final Map<int, Map<String, double>> _tfidf;

  SearchIndex(this._sections) {
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

    for (var i = 0; i < _sections.length; i++) {
      final terms = _tokenize(_sections[i].fullText);
      final termCounts = <String, int>{};

      for (final term in terms) {
        termCounts[term] = (termCounts[term] ?? 0) + 1;
      }

      termsByDoc[i] = termCounts;

      for (final term in termCounts.keys) {
        docFrequency[term] = (docFrequency[term] ?? 0) + 1;
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

      for (final term in queryTerms) {
        // Búsqueda exacta
        if (docTfidf.containsKey(term)) {
          score += docTfidf[term]!;
        }

        // Búsqueda parcial (prefijo)
        for (final docTerm in docTfidf.keys) {
          if (docTerm.startsWith(term) || term.startsWith(docTerm)) {
            score += docTfidf[docTerm]! * 0.5;
          }
        }
      }

      // Bonus por coincidencia en el título
      final titleLower = _sections[i].title.toLowerCase();
      for (final term in queryTerms) {
        if (titleLower.contains(term)) {
          score *= 1.5;
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

  /// Tokeniza un texto en términos normalizados.
  List<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\sáéíóúüñ]'), ' ')
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 2)
        .where((t) => !_stopWords.contains(t))
        .toList();
  }

  /// Palabras vacías en español e inglés que no aportan relevancia.
  static const _stopWords = {
    // Español
    'los', 'las', 'una', 'uno', 'del', 'que', 'por', 'para', 'con',
    'sin', 'desde', 'hasta', 'como', 'más', 'pero', 'este', 'esta',
    'estos', 'estas', 'ese', 'esa', 'esos', 'esas', 'son', 'está',
    'hay', 'ser', 'tiene', 'puede', 'también', 'cuando', 'donde',
    'todo', 'toda', 'todos', 'todas', 'otro', 'otra', 'otros',
    'muy', 'tan', 'solo', 'bien', 'aquí', 'así',
    // Inglés
    'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can',
    'her', 'was', 'one', 'our', 'out', 'has', 'have', 'with',
    'this', 'that', 'from', 'they', 'been', 'will', 'more',
  };
}

/// Tipos de respuesta del motor AI.
///
/// - [FaqAiMode.mechanical]: usa el motor TF-IDF (siempre disponible).
/// - [FaqAiMode.hybrid]: pregunta primero a la IA; si no responde, cae a TF-IDF.
/// - [FaqAiMode.aiOnly]: solo usa la IA (requiere callback configurado).
enum FaqAiMode {
  mechanical,
  hybrid,
  aiOnly;
}

/// Callback opcional para respuestas con IA.
///
/// El usuario implementa esta función con el cliente HTTP que prefiera
/// (http, dio, dart:io...) para conectar con Ollama, LM Studio, o cualquier
/// endpoint compatible con la API de chat.
///
/// ## Ejemplo con el paquete `http`
///
/// ```dart
/// Future<String> ollamaAnswer(String question, List<String> context) async {
///   final response = await http.post(
///     Uri.parse('http://localhost:11434/api/chat'),
///     body: jsonEncode({
///       'model': 'llama3.2:1b',
///       'messages': [
///         {'role': 'system', 'content': 'Usa este contexto para responder: ${context.join('\n')}'},
///         {'role': 'user', 'content': question},
///       ],
///       'stream': false,
///     }),
///   );
///   final data = jsonDecode(response.body) as Map;
///   return data['message']['content'] as String;
/// }
/// ```
typedef FaqAiCallback = Future<String> Function(
  String question,
  List<String> contextSections,
);

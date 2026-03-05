import 'package:flutter/material.dart';

import '../engine/faq_engine.dart';
import '../engine/models.dart';
import 'faq_message.dart';
import 'faq_theme.dart';

/// Widget de chat FAQ completo. Muestra un chat con el asistente.
///
/// Como un `ListView` con un `TextField` abajo — pero con la lógica
/// de búsqueda FAQ integrada.
class ApliFaqChat extends StatefulWidget {
  /// Motor FAQ ya inicializado.
  final FaqEngine engine;

  /// Nombre de la app (se muestra en el header).
  final String appName;

  /// Tema del chat.
  final ApliFaqTheme theme;

  const ApliFaqChat({
    super.key,
    required this.engine,
    required this.appName,
    this.theme = const ApliFaqTheme(),
  });

  @override
  State<ApliFaqChat> createState() => _ApliFaqChatState();
}

class _ApliFaqChatState extends State<ApliFaqChat> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <FaqMessage>[];
  bool _showSuggestions = true;

  @override
  void initState() {
    super.initState();
    // Mensaje de bienvenida
    _messages.add(FaqMessage(text: widget.theme.greetingText, isUser: false));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _showSuggestions = false;
      // Mensaje del usuario
      _messages.add(FaqMessage(text: text.trim(), isUser: true));

      // Respuesta del asistente
      final answer = widget.engine.answer(text.trim());
      _messages.add(FaqMessage(text: answer, isUser: false));
    });

    _controller.clear();

    // Scroll al final con animación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asistente ${widget.appName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.engine.sectionCount} temas disponibles',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length + (_showSuggestions ? 1 : 0),
              itemBuilder: (context, index) {
                if (_showSuggestions && index == _messages.length) {
                  return _buildSuggestions(theme);
                }
                return FaqMessageBubble(
                  message: _messages[index],
                  theme: theme,
                );
              },
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: theme.hintText,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey.withValues(alpha: 0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => _sendMessage(_controller.text),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(ApliFaqTheme theme) {
    final suggestions = widget.engine.suggestions;
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Preguntas frecuentes:',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((s) {
              return ActionChip(
                label: Text(
                  s,
                  style: TextStyle(color: theme.primaryColor, fontSize: 12),
                ),
                backgroundColor: theme.primaryColor.withValues(alpha: 0.08),
                side: BorderSide(
                  color: theme.primaryColor.withValues(alpha: 0.2),
                ),
                onPressed: () => _sendMessage(s),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

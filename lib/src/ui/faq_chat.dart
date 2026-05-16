import 'package:flutter/material.dart';

import '../engine/faq_ai.dart';
import '../engine/faq_engine.dart';
import '../engine/models.dart';
import 'faq_theme.dart';

/// Widget de chat FAQ completo.
///
/// Por defecto responde con el motor TF-IDF ([FaqEngine]).
/// Si se provee un [aiCallback], puede usar IA según el [aiMode].
class ApliFaqChat extends StatefulWidget {
  /// Motor FAQ ya inicializado (TF-IDF, siempre disponible).
  final FaqEngine engine;

  /// Nombre de la app (se muestra en el header).
  final String appName;

  /// Tema del chat.
  final ApliFaqTheme theme;

  /// Callback opcional para respuestas con IA.
  final FaqAiCallback? aiCallback;

  /// Modo de funcionamiento.
  final FaqAiMode aiMode;

  const ApliFaqChat({
    super.key,
    required this.engine,
    required this.appName,
    this.theme = const ApliFaqTheme(),
    this.aiCallback,
    this.aiMode = FaqAiMode.mechanical,
  });

  @override
  State<ApliFaqChat> createState() => _ApliFaqChatState();
}

class _ApliFaqChatState extends State<ApliFaqChat> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <FaqMessage>[];
  bool _showSuggestions = true;
  bool _aiThinking = false;

  bool get _hasAi =>
      widget.aiCallback != null && widget.aiMode != FaqAiMode.mechanical;

  @override
  void initState() {
    super.initState();
    _messages.add(FaqMessage(text: widget.theme.greetingText, isUser: false));

    if (_hasAi) {
      _messages.insert(
        1,
        FaqMessage(
          text: widget.aiMode == FaqAiMode.aiOnly
              ? '🤖 Modo IA activo. Tus preguntas se responden con inteligencia artificial local.'
              : '🤖 Modo híbrido activo. IA primero, búsqueda local como respaldo.',
          isUser: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _showSuggestions = false;
      _messages.add(FaqMessage(text: text.trim(), isUser: true));
    });

    // ── Respuesta con IA ──
    if (_hasAi && widget.aiMode != FaqAiMode.mechanical) {
      setState(() => _aiThinking = true);
      try {
        final context = widget.engine.sections
            .map((s) => '## ${s.title}\n${s.content}')
            .toList();

        final aiAnswer = await widget.aiCallback!(text.trim(), context);
        if (mounted) {
          setState(() {
            _messages.add(FaqMessage(text: aiAnswer, isUser: false));
            _aiThinking = false;
          });
          _scrollToBottom();
        }
        return; // IA respondió
      } catch (e) {
        debugPrint('ApliFaqChat: AI error: $e');
        if (widget.aiMode == FaqAiMode.aiOnly) {
          if (mounted) {
            setState(() {
              _messages.add(FaqMessage(
                text: '⚠️ Error al conectar con la IA. '
                    'Verificá que el servicio esté corriendo.',
                isUser: false,
              ));
              _aiThinking = false;
            });
          }
          return;
        }
        // hybrid mode: fallback a TF-IDF
        setState(() => _aiThinking = false);
      }
    }

    // ── Respuesta con TF-IDF (fallback o modo mechanical) ──
    final answer = widget.engine.answer(text);
    if (mounted) {
      setState(() {
        _messages.add(FaqMessage(text: answer, isUser: false));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
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

  void _onSuggestionTap(String text) {
    _controller.text = text;
    _sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final suggestions = widget.engine.suggestions;

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.05),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(Icons.chat_rounded, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  widget.appName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: theme.primaryColor,
                  ),
                ),
                const Spacer(),
                if (_hasAi)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 12,
                            color: theme.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          widget.aiMode == FaqAiMode.aiOnly ? 'IA' : 'Híbrido',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: _messages.isEmpty
                ? const SizedBox.shrink()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return _MessageBubble(
                        message: msg,
                        primaryColor: theme.primaryColor,
                      );
                    },
                  ),
          ),
          // AI thinking indicator
          if (_aiThinking)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Pensando...',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          // Suggestions
          if (_showSuggestions && suggestions.isNotEmpty)
            Container(
              height: 56,
              padding: const EdgeInsets.only(left: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: suggestions.map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(s, style: const TextStyle(fontSize: 12)),
                      onPressed: () => _onSuggestionTap(s),
                    ),
                  );
                }).toList(),
              ),
            ),
          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.03),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: theme.hintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.withValues(alpha: 0.08),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: theme.primaryColor,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, size: 18),
                    color: Colors.white,
                    onPressed: () =>
                        _sendMessage(_controller.text),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final FaqMessage message;
  final Color primaryColor;

  const _MessageBubble({
    required this.message,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: primaryColor.withValues(alpha: 0.1),
              child: Icon(Icons.support_agent, size: 16, color: primaryColor),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? primaryColor
                    : Colors.grey.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: message.isUser
                      ? const Radius.circular(16)
                      : Radius.zero,
                  bottomRight: message.isUser
                      ? Radius.zero
                      : const Radius.circular(16),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : null,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

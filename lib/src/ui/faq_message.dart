import 'package:flutter/material.dart';

import '../engine/models.dart';
import 'faq_theme.dart';
import 'simple_markdown.dart';

/// Widget de burbuja de mensaje en el chat FAQ.
class FaqMessageBubble extends StatelessWidget {
  final FaqMessage message;
  final ApliFaqTheme theme;

  const FaqMessageBubble({
    super.key,
    required this.message,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
              child: Icon(
                Icons.smart_toy_rounded,
                size: 16,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.userBubbleColor
                    : theme.assistantBubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(theme.bubbleRadius),
                  topRight: Radius.circular(theme.bubbleRadius),
                  bottomLeft: Radius.circular(isUser ? theme.bubbleRadius : 4),
                  bottomRight: Radius.circular(isUser ? 4 : theme.bubbleRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isUser
                  ? Text(
                      message.text,
                      style: TextStyle(
                        color: theme.userTextColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    )
                  : SimpleMarkdown(
                      data: message.text,
                      baseStyle: TextStyle(
                        color: theme.assistantTextColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

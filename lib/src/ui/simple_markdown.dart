import 'package:flutter/material.dart';

/// Renderer de Markdown ligero para las burbujas del chat.
///
/// Soporta: **negrita**, *cursiva*, `código`, listas (- y 1.),
/// divisores (---), y emojis. Todo sin dependencias externas.
class SimpleMarkdown extends StatelessWidget {
  final String data;
  final TextStyle? baseStyle;
  final Color? linkColor;

  const SimpleMarkdown({
    super.key,
    required this.data,
    this.baseStyle,
    this.linkColor,
  });

  @override
  Widget build(BuildContext context) {
    final style =
        baseStyle ??
        TextStyle(
          fontSize: 14,
          color: Theme.of(context).textTheme.bodyMedium?.color,
          height: 1.4,
        );

    final lines = data.split('\n');
    final widgets = <Widget>[];
    var i = 0;

    while (i < lines.length) {
      final line = lines[i].trimRight();

      // Línea vacía → espaciado
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 6));
        i++;
        continue;
      }

      // Divisor ---
      if (RegExp(r'^-{3,}$').hasMatch(line.trim())) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: Colors.grey.withValues(alpha: 0.3)),
          ),
        );
        i++;
        continue;
      }

      // Bullet list (- item)
      if (line.trimLeft().startsWith('- ')) {
        final indent = line.indexOf('-');
        final content = line.substring(line.indexOf('- ') + 2);
        widgets.add(_buildBullet(content, style, indent: indent));
        i++;
        continue;
      }

      // Lista numerada (1. item)
      final numberedMatch = RegExp(r'^(\s*)(\d+)\.\s+(.+)$').firstMatch(line);
      if (numberedMatch != null) {
        final number = numberedMatch.group(2)!;
        final content = numberedMatch.group(3)!;
        widgets.add(_buildNumberedItem(number, content, style));
        i++;
        continue;
      }

      // Texto normal con formato inline
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: RichText(text: _parseInline(line, style)),
        ),
      );
      i++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  Widget _buildBullet(String text, TextStyle style, {int indent = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: indent * 8.0 + 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 8),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: style.color?.withValues(alpha: 0.6) ?? Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(child: RichText(text: _parseInline(text, style))),
        ],
      ),
    );
  }

  Widget _buildNumberedItem(String number, String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$number.',
              style: style.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: RichText(text: _parseInline(text, style))),
        ],
      ),
    );
  }

  /// Parsea formato inline: **negrita**, *cursiva*, `código`
  TextSpan _parseInline(String text, TextStyle style) {
    final spans = <InlineSpan>[];
    var remaining = text;

    while (remaining.isNotEmpty) {
      // **negrita**
      final boldMatch = RegExp(r'\*\*(.+?)\*\*').firstMatch(remaining);
      // *cursiva*
      final italicMatch = RegExp(r'\*(.+?)\*').firstMatch(remaining);
      // `código`
      final codeMatch = RegExp(r'`(.+?)`').firstMatch(remaining);

      // Encontrar el match más cercano
      final matches = <RegExpMatch>[];
      if (boldMatch != null) matches.add(boldMatch);
      if (italicMatch != null) matches.add(italicMatch);
      if (codeMatch != null) matches.add(codeMatch);

      if (matches.isEmpty) {
        // No hay más formato, añadir el resto como texto plano
        spans.add(TextSpan(text: remaining, style: style));
        break;
      }

      // Ordenar por posición
      matches.sort((a, b) => a.start.compareTo(b.start));
      final first = matches.first;

      // Texto antes del match
      if (first.start > 0) {
        spans.add(
          TextSpan(text: remaining.substring(0, first.start), style: style),
        );
      }

      // El match formateado
      if (first == boldMatch) {
        spans.add(
          TextSpan(
            text: first.group(1),
            style: style.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      } else if (first == codeMatch) {
        spans.add(
          TextSpan(
            text: first.group(1),
            style: style.copyWith(
              fontFamily: 'monospace',
              backgroundColor: Colors.grey.withValues(alpha: 0.15),
              fontSize: (style.fontSize ?? 14) - 1,
            ),
          ),
        );
      } else if (first == italicMatch) {
        spans.add(
          TextSpan(
            text: first.group(1),
            style: style.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }

      remaining = remaining.substring(first.end);
    }

    return TextSpan(children: spans);
  }
}

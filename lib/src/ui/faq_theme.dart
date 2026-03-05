import 'package:flutter/material.dart';

/// Tema personalizable para el chat FAQ.
///
/// Como un `ThemeData` pero específico para el widget FAQ.
class ApliFaqTheme {
  /// Color principal del chat.
  final Color primaryColor;

  /// Color de fondo del chat.
  final Color backgroundColor;

  /// Color de las burbujas del usuario.
  final Color userBubbleColor;

  /// Color de las burbujas del asistente.
  final Color assistantBubbleColor;

  /// Color del texto del usuario.
  final Color userTextColor;

  /// Color del texto del asistente.
  final Color assistantTextColor;

  /// Radio de las burbujas.
  final double bubbleRadius;

  /// Icono del botón flotante.
  final IconData fabIcon;

  /// Texto del placeholder del input.
  final String hintText;

  /// Texto de saludo inicial.
  final String greetingText;

  const ApliFaqTheme({
    this.primaryColor = const Color(0xFF6C5CE7),
    this.backgroundColor = const Color(0xFFF8F9FA),
    this.userBubbleColor = const Color(0xFF6C5CE7),
    this.assistantBubbleColor = Colors.white,
    this.userTextColor = Colors.white,
    this.assistantTextColor = const Color(0xFF2D3436),
    this.bubbleRadius = 18.0,
    this.fabIcon = Icons.chat_rounded,
    this.hintText = 'Escribe tu pregunta...',
    this.greetingText = '¡Hola! ¿En qué puedo ayudarte?',
  });

  /// Tema oscuro predeterminado.
  factory ApliFaqTheme.dark() {
    return const ApliFaqTheme(
      primaryColor: Color(0xFFA29BFE),
      backgroundColor: Color(0xFF1E1E2E),
      userBubbleColor: Color(0xFF6C5CE7),
      assistantBubbleColor: Color(0xFF2D2D44),
      userTextColor: Colors.white,
      assistantTextColor: Color(0xFFE0E0E0),
    );
  }

  /// Crea un nuevo tema modificando solo los campos especificados.
  ApliFaqTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? userBubbleColor,
    Color? assistantBubbleColor,
    Color? userTextColor,
    Color? assistantTextColor,
    double? bubbleRadius,
    IconData? fabIcon,
    String? hintText,
    String? greetingText,
  }) {
    return ApliFaqTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      userBubbleColor: userBubbleColor ?? this.userBubbleColor,
      assistantBubbleColor: assistantBubbleColor ?? this.assistantBubbleColor,
      userTextColor: userTextColor ?? this.userTextColor,
      assistantTextColor: assistantTextColor ?? this.assistantTextColor,
      bubbleRadius: bubbleRadius ?? this.bubbleRadius,
      fabIcon: fabIcon ?? this.fabIcon,
      hintText: hintText ?? this.hintText,
      greetingText: greetingText ?? this.greetingText,
    );
  }
}

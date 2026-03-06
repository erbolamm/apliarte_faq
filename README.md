# apliarte_faq

Asistente FAQ offline para apps Flutter. Responde preguntas de usuarios desde un archivo `.md`. 100% offline, sin IA, sin dependencias externas.

[![pub package](https://img.shields.io/pub/v/apliarte_faq.svg)](https://pub.dev/packages/apliarte_faq)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Demo Web](https://img.shields.io/badge/Demo-Mirar%20en%20vivo-purple?style=for-the-badge)](https://erbolamm.github.io/apliarte_faq/)

## ✨ Características

- **100% Offline** — No necesita internet, IA ni servidores externos
- **Cero dependencias** — Solo Flutter, nada más
- **Privacidad total** — Los datos nunca salen del dispositivo
- **Motor TF-IDF** — Búsqueda inteligente con fuzzy matching y normalización de acentos
- **Markdown renderer** — Renderiza **negrita**, *cursiva*, `código`, bullets y listas
- **17 idiomas** — Soporte multilingüe de serie

## 🌍 Idiomas soportados

| | | | |
|---|---|---|---|
| 🇪🇸 Español | 🇬🇧 English | 🇫🇷 Français | 🇩🇪 Deutsch |
| 🇧🇷 Português | 🇮🇹 Italiano | 🇷🇺 Русский | 🇨🇳 中文 |
| 🇯🇵 日本語 | 🇰🇷 한국어 | 🇸🇦 العربية | 🇮🇳 हिन्दी |
| 🇹🇷 Türkçe | 🇵🇱 Polski | 🇻🇳 Tiếng Việt | 🇮🇩 Bahasa |
| 🇮🇷 فارسی | | | |

Cada idioma incluye: textos del UI traducidos, stopwords optimizados para búsqueda, y detección automática del idioma del dispositivo.

## 🚀 Instalación

```yaml
dependencies:
  apliarte_faq: ^1.0.1
```

## 📱 Uso rápido

```dart
import 'package:apliarte_faq/apliarte_faq.dart';

Scaffold(
  body: MiApp(),
  floatingActionButton: ApliFaqButton(
    markdownAsset: 'assets/ayuda.md',
    appName: 'MiApp',
  ),
);
```

¡Eso es todo! Tu app ahora tiene un asistente FAQ con solo 3 líneas.

## 🌍 Uso multilingüe

```dart
// Inglés
ApliFaqButton(
  markdownAsset: 'assets/help_en.md',
  appName: 'MyApp',
  locale: FaqLocale.en,
)

// Japonés
ApliFaqButton(
  markdownAsset: 'assets/help_ja.md',
  appName: 'マイアプリ',
  locale: FaqLocale.ja,
)

// Auto-detectar idioma del dispositivo
ApliFaqButton(
  markdownAsset: 'assets/help.md',
  appName: 'MyApp',
  locale: FaqLocale.fromCode(Platform.localeName),
)
```

## 🎨 Personalización

```dart
ApliFaqButton(
  markdownAsset: 'assets/ayuda.md',
  appName: 'MiApp',
  theme: ApliFaqTheme(
    primaryColor: Colors.teal,
    backgroundColor: Color(0xFFF0F4F8),
    bubbleRadius: 20.0,
    fabIcon: Icons.help_outline,
  ),
);
```

### Tema oscuro

```dart
ApliFaqButton(
  markdownAsset: 'assets/ayuda.md',
  appName: 'MiApp',
  theme: ApliFaqTheme.dark(),
);
```

## 🔧 Uso avanzado

```dart
// Motor directo (sin UI)
final engine = await FaqEngine.fromAsset(
  'assets/ayuda.md',
  locale: FaqLocale.fr,
);

final results = engine.search('mon problème');
final answer = engine.answer('comment faire');
```

## 📝 Cómo escribir el archivo .md

Cada sección `##` se convierte en una respuesta independiente:

```markdown
# Mi App — Ayuda

## Cómo empezar
Descarga la app y crea una cuenta...

## Cómo contactar soporte
Escríbenos a soporte@miapp.com...
```

## 📦 Estructura del paquete

| Componente | Descripción |
|---|---|
| `ApliFaqButton` | FAB con animación de pulso que abre el chat |
| `ApliFaqChat` | Widget de chat completo con sugerencias |
| `FaqEngine` | Motor de búsqueda TF-IDF + respuestas |
| `FaqLocale` | Soporte multilingüe (17 idiomas) |
| `ApliFaqTheme` | Personalización visual completa |
| `SimpleMarkdown` | Renderer de Markdown ligero sin dependencias |

## 👨‍💻 Creado por

**Javier Mateo** (erbolamm) — [ApliArte.com](https://www.apliarte.com)

- [GitHub](https://github.com/erbolamm)
- [X/Twitter](https://twitter.com/erbolamm)

*"O se gana, o se aprende"*

## ☕ Apoya el proyecto

- [Ko-fi (desde 3€)](https://ko-fi.com/C0C11TWR1K)
- [PayPal](https://www.paypal.com/paypalme/erbolamm)

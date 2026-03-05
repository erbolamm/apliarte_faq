# apliarte_faq

Asistente FAQ offline para apps Flutter. Responde preguntas de usuarios desde un archivo `.md`. 100% offline, sin IA, sin dependencias externas.

**[🚀 Probar demo online](https://erbolamm.github.io/apliarte_faq/)**

## Instalación

```yaml
dependencies:
  apliarte_faq:
    path: ../apliarte_faq  # o desde pub.dev cuando se publique
```

## Uso rápido

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

## Personalización

```dart
ApliFaqButton(
  markdownAsset: 'assets/ayuda.md',
  appName: 'MiApp',
  themeColor: Colors.blue,           // Color personalizado
  theme: ApliFaqTheme.dark(),        // O tema completo
  sheetHeight: 0.9,                  // Altura del chat
);
```

## Cómo funciona

1. Parsea tu archivo `.md` dividiéndolo por secciones (`##`)
2. Construye un índice TF-IDF con el contenido
3. Cuando el usuario pregunta, busca las secciones más relevantes
4. Muestra la respuesta en un chat bonito

## 💛 Apoyar y Compartir

**Sé parte del cambio. Compártelo y haz que llegue a quien lo necesite.**

Un programador español ha creado este paquete para que **CUALQUIER app Flutter** pueda tener un asistente FAQ privado, offline y gratuito. Sin big tech, sin suscripciones, sin datos en la nube. **Cada café que invitas** es combustible para seguir creando algo que el mundo necesita.

- [☕ Apoyar en Ko-fi (Desde 3€)](https://ko-fi.com/C0C11TWR1K)
- [💙 Donar con PayPal (Libre)](https://www.paypal.com/paypalme/erbolamm)

---

### 💥 Compártelo. Que se entere todo el mundo

- [𝕏 Compartir en Twitter / X](https://twitter.com/intent/tweet?text=Mira%20este%20paquete%20para%20Flutter%3A%20un%20asistente%20FAQ%20offline%2C%20privado%20y%20gratis.%20Perfecto%20para%20cualquier%20app.%20%23FlutterDev%20%23Dart%20%40erbolamm%0A%0Ahttps%3A%2F%2Fpub.dev%2Fpackages%2Fapliarte_faq)
- [💼 Compartir en LinkedIn](https://www.linkedin.com/sharing/share-offsite/?url=https%3A%2F%2Fpub.dev%2Fpackages%2Fapliarte_faq)
- [💬 Compartir en WhatsApp](https://wa.me/?text=Mira%20este%20paquete%20para%20Flutter%3A%20un%20asistente%20FAQ%20offline%2C%20privado%20y%20gratis.%20Perfecto%20para%20cualquier%20app.%20%0A%0Ahttps%3A%2F%2Fpub.dev%2Fpackages%2Fapliarte_faq)
- [✈️ Compartir en Telegram](https://t.me/share/url?url=https%3A%2F%2Fpub.dev%2Fpackages%2Fapliarte_faq&text=Un%20asistente%20FAQ%20offline%20para%20Flutter.%20Privado%20y%20gratis.)
- [📧 Compartir por Email](mailto:?subject=Paquete%20asistente%20FAQ%20offline%20para%20Flutter&body=Mira%20este%20paquete%20que%20convierte%20cualquier%20app%20en%20un%20asistente%20FAQ%20privado%20sin%20internet%3A%20https%3A%2F%2Fpub.dev%2Fpackages%2Fapliarte_faq)

---

## 🌐 Autor y Enlaces

Esto lo está construyendo **una sola persona**, sin empresa detrás, sin inversores, sin equipo de marketing. Solo un programador español que cree que la tecnología debe ser accesible para todos.

- [𝕏 Seguir @erbolamm](https://twitter.com/erbolamm)
- [👤 GitHub: erbolamm](https://github.com/erbolamm)
- [🌐 ApliArte.com](https://apliarte.com)

> "O se gana, o se aprende" — El lema que mantiene vivo este proyecto.

> 🦀 Creado con ❤️ por Francisco de [ApliArte.com](https://apliarte.com) · España · 2026

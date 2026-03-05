# apliarte_faq

Asistente FAQ offline para apps Flutter. Responde preguntas de usuarios desde un archivo `.md`. 100% offline, sin IA, sin dependencias externas.

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

## Autor

ApliArte — [apliarte.com](https://apliarte.com)

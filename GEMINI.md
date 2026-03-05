# 🤖 Proyecto apliarte_faq — Contexto para Agentes IA

## Qué es este proyecto

Paquete Flutter que añade un **asistente FAQ offline** a cualquier app.
Lee un archivo `.md` y responde preguntas de usuarios sin necesitar internet ni modelo de IA.

## Reglas del usuario

1. **EXPLICAR ANTES DE CODEAR** con analogías de Flutter
2. **TERMINAL SIEMPRE VISIBLE**
3. **NO BORRAR SIN CONFIRMAR**
4. **WARNINGS SON INACEPTABLES**

## Stack

- **Lenguaje**: Dart puro + Flutter SDK
- **Sin dependencias externas**
- **Motor**: Búsqueda TF-IDF sobre Markdown

---

## 🎯 INSTRUCCIONES PARA AGENTES: Configurar FAQ para una app

Cuando un desarrollador instale este paquete y pida ayuda para configurarlo,
sigue este flujo de **5 pasos**:

### Paso 1: Analizar la estructura de la app

Antes de escribir NADA, analiza la app del usuario:
- Lee el `pubspec.yaml` para entender dependencias y nombre
- Busca los screens/pages principales (`lib/`)
- Identifica el flujo de onboarding si existe
- Busca documentación existente (`README.md`, `HELP.md`, etc.)

### Paso 2: Preguntar al usuario

Haz TODAS estas preguntas antes de generar código:

1. **¿Cuáles son las 5 preguntas más frecuentes de tus usuarios?**
2. **¿Tu app tiene pasos de configuración inicial?** Si sí, ¿cuántos?
3. **¿Qué funcionalidades "ocultas" tiene tu app que los usuarios no descubren?**
4. **¿Prefiere tema claro, oscuro, o que siga el sistema?**
5. **¿En qué idioma(s) deben ser las respuestas?**
6. **¿Dónde quieres que aparezca el botón del FAQ?** (flotante, menú, settings)

### Paso 3: Generar el archivo `ayuda.md`

Con las respuestas, genera un archivo `.md` optimizado:
- Usa headers `##` para cada tema
- Escribe en lenguaje natural y cercano (como si hablaras con un amigo)
- Incluye pasos numerados para procesos
- Añade emojis para hacer visualmente escaneable
- Ordena las secciones por frecuencia de consulta (las más preguntadas primero)

### Paso 4: Configurar el widget

Genera el código de integración adaptado a la app:

```dart
// Adaptar colores al ColorScheme de la app
final appColor = Theme.of(context).colorScheme.primary;

ApliFaqButton(
  markdownAsset: 'assets/ayuda.md',
  appName: '[NOMBRE_DE_LA_APP]',
  themeColor: appColor,
);
```

### Paso 5: Verificar

- Comprobar que el `.md` está declarado en `flutter > assets` del `pubspec.yaml`
- Ejecutar la app y probar al menos 3 preguntas reales
- Verificar que las sugerencias automáticas son relevantes

---

## Arquitectura del paquete

```
lib/
├── apliarte_faq.dart             # Exports públicos
└── src/
    ├── engine/
    │   ├── faq_engine.dart        # Motor principal (carga .md, responde)
    │   ├── markdown_parser.dart   # Divide .md por headers
    │   ├── search_index.dart      # Índice TF-IDF
    │   └── models.dart            # FaqSection, FaqResult, FaqMessage
    └── ui/
        ├── faq_button.dart        # FloatingActionButton con pulso
        ├── faq_chat.dart          # BottomSheet con chat completo
        ├── faq_message.dart       # Burbuja de mensaje
        └── faq_theme.dart         # Theming (claro/oscuro)
```

## API pública

- `ApliFaqButton` — Widget flotante que abre el chat
- `ApliFaqChat` — Widget del chat completo
- `FaqEngine` — Motor de búsqueda (uso programático)
- `ApliFaqTheme` — Personalización de colores/textos

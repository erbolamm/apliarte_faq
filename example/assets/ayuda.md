# Documentación de apliarte_faq

## Qué es apliarte_faq

**apliarte_faq** es un paquete Flutter que convierte cualquier archivo Markdown (.md) en un asistente FAQ interactivo dentro de tu app. Funciona 100% offline, sin IA, sin dependencias externas y sin enviar datos a ningún servidor.

Simplemente escribes tu documentación en un archivo .md, lo metes como asset, y el paquete se encarga de todo: parsear el contenido, indexarlo con TF-IDF y mostrarlo en un chat bonito.

Creado por Javier Mateo (erbolamm) de ApliArte.com en España.

## Cómo instalar el paquete

Para instalar apliarte_faq en tu proyecto Flutter:

1. Añade la dependencia en tu `pubspec.yaml`:

```yaml
dependencies:
  apliarte_faq: ^1.0.0
```

2. Crea un archivo Markdown con tu documentación (por ejemplo `assets/ayuda.md`)

3. Declara el asset en tu `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/ayuda.md
```

4. Importa el paquete en tu código:

```dart
import 'package:apliarte_faq/apliarte_faq.dart';
```

## Cómo usar ApliFaqButton

**ApliFaqButton** es el widget principal del paquete. Es un botón flotante (FloatingActionButton) que al pulsarlo abre el chat FAQ en un bottom sheet.

Uso mínimo (solo 2 parámetros obligatorios):

```dart
Scaffold(
  floatingActionButton: ApliFaqButton(
    markdownAsset: 'assets/ayuda.md',
    appName: 'MiApp',
  ),
);
```

El botón tiene una animación de pulso cuando está listo para usarse. Mientras carga el contenido muestra un indicador de progreso circular.

### Parámetros de ApliFaqButton

- **markdownAsset** (obligatorio): Ruta al archivo .md dentro de tus assets. Ejemplo: `'assets/ayuda.md'`
- **appName** (obligatorio): Nombre de tu app. Se muestra en la cabecera del chat como "Asistente MiApp"
- **themeColor**: Color principal del botón y del chat. Ejemplo: `Colors.blue`
- **theme**: Tema completo personalizado de tipo ApliFaqTheme. Si se proporciona, tiene prioridad sobre themeColor
- **sheetHeight**: Altura del bottom sheet como fracción de la pantalla. Va de 0.0 a 1.0. Por defecto es 0.85 (85% de la pantalla)

## Cómo personalizar el tema con ApliFaqTheme

**ApliFaqTheme** te permite personalizar completamente el aspecto visual del chat. Es como un ThemeData pero específico para el widget FAQ.

Ejemplo de tema personalizado:

```dart
ApliFaqButton(
  markdownAsset: 'assets/ayuda.md',
  appName: 'MiApp',
  theme: ApliFaqTheme(
    primaryColor: Colors.teal,
    backgroundColor: Color(0xFFF0F4F8),
    userBubbleColor: Colors.teal,
    assistantBubbleColor: Colors.white,
    bubbleRadius: 20.0,
    fabIcon: Icons.help_outline,
    hintText: '¿Tienes alguna duda?',
    greetingText: '¡Bienvenido! Pregúntame lo que quieras.',
  ),
);
```

### Propiedades de ApliFaqTheme

- **primaryColor**: Color principal del chat, botón y acentos. Por defecto es un morado (0xFF6C5CE7)
- **backgroundColor**: Fondo del chat. Por defecto gris claro (0xFFF8F9FA)
- **userBubbleColor**: Color de las burbujas de mensajes del usuario. Por defecto igual que primaryColor
- **assistantBubbleColor**: Color de las burbujas del asistente. Por defecto blanco
- **userTextColor**: Color del texto en burbujas del usuario. Por defecto blanco
- **assistantTextColor**: Color del texto del asistente. Por defecto gris oscuro (0xFF2D3436)
- **bubbleRadius**: Radio de las esquinas de las burbujas. Por defecto 18.0 píxeles
- **fabIcon**: Icono del botón flotante. Por defecto Icons.chat_rounded
- **hintText**: Texto placeholder del campo de entrada. Por defecto 'Escribe tu pregunta...'
- **greetingText**: Mensaje de bienvenida del asistente al abrir el chat. Por defecto '¡Hola! ¿En qué puedo ayudarte?'

## Cómo usar el tema oscuro

El paquete incluye un tema oscuro predefinido listo para usar:

```dart
ApliFaqButton(
  markdownAsset: 'assets/ayuda.md',
  appName: 'MiApp',
  theme: ApliFaqTheme.dark(),
);
```

El tema oscuro usa fondo oscuro (0xFF1E1E2E), burbujas del asistente en gris oscuro (0xFF2D2D44) y un primaryColor lila (0xFFA29BFE). Puedes modificarlo con copyWith:

```dart
ApliFaqTheme.dark().copyWith(
  primaryColor: Colors.cyan,
  greetingText: '¡Hola! Modo oscuro activado.',
)
```

## Cómo funciona el motor de búsqueda

El motor FAQ usa un algoritmo TF-IDF (Term Frequency - Inverse Document Frequency) para encontrar las respuestas más relevantes. Así funciona:

1. **Parseo**: El MarkdownParser divide tu archivo .md por headers (#, ##, ###) creando una FaqSection por cada sección
2. **Indexación**: El SearchIndex construye un índice TF-IDF calculando el peso de cada palabra en cada sección
3. **Búsqueda**: Cuando el usuario pregunta, tokeniza la consulta y calcula la puntuación de cada sección
4. **Relevancia**: Las coincidencias en el título reciben un bonus de 1.5x. También se buscan coincidencias parciales (prefijos)
5. **Respuesta**: Si la puntuación es alta, muestra la mejor sección. Si es baja, muestra varias opciones

Todo esto ocurre localmente en el dispositivo, sin internet ni servidor externo.

## Cómo usar FaqEngine directamente

Si quieres más control, puedes usar **FaqEngine** directamente sin el widget de chat:

```dart
// Desde un asset
final engine = await FaqEngine.fromAsset('assets/ayuda.md');

// Desde un string
final engine = FaqEngine.fromString('## Título\nContenido aquí...');

// Buscar
final results = engine.search('mi pregunta', maxResults: 3);
for (final result in results) {
  print('${result.section.title} - Score: ${result.score}');
}

// Obtener respuesta formateada
final answer = engine.answer('mi pregunta');

// Ver todas las secciones
print('Secciones: ${engine.sectionCount}');

// Obtener sugerencias automáticas
final suggestions = engine.suggestions;
```

### Métodos de FaqEngine

- **fromAsset(path)**: Carga un .md desde los assets del proyecto (async)
- **fromString(markdown)**: Carga un .md desde un String (sync)
- **search(query, maxResults)**: Busca secciones relevantes. Devuelve List de FaqResult
- **answer(question, notFoundMessage)**: Devuelve una respuesta formateada como String
- **sections**: Lista de todas las FaqSection del documento
- **sectionCount**: Número total de secciones
- **suggestions**: Lista de hasta 5 preguntas sugeridas basadas en los títulos

## Cómo usar ApliFaqChat directamente

**ApliFaqChat** es el widget de chat completo. Normalmente lo abre ApliFaqButton, pero puedes usarlo directamente si quieres integrarlo en tu propia pantalla:

```dart
final engine = await FaqEngine.fromAsset('assets/ayuda.md');

Navigator.push(context, MaterialPageRoute(
  builder: (_) => Scaffold(
    body: ApliFaqChat(
      engine: engine,
      appName: 'MiApp',
      theme: ApliFaqTheme(primaryColor: Colors.green),
    ),
  ),
));
```

El chat incluye: mensaje de bienvenida, sugerencias de preguntas como chips tocables, burbujas de usuario y asistente, scroll automático y campo de texto con botón de enviar.

## Cómo escribir el archivo Markdown

El archivo .md es el corazón del sistema. Cada sección con header (##) se convierte en una respuesta independiente. Consejos:

1. Usa headers de nivel 2 (##) para las preguntas principales
2. Escribe títulos descriptivos que incluyan las palabras clave que buscaría el usuario
3. El contenido debajo de cada header es la respuesta
4. Puedes usar listas, negritas y formato Markdown normal
5. Cuantas más palabras clave tenga una sección, más fácil será encontrarla

Ejemplo de estructura ideal:

```markdown
# Mi App - Ayuda

## Cómo empezar a usar la app
Contenido de ayuda aquí...

## Qué funciones tiene la app
Lista de funciones...

## Cómo contactar con soporte
Datos de contacto...
```

## Qué modelos de datos tiene el paquete

El paquete tiene 3 modelos principales:

**FaqSection** - Representa una sección del documento:
- title: Título de la sección (texto del header)
- content: Contenido debajo del header
- level: Nivel del header (1, 2 o 3)
- index: Posición original en el documento
- fullText: Concatenación de título + contenido

**FaqResult** - Resultado de una búsqueda:
- section: La FaqSection encontrada
- score: Puntuación de relevancia (0.0 a 1.0)

**FaqMessage** - Mensaje del chat:
- text: Texto del mensaje
- isUser: true si lo envió el usuario, false si es del asistente
- timestamp: Fecha y hora del mensaje

## Qué ventajas tiene sobre otros paquetes FAQ

- **100% offline**: No necesita internet ni servidores
- **Sin IA**: No depende de OpenAI, Gemini ni ningún servicio externo
- **Sin dependencias**: Solo usa Flutter, no añade paquetes de terceros
- **Privacidad total**: Los datos del usuario nunca salen del dispositivo
- **Fácil de usar**: Solo necesitas un archivo .md y 3 líneas de código
- **Personalizable**: Tema completo con colores, iconos y textos
- **Tema oscuro**: Incluido de fábrica con ApliFaqTheme.dark()
- **Ligero**: Sin overhead, sin conexiones, sin APIs

## Qué es TF-IDF

TF-IDF significa "Term Frequency - Inverse Document Frequency". Es un algoritmo clásico de recuperación de información que calcula la importancia de una palabra en un documento dentro de una colección.

- **TF (Term Frequency)**: Cuántas veces aparece una palabra en una sección
- **IDF (Inverse Document Frequency)**: Penaliza palabras que aparecen en muchas secciones (como "el", "de", "que")
- **Score**: TF × IDF = peso final de la palabra

Resultado: las palabras específicas y poco comunes tienen más peso que las genéricas. Esto hace que las búsquedas sean precisas sin necesidad de IA.

## Dónde descargar las apps de ApliArte

Todas las apps de ApliArte están disponibles en las tiendas oficiales:

- **Google Play Store**: https://play.google.com/store/apps/dev?id=6466996461793257312
- **Apple App Store**: https://apps.apple.com/es/developer/francisco-mateo-marquez/id990577710
- **Página de apps**: https://www.apliarte.com/p/apps-para-ti.html

## Qué apps tiene ApliArte

ApliArte tiene varias apps publicadas:

- **Calca App**: App para aumentar el tamaño de imágenes. Permite calcar, dibujar y editar con cámara. Disponible en iOS y Android
- **ApliArte Click**: Herramienta Open Source de autoclick y macros para Windows y macOS. Automatización con precisión extrema (versión 3.0.0 Advanced)
- **Lector QR**: App para escanear códigos QR de forma rápida y sencilla

Todas las apps están creadas con Flutter por Javier Mateo (erbolamm).

## Dónde encontrar a ApliArte en redes sociales

Puedes seguir a ApliArte y a Javier Mateo en estas plataformas:

- **Web oficial**: https://www.apliarte.com
- **GitHub**: https://github.com/erbolamm
- **X / Twitter**: https://twitter.com/erbolamm
- **Twitch**: https://www.twitch.tv/apliarte
- **YouTube**: https://www.youtube.com/@TutoGratiJavierApliArte

## Quién ha creado este paquete

Este paquete ha sido creado por **Javier Mateo** (erbolamm) de **ApliArte.com**, un programador español independiente. Todo lo que ha conseguido ha sido por su esfuerzo, persistencia y creatividad.

- Web: https://www.apliarte.com
- GitHub: https://github.com/erbolamm
- X/Twitter: https://twitter.com/erbolamm
- Página de apps: https://www.apliarte.com/p/apps-para-ti.html

"O se gana, o se aprende" — El lema que mantiene vivo este proyecto.

## Cómo apoyar el proyecto

Si quieres apoyar a ApliArte y ayudar a que siga creando herramientas gratuitas:

- **Ko-fi (desde 3€)**: https://ko-fi.com/C0C11TWR1K
- **PayPal (libre)**: https://www.paypal.com/paypalme/erbolamm
- **Compartir**: Comparte el paquete en redes sociales para que llegue a más desarrolladores
- **Estrella en GitHub**: Dale una estrella al repositorio en GitHub

Cada café que invitas es combustible para seguir creando software libre y accesible.

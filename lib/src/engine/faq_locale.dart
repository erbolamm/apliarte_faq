/// Soporte multilingüe para apliarte_faq.
///
/// Cada [FaqLocale] contiene los textos del UI y las stopwords
/// para un idioma. Se puede pasar al tema o al engine.
class FaqLocale {
  /// Código ISO 639-1 del idioma.
  final String code;

  /// Texto de saludo al abrir el chat.
  final String greeting;

  /// Placeholder del campo de texto.
  final String hintText;

  /// Mensaje cuando no se encuentra respuesta.
  final String notFoundMessage;

  /// Etiqueta de sugerencias.
  final String suggestionsLabel;

  /// Prefijo para generar preguntas automáticas.
  final String questionPrefix;

  /// Palabras vacías que se ignoran en la búsqueda.
  final Set<String> stopWords;

  const FaqLocale({
    required this.code,
    required this.greeting,
    required this.hintText,
    required this.notFoundMessage,
    required this.suggestionsLabel,
    required this.questionPrefix,
    required this.stopWords,
  });

  // ─── IDIOMAS PREDEFINIDOS ────────────────────────────────

  static const es = FaqLocale(
    code: 'es',
    greeting: '¡Hola! ¿En qué puedo ayudarte?',
    hintText: 'Escribe tu pregunta...',
    notFoundMessage:
        '🤔 No he encontrado información sobre eso. Prueba con otras palabras.',
    suggestionsLabel: 'Preguntas frecuentes:',
    questionPrefix: '¿Cómo funciona',
    stopWords: _esStopWords,
  );

  static const en = FaqLocale(
    code: 'en',
    greeting: 'Hi! How can I help you?',
    hintText: 'Type your question...',
    notFoundMessage:
        "🤔 I couldn't find information about that. Try different words.",
    suggestionsLabel: 'Frequently asked:',
    questionPrefix: 'How does',
    stopWords: _enStopWords,
  );

  static const fr = FaqLocale(
    code: 'fr',
    greeting: 'Bonjour ! Comment puis-je vous aider ?',
    hintText: 'Écrivez votre question...',
    notFoundMessage:
        "🤔 Je n'ai pas trouvé d'information à ce sujet. Essayez d'autres mots.",
    suggestionsLabel: 'Questions fréquentes :',
    questionPrefix: 'Comment fonctionne',
    stopWords: _frStopWords,
  );

  static const de = FaqLocale(
    code: 'de',
    greeting: 'Hallo! Wie kann ich Ihnen helfen?',
    hintText: 'Schreiben Sie Ihre Frage...',
    notFoundMessage:
        '🤔 Ich habe keine Informationen dazu gefunden. Versuchen Sie andere Wörter.',
    suggestionsLabel: 'Häufig gestellte Fragen:',
    questionPrefix: 'Wie funktioniert',
    stopWords: _deStopWords,
  );

  static const pt = FaqLocale(
    code: 'pt',
    greeting: 'Olá! Como posso ajudá-lo?',
    hintText: 'Escreva sua pergunta...',
    notFoundMessage:
        '🤔 Não encontrei informações sobre isso. Tente outras palavras.',
    suggestionsLabel: 'Perguntas frequentes:',
    questionPrefix: 'Como funciona',
    stopWords: _ptStopWords,
  );

  static const it = FaqLocale(
    code: 'it',
    greeting: 'Ciao! Come posso aiutarti?',
    hintText: 'Scrivi la tua domanda...',
    notFoundMessage:
        '🤔 Non ho trovato informazioni a riguardo. Prova con altre parole.',
    suggestionsLabel: 'Domande frequenti:',
    questionPrefix: 'Come funziona',
    stopWords: _itStopWords,
  );

  static const ru = FaqLocale(
    code: 'ru',
    greeting: 'Привет! Чем могу помочь?',
    hintText: 'Напишите ваш вопрос...',
    notFoundMessage:
        '🤔 Не нашёл информации по этому вопросу. Попробуйте другие слова.',
    suggestionsLabel: 'Частые вопросы:',
    questionPrefix: 'Как работает',
    stopWords: _ruStopWords,
  );

  static const zh = FaqLocale(
    code: 'zh',
    greeting: '你好！有什么可以帮你的？',
    hintText: '输入你的问题...',
    notFoundMessage: '🤔 没有找到相关信息，请尝试其他关键词。',
    suggestionsLabel: '常见问题：',
    questionPrefix: '如何',
    stopWords: _zhStopWords,
  );

  static const ja = FaqLocale(
    code: 'ja',
    greeting: 'こんにちは！何かお手伝いしましょうか？',
    hintText: '質問を入力してください...',
    notFoundMessage: '🤔 該当する情報が見つかりませんでした。別のキーワードをお試しください。',
    suggestionsLabel: 'よくある質問：',
    questionPrefix: 'どうやって',
    stopWords: _jaStopWords,
  );

  static const ko = FaqLocale(
    code: 'ko',
    greeting: '안녕하세요! 무엇을 도와드릴까요?',
    hintText: '질문을 입력하세요...',
    notFoundMessage: '🤔 관련 정보를 찾지 못했습니다. 다른 키워드를 시도해 보세요.',
    suggestionsLabel: '자주 묻는 질문:',
    questionPrefix: '어떻게',
    stopWords: _koStopWords,
  );

  static const ar = FaqLocale(
    code: 'ar',
    greeting: 'مرحباً! كيف يمكنني مساعدتك؟',
    hintText: 'اكتب سؤالك...',
    notFoundMessage:
        '🤔 لم أتمكن من العثور على معلومات حول ذلك. جرب كلمات أخرى.',
    suggestionsLabel: 'الأسئلة الشائعة:',
    questionPrefix: 'كيف يعمل',
    stopWords: _arStopWords,
  );

  static const hi = FaqLocale(
    code: 'hi',
    greeting: 'नमस्ते! मैं आपकी कैसे मदद कर सकता हूँ?',
    hintText: 'अपना सवाल लिखें...',
    notFoundMessage:
        '🤔 इसके बारे में जानकारी नहीं मिली। अन्य शब्दों से प्रयास करें।',
    suggestionsLabel: 'अक्सर पूछे जाने वाले सवाल:',
    questionPrefix: 'कैसे काम करता है',
    stopWords: _hiStopWords,
  );

  static const tr = FaqLocale(
    code: 'tr',
    greeting: 'Merhaba! Size nasıl yardımcı olabilirim?',
    hintText: 'Sorunuzu yazın...',
    notFoundMessage: '🤔 Bu konuda bilgi bulamadım. Farklı kelimeler deneyin.',
    suggestionsLabel: 'Sık sorulan sorular:',
    questionPrefix: 'Nasıl çalışır',
    stopWords: _trStopWords,
  );

  static const pl = FaqLocale(
    code: 'pl',
    greeting: 'Cześć! Jak mogę Ci pomóc?',
    hintText: 'Napisz swoje pytanie...',
    notFoundMessage:
        '🤔 Nie znalazłem informacji na ten temat. Spróbuj innych słów.',
    suggestionsLabel: 'Często zadawane pytania:',
    questionPrefix: 'Jak działa',
    stopWords: _plStopWords,
  );

  static const vi = FaqLocale(
    code: 'vi',
    greeting: 'Xin chào! Tôi có thể giúp gì cho bạn?',
    hintText: 'Nhập câu hỏi của bạn...',
    notFoundMessage:
        '🤔 Không tìm thấy thông tin về vấn đề này. Hãy thử từ khóa khác.',
    suggestionsLabel: 'Câu hỏi thường gặp:',
    questionPrefix: 'Cách hoạt động',
    stopWords: _viStopWords,
  );

  static const id = FaqLocale(
    code: 'id',
    greeting: 'Halo! Ada yang bisa saya bantu?',
    hintText: 'Tulis pertanyaan Anda...',
    notFoundMessage:
        '🤔 Tidak menemukan informasi tentang itu. Coba kata lain.',
    suggestionsLabel: 'Pertanyaan umum:',
    questionPrefix: 'Bagaimana cara',
    stopWords: _idStopWords,
  );

  static const fa = FaqLocale(
    code: 'fa',
    greeting: 'سلام! چطور می‌توانم کمکتان کنم؟',
    hintText: 'سؤال خود را بنویسید...',
    notFoundMessage:
        '🤔 اطلاعاتی در این مورد پیدا نشد. کلمات دیگری امتحان کنید.',
    suggestionsLabel: 'سؤالات متداول:',
    questionPrefix: 'چگونه کار می‌کند',
    stopWords: _faStopWords,
  );

  /// Mapa de todos los locales disponibles por código ISO.
  static const Map<String, FaqLocale> all = {
    'es': es,
    'en': en,
    'fr': fr,
    'de': de,
    'pt': pt,
    'it': it,
    'ru': ru,
    'zh': zh,
    'ja': ja,
    'ko': ko,
    'ar': ar,
    'hi': hi,
    'tr': tr,
    'pl': pl,
    'vi': vi,
    'id': id,
    'fa': fa,
  };

  /// Obtiene un locale por código ISO. Si no existe, devuelve inglés.
  static FaqLocale fromCode(String code) {
    final shortCode = code.split('_').first.split('-').first.toLowerCase();
    return all[shortCode] ?? en;
  }
}

// ─── STOPWORDS POR IDIOMA ──────────────────────────────────────

const _esStopWords = <String>{
  'los',
  'las',
  'una',
  'uno',
  'del',
  'que',
  'por',
  'para',
  'con',
  'sin',
  'desde',
  'hasta',
  'como',
  'mas',
  'pero',
  'este',
  'esta',
  'estos',
  'estas',
  'ese',
  'esa',
  'esos',
  'esas',
  'son',
  'hay',
  'ser',
  'tiene',
  'puede',
  'tambien',
  'cuando',
  'donde',
  'todo',
  'toda',
  'todos',
  'todas',
  'otro',
  'otra',
  'otros',
  'muy',
  'tan',
  'solo',
  'bien',
  'aqui',
  'asi',
  'nos',
  'les',
  'cual',
  'quien',
  'cada',
  'entre',
  'sobre',
  'tras',
  'ante',
  'quiero',
  'necesito',
  'puedo',
  'tengo',
  'hago',
};

const _enStopWords = <String>{
  'the',
  'and',
  'for',
  'are',
  'but',
  'not',
  'you',
  'all',
  'can',
  'her',
  'was',
  'one',
  'our',
  'out',
  'has',
  'have',
  'with',
  'this',
  'that',
  'from',
  'they',
  'been',
  'will',
  'more',
  'what',
  'how',
  'why',
  'when',
  'where',
  'which',
  'would',
  'could',
  'should',
  'does',
  'did',
  'had',
  'just',
  'than',
};

const _frStopWords = <String>{
  'les',
  'des',
  'une',
  'que',
  'par',
  'pour',
  'avec',
  'dans',
  'sur',
  'est',
  'son',
  'pas',
  'plus',
  'mais',
  'tout',
  'bien',
  'ont',
  'ses',
  'aux',
  'cette',
  'nous',
  'vous',
  'leur',
  'qui',
  'quoi',
  'comment',
  'aussi',
  'fait',
  'peut',
  'entre',
};

const _deStopWords = <String>{
  'der',
  'die',
  'das',
  'den',
  'dem',
  'ein',
  'eine',
  'und',
  'ist',
  'sind',
  'hat',
  'mit',
  'auf',
  'fur',
  'von',
  'aus',
  'als',
  'auch',
  'sich',
  'nicht',
  'noch',
  'nach',
  'bei',
  'wie',
  'was',
  'wer',
  'kann',
  'wird',
  'haben',
  'werden',
};

const _ptStopWords = <String>{
  'que',
  'para',
  'com',
  'por',
  'uma',
  'dos',
  'das',
  'nos',
  'tem',
  'seu',
  'sua',
  'mais',
  'mas',
  'como',
  'foi',
  'ser',
  'esta',
  'este',
  'isso',
  'quando',
  'muito',
  'pode',
  'tambem',
};

const _itStopWords = <String>{
  'che',
  'per',
  'con',
  'una',
  'dei',
  'del',
  'gli',
  'sono',
  'non',
  'sua',
  'suo',
  'come',
  'dal',
  'alla',
  'nel',
  'anche',
  'questo',
  'questa',
  'quello',
  'quella',
  'ogni',
  'molto',
};

const _ruStopWords = <String>{
  'что',
  'как',
  'для',
  'это',
  'все',
  'она',
  'они',
  'его',
  'при',
  'или',
  'так',
  'уже',
  'где',
  'тут',
  'вот',
  'был',
  'быть',
  'есть',
  'нет',
  'без',
  'над',
  'под',
};

const _zhStopWords = <String>{
  '的',
  '了',
  '在',
  '是',
  '我',
  '有',
  '和',
  '就',
  '不',
  '人',
  '都',
  '一',
  '个',
  '上',
  '也',
  '很',
  '到',
  '说',
  '要',
  '去',
  '你',
  '会',
  '着',
  '没有',
  '看',
  '好',
  '自己',
  '这',
  '他',
};

const _jaStopWords = <String>{
  'の',
  'に',
  'は',
  'を',
  'た',
  'が',
  'で',
  'て',
  'と',
  'し',
  'れ',
  'さ',
  'ある',
  'いる',
  'する',
  'から',
  'こと',
  'として',
  'です',
  'ます',
  'この',
  'その',
  'ない',
  'なる',
  'もの',
};

const _koStopWords = <String>{
  '이',
  '그',
  '저',
  '것',
  '수',
  '등',
  '및',
  '더',
  '또',
  '를',
  '은',
  '는',
  '에',
  '의',
  '가',
  '로',
  '으로',
};

const _arStopWords = <String>{
  'في',
  'من',
  'على',
  'إلى',
  'عن',
  'مع',
  'هذا',
  'هذه',
  'ذلك',
  'التي',
  'الذي',
  'كان',
  'قد',
  'لا',
  'ما',
  'هو',
  'هي',
  'أن',
  'بين',
  'كل',
  'بعد',
  'لم',
  'عند',
};

const _hiStopWords = <String>{
  'और',
  'का',
  'की',
  'के',
  'में',
  'है',
  'को',
  'से',
  'पर',
  'इस',
  'यह',
  'वह',
  'भी',
  'कर',
  'हैं',
  'था',
  'एक',
  'नहीं',
};

const _trStopWords = <String>{
  'bir',
  'ile',
  'var',
  'olan',
  'den',
  'dan',
  'gibi',
  'daha',
  'kadar',
  'sonra',
  'icin',
  'veya',
  'ama',
  'hem',
  'nasil',
  'neden',
  'hangi',
  'kendi',
  'bazi',
  'her',
};

const _plStopWords = <String>{
  'nie',
  'tak',
  'jak',
  'ale',
  'czy',
  'lub',
  'aby',
  'dla',
  'jest',
  'jego',
  'jej',
  'ich',
  'ten',
  'tego',
  'tym',
  'gdy',
  'bez',
  'pod',
  'nad',
  'przy',
  'przez',
  'przed',
};

const _viStopWords = <String>{
  'cua',
  'cho',
  'voi',
  'trong',
  'nay',
  'khi',
  'nhung',
  'cac',
  'mot',
  'nhu',
  'hay',
  'roi',
  'thi',
  'duoc',
  'deu',
  'con',
  'rat',
  'lam',
  'bao',
  'nen',
};

const _idStopWords = <String>{
  'yang',
  'dan',
  'ini',
  'itu',
  'dari',
  'untuk',
  'dengan',
  'pada',
  'ada',
  'atau',
  'juga',
  'akan',
  'oleh',
  'sudah',
  'tidak',
  'bisa',
  'saya',
  'anda',
  'kami',
  'mereka',
};

const _faStopWords = <String>{
  'از',
  'با',
  'در',
  'به',
  'که',
  'این',
  'آن',
  'است',
  'را',
  'هم',
  'برای',
  'تا',
  'یا',
  'اگر',
  'بر',
  'نیز',
};

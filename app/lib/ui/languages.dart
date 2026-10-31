/// Languages offered in setup: code, flag and endonym.
class Language {
  const Language(this.code, this.flag, this.name);
  final String code;
  final String flag;
  final String name;
}

const languages = <Language>[
  Language('cs', '🇨🇿', 'Čeština'),
  Language('en', '🇬🇧', 'English'),
  Language('de', '🇩🇪', 'Deutsch'),
  Language('uk', '🇺🇦', 'Українська'),
  Language('vi', '🇻🇳', 'Tiếng Việt'),
  Language('pl', '🇵🇱', 'Polski'),
  Language('sk', '🇸🇰', 'Slovenčina'),
  Language('es', '🇪🇸', 'Español'),
  Language('fr', '🇫🇷', 'Français'),
  Language('it', '🇮🇹', 'Italiano'),
  Language('pt', '🇵🇹', 'Português'),
  Language('ja', '🇯🇵', '日本語'),
  Language('zh', '🇨🇳', '中文'),
];

Language languageOf(String code) => languages.firstWhere(
  (l) => l.code == code,
  orElse: () => Language(code, '🏳️', code),
);

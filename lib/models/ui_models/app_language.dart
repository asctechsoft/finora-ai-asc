import 'package:flutter/widgets.dart';

/// The languages TrackFlow offers in the picker.
///
/// Matches the locales `dsp_base` ships strings for. TrackFlow's own strings
/// currently exist for `en` (lib/xml_strings/values) and `vi` (values-vi);
/// the rest fall back to English until their `values-xx/strings.xml` is added.
class AppLanguage {
  /// Stored in prefs as `<languageCode>_<countryCode>`.
  final String code;
  final Locale locale;

  /// Shown in the language's own script, the way language pickers normally do.
  final String label;
  final String flag;

  const AppLanguage(this.code, this.locale, this.label, this.flag);

  static const english = AppLanguage('en_US', Locale('en', 'US'), 'English', '🇺🇸');
  static const vietnamese = AppLanguage('vi_VN', Locale('vi', 'VN'), 'Tiếng Việt', '🇻🇳');
  static const french = AppLanguage('fr_FR', Locale('fr', 'FR'), 'Français', '🇫🇷');
  static const italian = AppLanguage('it_IT', Locale('it', 'IT'), 'Italiano', '🇮🇹');
  static const german = AppLanguage('de_DE', Locale('de', 'DE'), 'Deutsch', '🇩🇪');
  static const spanish = AppLanguage('es_ES', Locale('es', 'ES'), 'Español', '🇪🇸');
  static const russian = AppLanguage('ru_RU', Locale('ru', 'RU'), 'Русский', '🇷🇺');
  static const portuguese = AppLanguage('pt_PT', Locale('pt', 'PT'), 'Português', '🇵🇹');
  static const turkish = AppLanguage('tr_TR', Locale('tr', 'TR'), 'Türkçe', '🇹🇷');
  static const arabic = AppLanguage('ar_SA', Locale('ar', 'SA'), 'العربية', '🇸🇦');
  static const indonesian = AppLanguage('id_ID', Locale('id', 'ID'), 'Bahasa Indonesia', '🇮🇩');
  static const persian = AppLanguage('fa_IR', Locale('fa', 'IR'), 'فارسی', '🇮🇷');
  static const chineseSimplified = AppLanguage('zh_CN', Locale('zh', 'CN'), '简体中文', '🇨🇳');
  static const chineseTraditional = AppLanguage('zh_TW', Locale('zh', 'TW'), '繁體中文', '🇹🇼');
  static const japanese = AppLanguage('ja_JP', Locale('ja', 'JP'), '日本語', '🇯🇵');
  static const korean = AppLanguage('ko_KR', Locale('ko', 'KR'), '한국어', '🇰🇷');

  static const List<AppLanguage> all = [
    english,
    vietnamese,
    french,
    italian,
    german,
    spanish,
    russian,
    portuguese,
    turkish,
    arabic,
    indonesian,
    persian,
    chineseSimplified,
    chineseTraditional,
    japanese,
    korean,
  ];

  static const List<Locale> locales = [
    Locale('en', 'US'),
    Locale('vi', 'VN'),
    Locale('fr', 'FR'),
    Locale('it', 'IT'),
    Locale('de', 'DE'),
    Locale('es', 'ES'),
    Locale('ru', 'RU'),
    Locale('pt', 'PT'),
    Locale('tr', 'TR'),
    Locale('ar', 'SA'),
    Locale('id', 'ID'),
    Locale('fa', 'IR'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
    Locale('ja', 'JP'),
    Locale('ko', 'KR'),
  ];

  static AppLanguage byCode(String? code) =>
      all.firstWhere((l) => l.code == code, orElse: () => english);

  static bool supportsLanguageCode(String? languageCode) =>
      all.any((l) => l.locale.languageCode == languageCode);

  /// Case-insensitive match on the native name or the locale code.
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    return q.isEmpty || label.toLowerCase().contains(q) || code.toLowerCase().contains(q);
  }
}

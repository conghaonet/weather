import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'application.dart';

/// 自定义的Translations类
class Translations {
  Locale locale;
  static Map<dynamic, dynamic> _localizedValues;

  Translations(Locale locale) {
    this.locale = locale;
    Translations._localizedValues = null;
  }

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  static Future<Translations> load(Locale locale) async {
    Translations translations = Translations(locale);
    String jsonContent = await rootBundle.loadString("locale/i18n_${locale.languageCode}.json");
    Translations._localizedValues = json.decode(jsonContent);
    return translations;
  }

  String getString(String key) {
    if(Translations._localizedValues == null) {
      return 'Translations._localizedValues is null, ** $key not found';
    } else {
      return Translations._localizedValues[key] ?? '** $key not found';
    }
  }

  String get currentLanguage => this.locale.languageCode;

}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return myApplication.supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) {
    return Translations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) {
    return false;
  }
}

class SpecificLocalizationDelegate extends LocalizationsDelegate<Translations> {
  final Locale overriddenLocale;

  const SpecificLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<Translations> load(Locale locale) => Translations.load(this.overriddenLocale);

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) => true;

}
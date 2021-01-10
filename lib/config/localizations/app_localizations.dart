import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Supported Languages
const SUPPORTED_LOCALES = [
  Locale('en', 'US'),
  Locale('es', 'ES'),
];

class AppLocalizations {
  final Locale _locale;
  final keySeparator = ".";
  Map<String, dynamic> _localizedMessages = {};

  AppLocalizations(this._locale);

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // This function will load the json file into memory to make it available for
  // the translation.
  Future<void> loadMessages() async {
    String jsonMessages;

    try {
      jsonMessages = await rootBundle
          .loadString("assets/lang/${_locale.languageCode}.json");
    } catch (_) {
      // If the device lang isn't supported, the default lang is English.
      jsonMessages = await rootBundle.loadString("assets/lang/en.json");
    }

    _localizedMessages = json.decode(jsonMessages);
  }

  // This function will search the keyWord and return a value.
  String translate(String key) {
    final _textTranslation = _decodeFromMap(key);

    if (_textTranslation != null && _textTranslation.isNotEmpty) {
      return _textTranslation;
    } else {
      return key;
    }
  }

  String _decodeFromMap(final String key) {
    final subMap = calculateSubmap(key);
    final lastKeyPart = key.split(keySeparator).last;

    final _textTranslation =
        subMap[lastKeyPart] is String ? subMap[lastKeyPart] : null;

    return _textTranslation;
  }

  Map<dynamic, dynamic> calculateSubmap(final String translationKey) {
    final translationKeySplitted = translationKey.split(
      keySeparator,
    );

    translationKeySplitted.removeLast();
    Map<dynamic, dynamic> decodedSubMap = _localizedMessages;

    translationKeySplitted.forEach(
        (listKey) => decodedSubMap = (decodedSubMap ?? {})[listKey] ?? {});
    return decodedSubMap;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This function determines which locales are supported in the delegate.
  @override
  bool isSupported(Locale locale) {
    final isSupported = SUPPORTED_LOCALES.firstWhere(
      (element) => element.languageCode == locale.languageCode,
      orElse: () => null,
    );
    return isSupported != null;
  }

  //This function load and return the localization to the delegate.
  @override
  Future<AppLocalizations> load(Locale locale) async {
    var appLocalizations = AppLocalizations(locale);
    await appLocalizations.loadMessages();
    Intl.defaultLocale = locale.languageCode;

    return appLocalizations;
  }

  // This function is the responsible to reload the localization.
  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

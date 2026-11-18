import 'package:cupertino_ui/cupertino_ui.dart';
// Only the widgets-layer pieces: the Material and Cupertino ones moved to
// material_ui and cupertino_ui (Flutter 3.50).
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalWidgetsLocalizations, kWidgetsSupportedLanguages;
import 'package:material_ui/material_ui.dart';

/// Flutter ships no Material/Cupertino/Widgets strings for some of the app's
/// languages (Hausa, Yorùbá and Igbo today). Without a delegate for them the
/// framework has no MaterialLocalizations and widgets like text fields, date
/// pickers and back buttons fail. These delegates fall back to English for
/// those framework strings only; the app's own text stays translated.
///
/// If a future Flutter release adds one of these languages, its real
/// localizations are used automatically.
const fallbackLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
    _FallbackMaterialDelegate(),
    _FallbackCupertinoDelegate(),
    _FallbackWidgetsDelegate(),
];

const _english = Locale('en');

class _FallbackMaterialDelegate extends LocalizationsDelegate<MaterialLocalizations> {
    const _FallbackMaterialDelegate();

    @override
    bool isSupported(Locale locale) => !kMaterialSupportedLanguages.contains(locale.languageCode);

    @override
    Future<MaterialLocalizations> load(Locale locale) => GlobalMaterialLocalizations.delegate.load(_english);

    @override
    bool shouldReload(_FallbackMaterialDelegate old) => false;
}

class _FallbackCupertinoDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
    const _FallbackCupertinoDelegate();

    @override
    bool isSupported(Locale locale) => !kCupertinoSupportedLanguages.contains(locale.languageCode);

    @override
    Future<CupertinoLocalizations> load(Locale locale) => GlobalCupertinoLocalizations.delegate.load(_english);

    @override
    bool shouldReload(_FallbackCupertinoDelegate old) => false;
}

class _FallbackWidgetsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
    const _FallbackWidgetsDelegate();

    @override
    bool isSupported(Locale locale) => !kWidgetsSupportedLanguages.contains(locale.languageCode);

    @override
    Future<WidgetsLocalizations> load(Locale locale) => GlobalWidgetsLocalizations.delegate.load(_english);

    @override
    bool shouldReload(_FallbackWidgetsDelegate old) => false;
}

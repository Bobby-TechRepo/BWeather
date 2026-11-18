import 'package:bweather/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'package:bweather/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
    /// Shorthand for `AppLocalizations.of(context)`.
    AppLocalizations get l10n => AppLocalizations.of(this);

    /// The active locale as a string ("en", "fr") for intl date formatting.
    String get localeName => AppLocalizations.of(this).localeName;
}

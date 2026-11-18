import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_ig.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_yo.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ha'),
    Locale('ig'),
    Locale('ja'),
    Locale('yo'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BWeather'**
  String get appTitle;

  /// No description provided for @navForecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get navForecast;

  /// No description provided for @navLocations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get navLocations;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @addCity.
  ///
  /// In en, this message translates to:
  /// **'Add a city'**
  String get addCity;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search cities'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @keepTyping.
  ///
  /// In en, this message translates to:
  /// **'Keep typing…'**
  String get keepTyping;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed. Check your internet connection and try again.'**
  String get searchFailed;

  /// No description provided for @noPlacesMatch.
  ///
  /// In en, this message translates to:
  /// **'No places match \"{query}\".'**
  String noPlacesMatch(String query);

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to BWeather'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Forecasts for where you are and the places you care about.'**
  String get welcomeSubtitle;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @findingYou.
  ///
  /// In en, this message translates to:
  /// **'Finding you…'**
  String get findingYou;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with {place}'**
  String continueWith(String place);

  /// No description provided for @approximateFromNetwork.
  ///
  /// In en, this message translates to:
  /// **'Approximate, based on your network'**
  String get approximateFromNetwork;

  /// No description provided for @searchForCity.
  ///
  /// In en, this message translates to:
  /// **'Search for a city'**
  String get searchForCity;

  /// No description provided for @locationPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your location is only used to fetch the forecast.'**
  String get locationPrivacyNote;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission wasn\'t granted.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionBlocked.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked. You can allow it in Settings.'**
  String get locationPermissionBlocked;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find your location right now.'**
  String get locationUnavailable;

  /// No description provided for @approximateBanner.
  ///
  /// In en, this message translates to:
  /// **'Showing an approximate location based on your network.'**
  String get approximateBanner;

  /// No description provided for @usePrecise.
  ///
  /// In en, this message translates to:
  /// **'Use precise'**
  String get usePrecise;

  /// No description provided for @noPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'No places yet'**
  String get noPlacesTitle;

  /// No description provided for @noPlacesBody.
  ///
  /// In en, this message translates to:
  /// **'Use your location or add a city to see its forecast.'**
  String get noPlacesBody;

  /// No description provided for @noSavedPlaces.
  ///
  /// In en, this message translates to:
  /// **'No saved places yet. Tap + to add a city.'**
  String get noSavedPlaces;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocation;

  /// No description provided for @approximateLocation.
  ///
  /// In en, this message translates to:
  /// **'Approximate location'**
  String get approximateLocation;

  /// No description provided for @removeCity.
  ///
  /// In en, this message translates to:
  /// **'Remove {city}'**
  String removeCity(String city);

  /// No description provided for @reorderHint.
  ///
  /// In en, this message translates to:
  /// **'Long-press and drag a city to reorder.'**
  String get reorderHint;

  /// No description provided for @forecastLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the forecast for {city}.'**
  String forecastLoadFailed(String city);

  /// No description provided for @forecastUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load forecast'**
  String get forecastUnavailable;

  /// No description provided for @forecastErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the weather service. Check your connection and try again.'**
  String get forecastErrorNetwork;

  /// No description provided for @forecastErrorData.
  ///
  /// In en, this message translates to:
  /// **'The weather service sent data we couldn\'t read. Please try again later.'**
  String get forecastErrorData;

  /// No description provided for @couldNotRefresh.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh'**
  String get couldNotRefresh;

  /// No description provided for @updatedAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {age}'**
  String updatedAgo(String age);

  /// No description provided for @ageJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get ageJustNow;

  /// No description provided for @ageMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String ageMinutes(int count);

  /// No description provided for @ageHours.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String ageHours(int count);

  /// No description provided for @ageDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String ageDays(int count);

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like {temperature}'**
  String feelsLike(String temperature);

  /// No description provided for @rainChance.
  ///
  /// In en, this message translates to:
  /// **'Rain chance'**
  String get rainChance;

  /// No description provided for @windWithDirection.
  ///
  /// In en, this message translates to:
  /// **'Wind {direction}'**
  String windWithDirection(String direction);

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @hourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get hourly;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @windDirection.
  ///
  /// In en, this message translates to:
  /// **'Wind direction'**
  String get windDirection;

  /// No description provided for @windGusts.
  ///
  /// In en, this message translates to:
  /// **'Wind gusts'**
  String get windGusts;

  /// No description provided for @rainToday.
  ///
  /// In en, this message translates to:
  /// **'Rain today'**
  String get rainToday;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @cloudCover.
  ///
  /// In en, this message translates to:
  /// **'Cloud cover'**
  String get cloudCover;

  /// No description provided for @dewPoint.
  ///
  /// In en, this message translates to:
  /// **'Dew point'**
  String get dewPoint;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @semanticsCurrent.
  ///
  /// In en, this message translates to:
  /// **'{temperature} degrees, {condition}'**
  String semanticsCurrent(String temperature, String condition);

  /// No description provided for @semanticsDay.
  ///
  /// In en, this message translates to:
  /// **'{day}: {condition}, {min} to {max}'**
  String semanticsDay(String day, String condition, String min, String max);

  /// No description provided for @semanticsRainChance.
  ///
  /// In en, this message translates to:
  /// **'{percent}% chance of rain'**
  String semanticsRainChance(int percent);

  /// 16 compass points, comma separated, starting at north and going clockwise.
  ///
  /// In en, this message translates to:
  /// **'N,NNE,NE,ENE,E,ESE,SE,SSE,S,SSW,SW,WSW,W,WNW,NW,NNW'**
  String get compassPoints;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeAuto;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @settingsTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get settingsTemperature;

  /// No description provided for @unitCelsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get unitCelsius;

  /// No description provided for @unitFahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit (°F)'**
  String get unitFahrenheit;

  /// No description provided for @settingsWindSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind speed'**
  String get settingsWindSpeed;

  /// No description provided for @unitKmh.
  ///
  /// In en, this message translates to:
  /// **'Kilometres per hour (km/h)'**
  String get unitKmh;

  /// No description provided for @unitMph.
  ///
  /// In en, this message translates to:
  /// **'Miles per hour (mph)'**
  String get unitMph;

  /// No description provided for @unitMs.
  ///
  /// In en, this message translates to:
  /// **'Metres per second (m/s)'**
  String get unitMs;

  /// No description provided for @unitKnots.
  ///
  /// In en, this message translates to:
  /// **'Knots (kn)'**
  String get unitKnots;

  /// No description provided for @settingsPrecipitation.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get settingsPrecipitation;

  /// No description provided for @unitMm.
  ///
  /// In en, this message translates to:
  /// **'Millimetres (mm)'**
  String get unitMm;

  /// No description provided for @unitInch.
  ///
  /// In en, this message translates to:
  /// **'Inches (in)'**
  String get unitInch;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About BWeather'**
  String get aboutApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'BWeather shows the current weather and forecasts for your location and the places you save. It is developed and maintained by Nobel for Bsoft Limited.'**
  String get aboutDescription;

  /// No description provided for @aboutDataSources.
  ///
  /// In en, this message translates to:
  /// **'Data sources'**
  String get aboutDataSources;

  /// No description provided for @aboutOpenMeteo.
  ///
  /// In en, this message translates to:
  /// **'Weather and place search: Open-Meteo (open-meteo.com), licensed under CC BY 4.0.'**
  String get aboutOpenMeteo;

  /// No description provided for @aboutOsm.
  ///
  /// In en, this message translates to:
  /// **'Place names: © OpenStreetMap contributors (Nominatim), ODbL.'**
  String get aboutOsm;

  /// No description provided for @aboutIpapi.
  ///
  /// In en, this message translates to:
  /// **'Approximate location: ipapi.co.'**
  String get aboutIpapi;

  /// No description provided for @aboutIcons.
  ///
  /// In en, this message translates to:
  /// **'Weather icons: Meteocons by Bas Milius (MIT).'**
  String get aboutIcons;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'BWeather has no accounts, no ads and no analytics. This page explains which data leaves your device and why.'**
  String get privacyIntro;

  /// No description provided for @privacyLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get privacyLocationTitle;

  /// No description provided for @privacyLocationBody.
  ///
  /// In en, this message translates to:
  /// **'If you allow it, the app reads your device\'s location. The coordinates are sent to Open-Meteo to get the forecast and to OpenStreetMap Nominatim to get the name of the place. They are not sent anywhere else.'**
  String get privacyLocationBody;

  /// No description provided for @privacyApproximateTitle.
  ///
  /// In en, this message translates to:
  /// **'Approximate location'**
  String get privacyApproximateTitle;

  /// No description provided for @privacyApproximateBody.
  ///
  /// In en, this message translates to:
  /// **'When precise location isn\'t available, the app asks ipapi.co for an approximate, city-level location. ipapi.co sees your IP address to answer this request.'**
  String get privacyApproximateBody;

  /// No description provided for @privacySearchTitle.
  ///
  /// In en, this message translates to:
  /// **'City search'**
  String get privacySearchTitle;

  /// No description provided for @privacySearchBody.
  ///
  /// In en, this message translates to:
  /// **'The text you type in the city search is sent to Open-Meteo\'s geocoding service to find matching places.'**
  String get privacySearchBody;

  /// No description provided for @privacyStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Data stored on your device'**
  String get privacyStorageTitle;

  /// No description provided for @privacyStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Your saved cities, the latest forecasts and your settings are stored only on this device. Uninstalling the app deletes them.'**
  String get privacyStorageBody;

  /// No description provided for @privacyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactBody.
  ///
  /// In en, this message translates to:
  /// **'Questions about privacy? Contact Bsoft Limited through the app\'s store listing.'**
  String get privacyContactBody;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'By using BWeather you agree to these terms.'**
  String get termsIntro;

  /// No description provided for @termsAccuracyTitle.
  ///
  /// In en, this message translates to:
  /// **'Forecast accuracy'**
  String get termsAccuracyTitle;

  /// No description provided for @termsAccuracyBody.
  ///
  /// In en, this message translates to:
  /// **'Forecasts are estimates and can be wrong. Don\'t rely on BWeather for decisions where safety is at stake; follow official warnings from your national weather service.'**
  String get termsAccuracyBody;

  /// No description provided for @termsServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'The service'**
  String get termsServiceTitle;

  /// No description provided for @termsServiceBody.
  ///
  /// In en, this message translates to:
  /// **'BWeather is provided \"as is\", without warranties. Features may change, and the service may be unavailable at times.'**
  String get termsServiceBody;

  /// No description provided for @termsThirdPartyTitle.
  ///
  /// In en, this message translates to:
  /// **'Third-party data'**
  String get termsThirdPartyTitle;

  /// No description provided for @termsThirdPartyBody.
  ///
  /// In en, this message translates to:
  /// **'Weather data comes from Open-Meteo and place names from OpenStreetMap. Their own terms and licences apply to that data.'**
  String get termsThirdPartyBody;

  /// No description provided for @legalLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String legalLastUpdated(String date);

  /// No description provided for @wmo0.
  ///
  /// In en, this message translates to:
  /// **'Clear sky'**
  String get wmo0;

  /// No description provided for @wmo1.
  ///
  /// In en, this message translates to:
  /// **'Mainly clear'**
  String get wmo1;

  /// No description provided for @wmo2.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get wmo2;

  /// No description provided for @wmo3.
  ///
  /// In en, this message translates to:
  /// **'Overcast'**
  String get wmo3;

  /// No description provided for @wmo45.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get wmo45;

  /// No description provided for @wmo48.
  ///
  /// In en, this message translates to:
  /// **'Rime fog'**
  String get wmo48;

  /// No description provided for @wmo51.
  ///
  /// In en, this message translates to:
  /// **'Light drizzle'**
  String get wmo51;

  /// No description provided for @wmo53.
  ///
  /// In en, this message translates to:
  /// **'Moderate drizzle'**
  String get wmo53;

  /// No description provided for @wmo55.
  ///
  /// In en, this message translates to:
  /// **'Dense drizzle'**
  String get wmo55;

  /// No description provided for @wmo56.
  ///
  /// In en, this message translates to:
  /// **'Light freezing drizzle'**
  String get wmo56;

  /// No description provided for @wmo57.
  ///
  /// In en, this message translates to:
  /// **'Dense freezing drizzle'**
  String get wmo57;

  /// No description provided for @wmo61.
  ///
  /// In en, this message translates to:
  /// **'Light rain'**
  String get wmo61;

  /// No description provided for @wmo63.
  ///
  /// In en, this message translates to:
  /// **'Moderate rain'**
  String get wmo63;

  /// No description provided for @wmo65.
  ///
  /// In en, this message translates to:
  /// **'Heavy rain'**
  String get wmo65;

  /// No description provided for @wmo66.
  ///
  /// In en, this message translates to:
  /// **'Light freezing rain'**
  String get wmo66;

  /// No description provided for @wmo67.
  ///
  /// In en, this message translates to:
  /// **'Heavy freezing rain'**
  String get wmo67;

  /// No description provided for @wmo71.
  ///
  /// In en, this message translates to:
  /// **'Light snowfall'**
  String get wmo71;

  /// No description provided for @wmo73.
  ///
  /// In en, this message translates to:
  /// **'Moderate snowfall'**
  String get wmo73;

  /// No description provided for @wmo75.
  ///
  /// In en, this message translates to:
  /// **'Heavy snowfall'**
  String get wmo75;

  /// No description provided for @wmo77.
  ///
  /// In en, this message translates to:
  /// **'Snow grains'**
  String get wmo77;

  /// No description provided for @wmo80.
  ///
  /// In en, this message translates to:
  /// **'Light rain showers'**
  String get wmo80;

  /// No description provided for @wmo81.
  ///
  /// In en, this message translates to:
  /// **'Moderate rain showers'**
  String get wmo81;

  /// No description provided for @wmo82.
  ///
  /// In en, this message translates to:
  /// **'Violent rain showers'**
  String get wmo82;

  /// No description provided for @wmo85.
  ///
  /// In en, this message translates to:
  /// **'Light snow showers'**
  String get wmo85;

  /// No description provided for @wmo86.
  ///
  /// In en, this message translates to:
  /// **'Heavy snow showers'**
  String get wmo86;

  /// No description provided for @wmo95.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get wmo95;

  /// No description provided for @wmo96.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm with light hail'**
  String get wmo96;

  /// No description provided for @wmo99.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm with heavy hail'**
  String get wmo99;

  /// No description provided for @wmoUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown conditions'**
  String get wmoUnknown;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @airQuality.
  ///
  /// In en, this message translates to:
  /// **'Air quality'**
  String get airQuality;

  /// No description provided for @airQualityIndex.
  ///
  /// In en, this message translates to:
  /// **'US AQI {value}'**
  String airQualityIndex(int value);

  /// No description provided for @aqiGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get aqiGood;

  /// No description provided for @aqiModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get aqiModerate;

  /// No description provided for @aqiSensitive.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy for sensitive groups'**
  String get aqiSensitive;

  /// No description provided for @aqiUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy'**
  String get aqiUnhealthy;

  /// No description provided for @aqiVeryUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Very unhealthy'**
  String get aqiVeryUnhealthy;

  /// No description provided for @aqiHazardous.
  ///
  /// In en, this message translates to:
  /// **'Hazardous'**
  String get aqiHazardous;

  /// No description provided for @pm25.
  ///
  /// In en, this message translates to:
  /// **'PM2.5'**
  String get pm25;

  /// No description provided for @pm10.
  ///
  /// In en, this message translates to:
  /// **'PM10'**
  String get pm10;

  /// No description provided for @dust.
  ///
  /// In en, this message translates to:
  /// **'Dust'**
  String get dust;

  /// No description provided for @uvIndex.
  ///
  /// In en, this message translates to:
  /// **'UV index'**
  String get uvIndex;

  /// No description provided for @uvLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get uvLow;

  /// No description provided for @uvModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get uvModerate;

  /// No description provided for @uvHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get uvHigh;

  /// No description provided for @uvVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very high'**
  String get uvVeryHigh;

  /// No description provided for @uvExtreme.
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get uvExtreme;

  /// No description provided for @pollen.
  ///
  /// In en, this message translates to:
  /// **'Pollen'**
  String get pollen;

  /// No description provided for @pollenAlder.
  ///
  /// In en, this message translates to:
  /// **'Alder'**
  String get pollenAlder;

  /// No description provided for @pollenBirch.
  ///
  /// In en, this message translates to:
  /// **'Birch'**
  String get pollenBirch;

  /// No description provided for @pollenGrass.
  ///
  /// In en, this message translates to:
  /// **'Grass'**
  String get pollenGrass;

  /// No description provided for @pollenMugwort.
  ///
  /// In en, this message translates to:
  /// **'Mugwort'**
  String get pollenMugwort;

  /// No description provided for @pollenOlive.
  ///
  /// In en, this message translates to:
  /// **'Olive'**
  String get pollenOlive;

  /// No description provided for @pollenRagweed.
  ///
  /// In en, this message translates to:
  /// **'Ragweed'**
  String get pollenRagweed;

  /// No description provided for @harmattanDustHint.
  ///
  /// In en, this message translates to:
  /// **'High dust levels: consider a mask outdoors.'**
  String get harmattanDustHint;

  /// No description provided for @chart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get chart;

  /// No description provided for @chartLegendTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get chartLegendTemperature;

  /// No description provided for @chartLegendRain.
  ///
  /// In en, this message translates to:
  /// **'Rain chance'**
  String get chartLegendRain;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @notifyMorningBrief.
  ///
  /// In en, this message translates to:
  /// **'Morning briefing'**
  String get notifyMorningBrief;

  /// No description provided for @notifyMorningBriefDetail.
  ///
  /// In en, this message translates to:
  /// **'Today\'s forecast for your location each morning.'**
  String get notifyMorningBriefDetail;

  /// No description provided for @notifyBriefTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get notifyBriefTime;

  /// No description provided for @notifyRain.
  ///
  /// In en, this message translates to:
  /// **'Rain alerts'**
  String get notifyRain;

  /// No description provided for @notifyRainDetail.
  ///
  /// In en, this message translates to:
  /// **'When rain is likely within the next 2 hours.'**
  String get notifyRainDetail;

  /// No description provided for @notifySevere.
  ///
  /// In en, this message translates to:
  /// **'Severe weather'**
  String get notifySevere;

  /// No description provided for @notifySevereDetail.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorms, very strong winds or extreme heat.'**
  String get notifySevereDetail;

  /// No description provided for @notifyPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for BWeather in your device settings.'**
  String get notifyPermissionDenied;

  /// No description provided for @notifyUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Notifications are available in the Android app.'**
  String get notifyUnsupported;

  /// No description provided for @notifyBackgroundNote.
  ///
  /// In en, this message translates to:
  /// **'Alerts are checked about once an hour, so they can arrive a little late.'**
  String get notifyBackgroundNote;

  /// Android notification channel name.
  ///
  /// In en, this message translates to:
  /// **'Forecasts'**
  String get notifyChannelForecast;

  /// Android notification channel name.
  ///
  /// In en, this message translates to:
  /// **'Weather alerts'**
  String get notifyChannelAlerts;

  /// No description provided for @briefTitle.
  ///
  /// In en, this message translates to:
  /// **'Today in {place}'**
  String briefTitle(String place);

  /// No description provided for @briefBody.
  ///
  /// In en, this message translates to:
  /// **'{condition}, {min} to {max}. Rain chance {rain}%.'**
  String briefBody(String condition, String min, String max, int rain);

  /// No description provided for @rainAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Rain expected in {place}'**
  String rainAlertTitle(String place);

  /// No description provided for @rainAlertBody.
  ///
  /// In en, this message translates to:
  /// **'{percent}% chance of rain around {time}.'**
  String rainAlertBody(int percent, String time);

  /// No description provided for @severeThunderTitle.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorms near {place}'**
  String severeThunderTitle(String place);

  /// No description provided for @severeThunderBody.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorms are expected around {time}. Stay indoors if you can.'**
  String severeThunderBody(String time);

  /// No description provided for @severeWindTitle.
  ///
  /// In en, this message translates to:
  /// **'Strong winds in {place}'**
  String severeWindTitle(String place);

  /// No description provided for @severeWindBody.
  ///
  /// In en, this message translates to:
  /// **'Gusts up to {speed} expected today.'**
  String severeWindBody(String speed);

  /// No description provided for @severeHeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Extreme heat in {place}'**
  String severeHeatTitle(String place);

  /// No description provided for @severeHeatBody.
  ///
  /// In en, this message translates to:
  /// **'It will feel like {temperature} today. Drink water and avoid the midday sun.'**
  String severeHeatBody(String temperature);

  /// No description provided for @aboutCams.
  ///
  /// In en, this message translates to:
  /// **'Air quality: generated using Copernicus Atmosphere Monitoring Service information (via Open-Meteo).'**
  String get aboutCams;

  /// No description provided for @widgetRange.
  ///
  /// In en, this message translates to:
  /// **'H {max} · L {min}'**
  String widgetRange(String max, String min);

  /// No description provided for @widgetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String widgetUpdated(String time);

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tips'**
  String get tipsTitle;

  /// No description provided for @tipUmbrella.
  ///
  /// In en, this message translates to:
  /// **'Take an umbrella: {percent}% chance of rain, most likely around {time}.'**
  String tipUmbrella(int percent, String time);

  /// No description provided for @tipClothesHot.
  ///
  /// In en, this message translates to:
  /// **'Wear light, breathable clothes.'**
  String get tipClothesHot;

  /// No description provided for @tipClothesWarm.
  ///
  /// In en, this message translates to:
  /// **'T-shirt weather.'**
  String get tipClothesWarm;

  /// No description provided for @tipClothesMild.
  ///
  /// In en, this message translates to:
  /// **'Bring a light jacket.'**
  String get tipClothesMild;

  /// No description provided for @tipClothesCool.
  ///
  /// In en, this message translates to:
  /// **'Wear a warm jacket.'**
  String get tipClothesCool;

  /// No description provided for @tipClothesCold.
  ///
  /// In en, this message translates to:
  /// **'Bundle up: it\'s cold out.'**
  String get tipClothesCold;

  /// No description provided for @tipSunscreen.
  ///
  /// In en, this message translates to:
  /// **'UV is {level} today: use sunscreen and a hat between 10:00 and 16:00.'**
  String tipSunscreen(String level);

  /// No description provided for @tipHydrate.
  ///
  /// In en, this message translates to:
  /// **'It will feel like {temperature}. Drink plenty of water.'**
  String tipHydrate(String temperature);

  /// No description provided for @tipLaundryGood.
  ///
  /// In en, this message translates to:
  /// **'Good day to dry laundry outside.'**
  String get tipLaundryGood;

  /// No description provided for @tipLaundryBad.
  ///
  /// In en, this message translates to:
  /// **'Not a good day to dry laundry outside.'**
  String get tipLaundryBad;

  /// No description provided for @tipBestOutdoorTime.
  ///
  /// In en, this message translates to:
  /// **'Best time to be outdoors: around {time}.'**
  String tipBestOutdoorTime(String time);

  /// No description provided for @tipAirQuality.
  ///
  /// In en, this message translates to:
  /// **'Air quality is poor: limit long or intense activity outdoors.'**
  String get tipAirQuality;

  /// No description provided for @tipMosquitoes.
  ///
  /// In en, this message translates to:
  /// **'Warm, humid evening: mosquitoes are likely, so use repellent or a net.'**
  String get tipMosquitoes;

  /// No description provided for @tipDriveFog.
  ///
  /// In en, this message translates to:
  /// **'Drive carefully: fog expected around {time}.'**
  String tipDriveFog(String time);

  /// No description provided for @tipDriveRain.
  ///
  /// In en, this message translates to:
  /// **'Drive carefully: heavy rain expected around {time}.'**
  String tipDriveRain(String time);

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @settingsDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display & data'**
  String get settingsDisplay;

  /// No description provided for @settingsAnimatedBackground.
  ///
  /// In en, this message translates to:
  /// **'Animated backgrounds'**
  String get settingsAnimatedBackground;

  /// No description provided for @settingsAnimatedBackgroundDetail.
  ///
  /// In en, this message translates to:
  /// **'A moving sky behind the forecast. Stays still when your device is set to reduce motion.'**
  String get settingsAnimatedBackgroundDetail;

  /// No description provided for @settingsMinuteRain.
  ///
  /// In en, this message translates to:
  /// **'Minute-by-minute rain'**
  String get settingsMinuteRain;

  /// No description provided for @settingsMinuteRainDetail.
  ///
  /// In en, this message translates to:
  /// **'Rain for the next 2 hours in 15-minute steps. Uses slightly more data.'**
  String get settingsMinuteRainDetail;

  /// No description provided for @settingsCrashReports.
  ///
  /// In en, this message translates to:
  /// **'Send crash reports'**
  String get settingsCrashReports;

  /// No description provided for @settingsCrashReportsDetail.
  ///
  /// In en, this message translates to:
  /// **'Anonymous error details that help fix bugs. No location or personal data.'**
  String get settingsCrashReportsDetail;

  /// No description provided for @nextTwoHours.
  ///
  /// In en, this message translates to:
  /// **'Next 2 hours'**
  String get nextTwoHours;

  /// No description provided for @rainStartingIn.
  ///
  /// In en, this message translates to:
  /// **'Rain starting in about {minutes} min'**
  String rainStartingIn(int minutes);

  /// No description provided for @rainStoppingIn.
  ///
  /// In en, this message translates to:
  /// **'Rain stopping in about {minutes} min'**
  String rainStoppingIn(int minutes);

  /// No description provided for @rainContinuing.
  ///
  /// In en, this message translates to:
  /// **'Rain for at least the next 2 hours'**
  String get rainContinuing;

  /// No description provided for @noRainSoon.
  ///
  /// In en, this message translates to:
  /// **'No rain expected in the next 2 hours'**
  String get noRainSoon;

  /// No description provided for @tempAboutNormal.
  ///
  /// In en, this message translates to:
  /// **'About normal for today'**
  String get tempAboutNormal;

  /// No description provided for @tempWarmerThanUsual.
  ///
  /// In en, this message translates to:
  /// **'{degrees}° warmer than usual'**
  String tempWarmerThanUsual(int degrees);

  /// No description provided for @tempCoolerThanUsual.
  ///
  /// In en, this message translates to:
  /// **'{degrees}° cooler than usual'**
  String tempCoolerThanUsual(int degrees);

  /// No description provided for @tempNormalsSource.
  ///
  /// In en, this message translates to:
  /// **'Today\'s high compared with the average high for this date, {fromYear}–{toYear}.'**
  String tempNormalsSource(String fromYear, String toYear);

  /// No description provided for @radar.
  ///
  /// In en, this message translates to:
  /// **'Rain radar'**
  String get radar;

  /// No description provided for @radarUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The radar isn\'t available right now.'**
  String get radarUnavailable;

  /// No description provided for @radarNoCoverage.
  ///
  /// In en, this message translates to:
  /// **'Radar covers the past 2 hours. Some regions have little or no coverage.'**
  String get radarNoCoverage;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @aboutRainViewer.
  ///
  /// In en, this message translates to:
  /// **'Radar: weather data by RainViewer; map © OpenStreetMap contributors.'**
  String get aboutRainViewer;

  /// No description provided for @privacyRadarTitle.
  ///
  /// In en, this message translates to:
  /// **'Radar map'**
  String get privacyRadarTitle;

  /// No description provided for @privacyRadarBody.
  ///
  /// In en, this message translates to:
  /// **'Opening the radar downloads map tiles from OpenStreetMap and radar images from RainViewer for the area you view. Like any website, they see your IP address.'**
  String get privacyRadarBody;

  /// No description provided for @privacyCrashTitle.
  ///
  /// In en, this message translates to:
  /// **'Crash reports'**
  String get privacyCrashTitle;

  /// No description provided for @privacyCrashBody.
  ///
  /// In en, this message translates to:
  /// **'If the app crashes, an anonymous error report (device model, OS version, app version and the error) may be sent to Sentry so we can fix it. It never includes your location, saved places or IP address. You can turn this off in Settings.'**
  String get privacyCrashBody;

  /// No description provided for @aboutHistory.
  ///
  /// In en, this message translates to:
  /// **'Climate averages: Open-Meteo historical weather API (ERA5).'**
  String get aboutHistory;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOut;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnits;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @cityRemoved.
  ///
  /// In en, this message translates to:
  /// **'{city} removed'**
  String cityRemoved(String city);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @sunAndMoon.
  ///
  /// In en, this message translates to:
  /// **'Sun & moon'**
  String get sunAndMoon;

  /// No description provided for @daylight.
  ///
  /// In en, this message translates to:
  /// **'Daylight'**
  String get daylight;

  /// No description provided for @daylightDuration.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String daylightDuration(int hours, int minutes);

  /// No description provided for @moonNew.
  ///
  /// In en, this message translates to:
  /// **'New moon'**
  String get moonNew;

  /// No description provided for @moonWaxingCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waxing crescent'**
  String get moonWaxingCrescent;

  /// No description provided for @moonFirstQuarter.
  ///
  /// In en, this message translates to:
  /// **'First quarter'**
  String get moonFirstQuarter;

  /// No description provided for @moonWaxingGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waxing gibbous'**
  String get moonWaxingGibbous;

  /// No description provided for @moonFull.
  ///
  /// In en, this message translates to:
  /// **'Full moon'**
  String get moonFull;

  /// No description provided for @moonWaningGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waning gibbous'**
  String get moonWaningGibbous;

  /// No description provided for @moonLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'Last quarter'**
  String get moonLastQuarter;

  /// No description provided for @moonWaningCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waning crescent'**
  String get moonWaningCrescent;

  /// No description provided for @moonIllumination.
  ///
  /// In en, this message translates to:
  /// **'{percent}% lit'**
  String moonIllumination(int percent);

  /// No description provided for @navTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get navTrips;

  /// No description provided for @tripsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No trips yet'**
  String get tripsEmptyTitle;

  /// No description provided for @tripsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip to see the weather at each stop, day by day.'**
  String get tripsEmptyBody;

  /// No description provided for @planTrip.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip'**
  String get planTrip;

  /// No description provided for @newTrip.
  ///
  /// In en, this message translates to:
  /// **'New trip'**
  String get newTrip;

  /// No description provided for @editTrip.
  ///
  /// In en, this message translates to:
  /// **'Edit trip'**
  String get editTrip;

  /// No description provided for @tripName.
  ///
  /// In en, this message translates to:
  /// **'Trip name'**
  String get tripName;

  /// No description provided for @tripNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Christmas in Abuja'**
  String get tripNameHint;

  /// No description provided for @tripDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Trip to {place}'**
  String tripDefaultName(String place);

  /// No description provided for @tripStops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get tripStops;

  /// No description provided for @addStop.
  ///
  /// In en, this message translates to:
  /// **'Add a stop'**
  String get addStop;

  /// No description provided for @removeStop.
  ///
  /// In en, this message translates to:
  /// **'Remove stop'**
  String get removeStop;

  /// No description provided for @chooseDates.
  ///
  /// In en, this message translates to:
  /// **'Choose dates'**
  String get chooseDates;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deleteTrip.
  ///
  /// In en, this message translates to:
  /// **'Delete trip'**
  String get deleteTrip;

  /// No description provided for @tripDeleted.
  ///
  /// In en, this message translates to:
  /// **'Trip deleted'**
  String get tripDeleted;

  /// No description provided for @tripProblemNoStops.
  ///
  /// In en, this message translates to:
  /// **'Add at least one stop.'**
  String get tripProblemNoStops;

  /// No description provided for @tripProblemOrder.
  ///
  /// In en, this message translates to:
  /// **'Each stop must start on or after the day the previous one ends.'**
  String get tripProblemOrder;

  /// No description provided for @tripProblemTooLong.
  ///
  /// In en, this message translates to:
  /// **'Trips can be at most {days} days long.'**
  String tripProblemTooLong(int days);

  /// No description provided for @tripStartsIn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Starts today} =1{Starts tomorrow} other{Starts in {count} days}}'**
  String tripStartsIn(int count);

  /// No description provided for @tripOngoing.
  ///
  /// In en, this message translates to:
  /// **'Happening now'**
  String get tripOngoing;

  /// No description provided for @tripEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get tripEnded;

  /// No description provided for @tripDayCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String tripDayCount(int count);

  /// No description provided for @travelDay.
  ///
  /// In en, this message translates to:
  /// **'Travel day from {place}'**
  String travelDay(String place);

  /// No description provided for @typicalWeather.
  ///
  /// In en, this message translates to:
  /// **'Typical for the date'**
  String get typicalWeather;

  /// No description provided for @typicalWeatherNote.
  ///
  /// In en, this message translates to:
  /// **'Days more than {days} days away show typical weather for the date (the average of the last 20 years). The forecast replaces it automatically as the trip gets closer.'**
  String typicalWeatherNote(int days);

  /// No description provided for @weatherUnknown.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get weatherUnknown;

  /// No description provided for @packingList.
  ///
  /// In en, this message translates to:
  /// **'Packing list'**
  String get packingList;

  /// No description provided for @packingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing special to pack for this weather.'**
  String get packingEmpty;

  /// No description provided for @packUmbrella.
  ///
  /// In en, this message translates to:
  /// **'Umbrella'**
  String get packUmbrella;

  /// No description provided for @packRainJacket.
  ///
  /// In en, this message translates to:
  /// **'Rain jacket'**
  String get packRainJacket;

  /// No description provided for @packSunscreen.
  ///
  /// In en, this message translates to:
  /// **'Sunscreen'**
  String get packSunscreen;

  /// No description provided for @packSunglasses.
  ///
  /// In en, this message translates to:
  /// **'Sunglasses'**
  String get packSunglasses;

  /// No description provided for @packHat.
  ///
  /// In en, this message translates to:
  /// **'Sun hat'**
  String get packHat;

  /// No description provided for @packLightClothes.
  ///
  /// In en, this message translates to:
  /// **'Light, breathable clothes'**
  String get packLightClothes;

  /// No description provided for @packWaterBottle.
  ///
  /// In en, this message translates to:
  /// **'Reusable water bottle'**
  String get packWaterBottle;

  /// No description provided for @packWarmLayer.
  ///
  /// In en, this message translates to:
  /// **'Warm sweater or fleece'**
  String get packWarmLayer;

  /// No description provided for @packCoat.
  ///
  /// In en, this message translates to:
  /// **'Winter coat'**
  String get packCoat;

  /// No description provided for @packGloves.
  ///
  /// In en, this message translates to:
  /// **'Gloves'**
  String get packGloves;

  /// No description provided for @packWindbreaker.
  ///
  /// In en, this message translates to:
  /// **'Windbreaker'**
  String get packWindbreaker;

  /// No description provided for @packInsectRepellent.
  ///
  /// In en, this message translates to:
  /// **'Insect repellent'**
  String get packInsectRepellent;

  /// No description provided for @shareTrip.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTrip;

  /// No description provided for @tripReminder.
  ///
  /// In en, this message translates to:
  /// **'Remind me the day before'**
  String get tripReminder;

  /// No description provided for @tripReminderDetail.
  ///
  /// In en, this message translates to:
  /// **'A notification the evening before you leave, with the forecast for your first stop.'**
  String get tripReminderDetail;

  /// No description provided for @tripReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your trip to {place} starts tomorrow'**
  String tripReminderTitle(String place);

  /// No description provided for @tripReminderBodyFallback.
  ///
  /// In en, this message translates to:
  /// **'Check the forecast before you go.'**
  String get tripReminderBodyFallback;

  /// No description provided for @tripOutlookRange.
  ///
  /// In en, this message translates to:
  /// **'{low} to {high}'**
  String tripOutlookRange(String low, String high);

  /// No description provided for @tripRainyDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No rain expected} =1{Rain likely on 1 day} other{Rain likely on {count} days}}'**
  String tripRainyDays(int count);

  /// No description provided for @shareForecastDay.
  ///
  /// In en, this message translates to:
  /// **'{day} · {place}: {condition}, {min} to {max}, rain {rain}%'**
  String shareForecastDay(
    String day,
    String place,
    String condition,
    String min,
    String max,
    int rain,
  );

  /// No description provided for @shareTypicalDay.
  ///
  /// In en, this message translates to:
  /// **'{day} · {place}: typically {min} to {max}'**
  String shareTypicalDay(String day, String place, String min, String max);

  /// No description provided for @sharedFromApp.
  ///
  /// In en, this message translates to:
  /// **'Shared from BWeather'**
  String get sharedFromApp;

  /// No description provided for @privacyTripsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get privacyTripsTitle;

  /// No description provided for @privacyTripsBody.
  ///
  /// In en, this message translates to:
  /// **'The trips you plan are stored only on this device. To get their weather, the coordinates and dates of each stop are sent to Open-Meteo.'**
  String get privacyTripsBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'fr',
    'ha',
    'ig',
    'ja',
    'yo',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ha':
      return AppLocalizationsHa();
    case 'ig':
      return AppLocalizationsIg();
    case 'ja':
      return AppLocalizationsJa();
    case 'yo':
      return AppLocalizationsYo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

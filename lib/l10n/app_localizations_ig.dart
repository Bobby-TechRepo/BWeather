// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Igbo (`ig`).
class AppLocalizationsIg extends AppLocalizations {
  AppLocalizationsIg([String locale = 'ig']) : super(locale);

  @override
  String get appTitle => 'BWeather';

  @override
  String get navForecast => 'Amụma';

  @override
  String get navLocations => 'Ebe';

  @override
  String get navSettings => 'Ntọala';

  @override
  String get addCity => 'Tinye obodo';

  @override
  String get searchHint => 'Chọọ obodo';

  @override
  String get clearSearch => 'Hichapụ ọchụchọ';

  @override
  String get close => 'Mechie';

  @override
  String get retry => 'Nwaa ọzọ';

  @override
  String get keepTyping => 'Gaa n\'ihu na-ede…';

  @override
  String get searchFailed =>
      'Ọchụchọ adaghị. Lelee njikọ ịntanetị gị wee nwaa ọzọ.';

  @override
  String noPlacesMatch(String query) {
    return 'Ọ dịghị ebe dabara na \"$query\".';
  }

  @override
  String get welcomeTitle => 'Nnọọ na BWeather';

  @override
  String get welcomeSubtitle =>
      'Amụma ihu igwe maka ebe ị nọ na ebe ndị ị na-eche banyere ha.';

  @override
  String get useMyLocation => 'Jiri ebe m nọ';

  @override
  String get findingYou => 'Na-achọ ebe ị nọ…';

  @override
  String get openSettings => 'Mepee ntọala';

  @override
  String continueWith(String place) {
    return 'Gaa n\'ihu na $place';
  }

  @override
  String get approximateFromNetwork => 'Ihe dị nso, dabere na netwọk gị';

  @override
  String get searchForCity => 'Chọọ obodo';

  @override
  String get locationPrivacyNote =>
      'A na-eji ebe ị nọ naanị iji nweta amụma ihu igwe.';

  @override
  String get locationServiceDisabled => 'Agbanyụọla ọrụ ọnọdụ.';

  @override
  String get locationPermissionDenied => 'E nyeghị ikike ọnọdụ.';

  @override
  String get locationPermissionBlocked =>
      'Egbochiri ikike ọnọdụ. Ị nwere ike ikwe ya na Ntọala.';

  @override
  String get locationUnavailable => 'Anyị enweghị ike ịchọta ebe ị nọ ugbu a.';

  @override
  String get approximateBanner => 'Na-egosi ebe dị nso dabere na netwọk gị.';

  @override
  String get usePrecise => 'Jiri nke ziri ezi';

  @override
  String get noPlacesTitle => 'Enweghị ebe ọ bụla ka';

  @override
  String get noPlacesBody =>
      'Jiri ebe ị nọ ma ọ bụ tinye obodo iji hụ amụma ya.';

  @override
  String get noSavedPlaces =>
      'Enweghị ebe echekwara ka. Pịa + iji tinye obodo.';

  @override
  String get yourLocation => 'Ebe ị nọ';

  @override
  String get approximateLocation => 'Ebe dị nso';

  @override
  String removeCity(String city) {
    return 'Wepụ $city';
  }

  @override
  String get reorderHint =>
      'Pịa obodo ogologo oge wee dọkpụrụ ya iji hazie usoro.';

  @override
  String forecastLoadFailed(String city) {
    return 'Enweghị ike ibudata amụma maka $city.';
  }

  @override
  String get forecastUnavailable => 'Enweghị ike ibudata amụma';

  @override
  String get forecastErrorNetwork =>
      'Enweghị ike iru ọrụ ihu igwe. Lelee njikọ gị wee nwaa ọzọ.';

  @override
  String get forecastErrorData =>
      'Ọrụ ihu igwe zitere data anyị na-enweghị ike ịgụ. Biko nwaa ọzọ ma emechaa.';

  @override
  String get couldNotRefresh => 'Enweghị ike imelite';

  @override
  String updatedAgo(String age) {
    return 'Emelitere $age';
  }

  @override
  String get ageJustNow => 'ugbu a';

  @override
  String ageMinutes(int count) {
    return 'nkeji $count gara aga';
  }

  @override
  String ageHours(int count) {
    return 'awa $count gara aga';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ụbọchị $count gara aga',
      one: 'ụbọchị 1 gara aga',
    );
    return '$_temp0';
  }

  @override
  String feelsLike(String temperature) {
    return 'Ọ dị ka $temperature';
  }

  @override
  String get rainChance => 'Ohere mmiri ozuzo';

  @override
  String windWithDirection(String direction) {
    return 'Ikuku $direction';
  }

  @override
  String get humidity => 'Iru mmiri';

  @override
  String get daily => 'Kwa ụbọchị';

  @override
  String get hourly => 'Kwa awa';

  @override
  String get today => 'Taa';

  @override
  String get now => 'Ugbu a';

  @override
  String get windDirection => 'Ụzọ ikuku';

  @override
  String get windGusts => 'Ike ikuku';

  @override
  String get rainToday => 'Mmiri ozuzo taa';

  @override
  String get pressure => 'Nrụgide ikuku';

  @override
  String get cloudCover => 'Igwe ojii kpuchiri';

  @override
  String get dewPoint => 'Ọkwa igirigi';

  @override
  String get sunrise => 'Ọwụwa anyanwụ';

  @override
  String get sunset => 'Ọdịda anyanwụ';

  @override
  String semanticsCurrent(String temperature, String condition) {
    return 'Ogo $temperature, $condition';
  }

  @override
  String semanticsDay(String day, String condition, String min, String max) {
    return '$day: $condition, site na $min ruo $max';
  }

  @override
  String semanticsRainChance(int percent) {
    return 'Ohere mmiri ozuzo $percent%';
  }

  @override
  String get compassPoints =>
      'N,NNE,NE,ENE,E,ESE,SE,SSE,S,SSW,SW,WSW,W,WNW,NW,NNW';

  @override
  String get settingsGeneral => 'Izugbe';

  @override
  String get settingsTheme => 'Isiokwu';

  @override
  String get themeAuto => 'Akpaaka';

  @override
  String get themeLight => 'Ìhè';

  @override
  String get themeDark => 'Ọchịchịrị';

  @override
  String get settingsLanguage => 'Asụsụ';

  @override
  String get languageSystem => 'Nke ngwaọrụ';

  @override
  String get settingsTemperature => 'Okpomọkụ';

  @override
  String get unitCelsius => 'Celsius (°C)';

  @override
  String get unitFahrenheit => 'Fahrenheit (°F)';

  @override
  String get settingsWindSpeed => 'Ọsọ ikuku';

  @override
  String get unitKmh => 'Kilomita kwa awa (km/h)';

  @override
  String get unitMph => 'Maịl kwa awa (mph)';

  @override
  String get unitMs => 'Mita kwa sekọnd (m/s)';

  @override
  String get unitKnots => 'Knots (kn)';

  @override
  String get settingsPrecipitation => 'Mmiri ozuzo';

  @override
  String get unitMm => 'Milimita (mm)';

  @override
  String get unitInch => 'Inch (in)';

  @override
  String get settingsAbout => 'Banyere';

  @override
  String get aboutApp => 'Banyere BWeather';

  @override
  String get privacyPolicy => 'Iwu nzuzo';

  @override
  String get termsOfUse => 'Usoro ojiji';

  @override
  String version(String version) {
    return 'Ụdị $version';
  }

  @override
  String get aboutDescription =>
      'BWeather na-egosi ihu igwe ugbu a na amụma maka ebe ị nọ na ebe ndị ị chekwara. Nobel na-emepụta ma na-elekọta ya maka Bsoft Limited.';

  @override
  String get aboutDataSources => 'Isi mmalite data';

  @override
  String get aboutOpenMeteo =>
      'Ihu igwe na ọchụchọ ebe: Open-Meteo (open-meteo.com), n\'okpuru ikikere CC BY 4.0.';

  @override
  String get aboutOsm =>
      'Aha ebe: © ndị na-enye aka na OpenStreetMap (Nominatim), ODbL.';

  @override
  String get aboutIpapi => 'Ebe dị nso: ipapi.co.';

  @override
  String get aboutIcons => 'Akara ihu igwe: Meteocons nke Bas Milius (MIT).';

  @override
  String get privacyIntro =>
      'BWeather enweghị akaụntụ, enweghị mgbasa ozi, ọ naghịkwa enyocha ojiji. Peeji a na-akọwa data na-ahapụ ngwaọrụ gị na ihe kpatara ya.';

  @override
  String get privacyLocationTitle => 'Ebe ị nọ';

  @override
  String get privacyLocationBody =>
      'Ọ bụrụ na i kwere, ngwa ahụ na-agụ ebe ngwaọrụ gị dị. A na-eziga nhazi ya na Open-Meteo iji nweta amụma, na OpenStreetMap Nominatim iji nweta aha ebe ahụ. A naghị eziga ha ebe ọzọ.';

  @override
  String get privacyApproximateTitle => 'Ebe dị nso';

  @override
  String get privacyApproximateBody =>
      'Mgbe ebe ziri ezi adịghị, ngwa ahụ na-ajụ ipapi.co maka ebe dị nso n\'ọkwa obodo. ipapi.co na-ahụ adreesị IP gị iji zaa arịrịọ a.';

  @override
  String get privacySearchTitle => 'Ọchụchọ obodo';

  @override
  String get privacySearchBody =>
      'A na-eziga ederede ị pịnyere n\'ọchụchọ obodo na ọrụ geocoding nke Open-Meteo iji chọta ebe dabara.';

  @override
  String get privacyStorageTitle => 'Data echekwara na ngwaọrụ gị';

  @override
  String get privacyStorageBody =>
      'Obodo ndị ị chekwara, amụma ọhụrụ na ntọala gị dị naanị na ngwaọrụ a. Iwepu ngwa ahụ na-ehichapụ ha.';

  @override
  String get privacyContactTitle => 'Kpọtụrụ';

  @override
  String get privacyContactBody =>
      'Ị nwere ajụjụ gbasara nzuzo? Kpọtụrụ Bsoft Limited site na peeji ngwa ahụ n\'ụlọ ahịa ngwa.';

  @override
  String get termsIntro => 'Site n\'iji BWeather, ị kwenyere na usoro ndị a.';

  @override
  String get termsAccuracyTitle => 'Izi ezi nke amụma';

  @override
  String get termsAccuracyBody =>
      'Amụma bụ atụmatụ, ha nwekwara ike ịdị njọ. Ejila BWeather mee mkpebi metụtara nchekwa; soro ịdọ aka ná ntị gọọmentị sitere n\'ọrụ ihu igwe nke mba gị.';

  @override
  String get termsServiceTitle => 'Ọrụ ahụ';

  @override
  String get termsServiceBody =>
      'A na-enye BWeather \"dịka ọ dị\", na-enweghị nkwa ọ bụla. Atụmatụ nwere ike ịgbanwe, ọrụ ahụ nwekwara ike ọ gaghị adị mgbe ụfọdụ.';

  @override
  String get termsThirdPartyTitle => 'Data nke ndị ọzọ';

  @override
  String get termsThirdPartyBody =>
      'Data ihu igwe si na Open-Meteo, aha ebe si na OpenStreetMap. Usoro na ikikere nke ha na-emetụta data ahụ.';

  @override
  String legalLastUpdated(String date) {
    return 'Emelitere ikpeazụ: $date';
  }

  @override
  String get wmo0 => 'Mbara igwe doro anya';

  @override
  String get wmo1 => 'Ọ dị ọcha nke ukwuu';

  @override
  String get wmo2 => 'Igwe ojii ụfọdụ';

  @override
  String get wmo3 => 'Igwe ojii kpuchiri';

  @override
  String get wmo45 => 'Alụlụ';

  @override
  String get wmo48 => 'Alụlụ nwere ice';

  @override
  String get wmo51 => 'Obere mmiri ozuzo nta';

  @override
  String get wmo53 => 'Mmiri ozuzo nta';

  @override
  String get wmo55 => 'Mmiri ozuzo nta siri ike';

  @override
  String get wmo56 => 'Obere mmiri ozuzo nta na-ajụ oyi';

  @override
  String get wmo57 => 'Mmiri ozuzo nta na-ajụ oyi siri ike';

  @override
  String get wmo61 => 'Obere mmiri ozuzo';

  @override
  String get wmo63 => 'Mmiri ozuzo nkịtị';

  @override
  String get wmo65 => 'Mmiri ozuzo siri ike';

  @override
  String get wmo66 => 'Obere mmiri ozuzo na-ajụ oyi';

  @override
  String get wmo67 => 'Mmiri ozuzo na-ajụ oyi siri ike';

  @override
  String get wmo71 => 'Obere snow';

  @override
  String get wmo73 => 'Snow nkịtị';

  @override
  String get wmo75 => 'Snow siri ike';

  @override
  String get wmo77 => 'Mkpụrụ snow';

  @override
  String get wmo80 => 'Obere mmiri ozuzo na-agafe agafe';

  @override
  String get wmo81 => 'Mmiri ozuzo na-agafe agafe';

  @override
  String get wmo82 => 'Mmiri ozuzo na-agafe agafe siri ike';

  @override
  String get wmo85 => 'Obere snow na-agafe agafe';

  @override
  String get wmo86 => 'Snow na-agafe agafe siri ike';

  @override
  String get wmo95 => 'Égbè eluigwe';

  @override
  String get wmo96 => 'Égbè eluigwe na obere akụmmiri';

  @override
  String get wmo99 => 'Égbè eluigwe na akụmmiri siri ike';

  @override
  String get wmoUnknown => 'Ọnọdụ amaghị';

  @override
  String get pageNotFound => 'Ahụghị peeji ahụ';

  @override
  String get airQuality => 'Ịdị mma ikuku';

  @override
  String airQualityIndex(int value) {
    return 'US AQI $value';
  }

  @override
  String get aqiGood => 'Ọ dị mma';

  @override
  String get aqiModerate => 'Nkịtị';

  @override
  String get aqiSensitive => 'Ọ dịghị mma maka ndị na-adịghị ike';

  @override
  String get aqiUnhealthy => 'Ọ dịghị mma maka ahụ ike';

  @override
  String get aqiVeryUnhealthy => 'Ọ dịghị mma ma ọlị';

  @override
  String get aqiHazardous => 'Ọ dị ize ndụ';

  @override
  String get pm25 => 'PM2.5';

  @override
  String get pm10 => 'PM10';

  @override
  String get dust => 'Ájá';

  @override
  String get uvIndex => 'Ọkwa UV';

  @override
  String get uvLow => 'dị ala';

  @override
  String get uvModerate => 'nkịtị';

  @override
  String get uvHigh => 'dị elu';

  @override
  String get uvVeryHigh => 'dị elu nke ukwuu';

  @override
  String get uvExtreme => 'karịrị akarị';

  @override
  String get pollen => 'Ntụ okooko osisi';

  @override
  String get pollenAlder => 'Alder';

  @override
  String get pollenBirch => 'Birch';

  @override
  String get pollenGrass => 'Ahịhịa';

  @override
  String get pollenMugwort => 'Mugwort';

  @override
  String get pollenOlive => 'Olive';

  @override
  String get pollenRagweed => 'Ragweed';

  @override
  String get harmattanDustHint =>
      'Ájá dị ukwuu (ụgụrụ): tụlee iyi ihe mkpuchi ihu n\'èzí.';

  @override
  String get chart => 'Eserese';

  @override
  String get chartLegendTemperature => 'Okpomọkụ';

  @override
  String get chartLegendRain => 'Ohere mmiri ozuzo';

  @override
  String get settingsNotifications => 'Ọkwa';

  @override
  String get notifyMorningBrief => 'Nchịkọta ụtụtụ';

  @override
  String get notifyMorningBriefDetail => 'Amụma taa maka ebe ị nọ kwa ụtụtụ.';

  @override
  String get notifyBriefTime => 'Oge';

  @override
  String get notifyRain => 'Ọkwa mmiri ozuzo';

  @override
  String get notifyRainDetail =>
      'Mgbe mmiri nwere ike izo n\'ime awa 2 na-abịa.';

  @override
  String get notifySevere => 'Ihu igwe siri ike';

  @override
  String get notifySevereDetail =>
      'Égbè eluigwe, ikuku siri ike nke ukwuu ma ọ bụ okpomọkụ karịrị akarị.';

  @override
  String get notifyPermissionDenied =>
      'Agbanyụọla ọkwa BWeather na ntọala ngwaọrụ gị.';

  @override
  String get notifyUnsupported => 'Ọkwa dị na ngwa Android.';

  @override
  String get notifyBackgroundNote =>
      'A na-enyocha ọkwa ihe dị ka otu ugboro kwa awa, ya mere ha nwere ike ịbịa ntakịrị n\'azụ.';

  @override
  String get notifyChannelForecast => 'Amụma';

  @override
  String get notifyChannelAlerts => 'Ọkwa ihu igwe';

  @override
  String briefTitle(String place) {
    return 'Taa na $place';
  }

  @override
  String briefBody(String condition, String min, String max, int rain) {
    return '$condition, site na $min ruo $max. Ohere mmiri ozuzo $rain%.';
  }

  @override
  String rainAlertTitle(String place) {
    return 'A na-atụ anya mmiri ozuzo na $place';
  }

  @override
  String rainAlertBody(int percent, String time) {
    return 'Ohere mmiri ozuzo $percent% gburugburu $time.';
  }

  @override
  String severeThunderTitle(String place) {
    return 'Égbè eluigwe nso $place';
  }

  @override
  String severeThunderBody(String time) {
    return 'A na-atụ anya égbè eluigwe gburugburu $time. Nọrọ n\'ime ụlọ ma ọ bụrụ na ị nwere ike.';
  }

  @override
  String severeWindTitle(String place) {
    return 'Ikuku siri ike na $place';
  }

  @override
  String severeWindBody(String speed) {
    return 'A na-atụ anya ike ikuku ruru $speed taa.';
  }

  @override
  String severeHeatTitle(String place) {
    return 'Okpomọkụ karịrị akarị na $place';
  }

  @override
  String severeHeatBody(String temperature) {
    return 'Ọ ga-adị ka $temperature taa. Ṅụọ mmiri ma zere anwụ ehihie.';
  }

  @override
  String get aboutCams =>
      'Ịdị mma ikuku: emepụtara site n\'iji ozi Copernicus Atmosphere Monitoring Service (site na Open-Meteo).';

  @override
  String widgetRange(String max, String min) {
    return 'Elu $max · Ala $min';
  }

  @override
  String widgetUpdated(String time) {
    return 'Emelitere $time';
  }

  @override
  String get tipsTitle => 'Ndụmọdụ taa';

  @override
  String tipUmbrella(int percent, String time) {
    return 'Were nche anwụ: ohere mmiri ozuzo $percent%, o nwere ike ịbụ gburugburu $time.';
  }

  @override
  String get tipClothesHot => 'Yiri uwe dị mfe nke ikuku na-abanye.';

  @override
  String get tipClothesWarm => 'Ọ bụ oge T-shirt.';

  @override
  String get tipClothesMild => 'Were jaket dị mfe.';

  @override
  String get tipClothesCool => 'Yiri jaket na-ekpo ọkụ.';

  @override
  String get tipClothesCold => 'Kpuchie onwe gị nke ọma: oyi dị n\'èzí.';

  @override
  String tipSunscreen(String level) {
    return 'UV $level taa: jiri ude nchekwa anwụ na okpu n\'etiti 10:00 na 16:00.';
  }

  @override
  String tipHydrate(String temperature) {
    return 'Ọ ga-adị ka $temperature. Ṅụọ mmiri nke ukwuu.';
  }

  @override
  String get tipLaundryGood => 'Ụbọchị ọma iji kpọọ akwa n\'èzí.';

  @override
  String get tipLaundryBad => 'Ọ bụghị ụbọchị ọma iji kpọọ akwa n\'èzí.';

  @override
  String tipBestOutdoorTime(String time) {
    return 'Oge kacha mma ịnọ n\'èzí: gburugburu $time.';
  }

  @override
  String get tipAirQuality =>
      'Ikuku adịghị mma: belata ọrụ ogologo ma ọ bụ mmega ahụ siri ike n\'èzí.';

  @override
  String get tipMosquitoes =>
      'Mgbede na-ekpo ọkụ ma nwee iru mmiri: anwụnta nwere ike ịdị ọtụtụ, jiri ọgwụ anwụnta ma ọ bụ ụgbụ.';

  @override
  String tipDriveFog(String time) {
    return 'Kwọọ ụgbọ ala nke ọma: a na-atụ anya alụlụ gburugburu $time.';
  }

  @override
  String tipDriveRain(String time) {
    return 'Kwọọ ụgbọ ala nke ọma: a na-atụ anya mmiri ozuzo siri ike gburugburu $time.';
  }

  @override
  String get refresh => 'Melite';

  @override
  String get settingsDisplay => 'Ngosipụta na data';

  @override
  String get settingsAnimatedBackground => 'Azụ na-akpụ akpụ';

  @override
  String get settingsAnimatedBackgroundDetail =>
      'Mbara igwe na-akpụ akpụ n\'azụ amụma. Ọ na-anọ jụụ mgbe ngwaọrụ gị belatara mmegharị.';

  @override
  String get settingsMinuteRain => 'Mmiri ozuzo nkeji na nkeji';

  @override
  String get settingsMinuteRainDetail =>
      'Mmiri ozuzo nke awa 2 na-abịa na nkeji 15 ọ bụla. Ọ na-eji data ntakịrị karịa.';

  @override
  String get settingsCrashReports => 'Zipu akụkọ nsogbu ngwa';

  @override
  String get settingsCrashReportsDetail =>
      'Nkọwa njehie na-enweghị aha na-enyere aka idozi nsogbu. Enweghị ebe ị nọ ma ọ bụ data nkeonwe.';

  @override
  String get nextTwoHours => 'Awa 2 na-abịa';

  @override
  String rainStartingIn(int minutes) {
    return 'Mmiri ga-amalite izo n\'ihe dị ka nkeji $minutes';
  }

  @override
  String rainStoppingIn(int minutes) {
    return 'Mmiri ga-akwụsị n\'ihe dị ka nkeji $minutes';
  }

  @override
  String get rainContinuing => 'Mmiri ozuzo ma ọ dịkarịa ala awa 2 na-abịa';

  @override
  String get noRainSoon => 'A naghị atụ anya mmiri ozuzo n\'ime awa 2 na-abịa';

  @override
  String get tempAboutNormal => 'Dịka ọ na-adịkarị taa';

  @override
  String tempWarmerThanUsual(int degrees) {
    return 'Ọ na-ekpo ọkụ karịa ka ọ na-adịkarị ji $degrees°';
  }

  @override
  String tempCoolerThanUsual(int degrees) {
    return 'Ọ dị jụụ karịa ka ọ na-adịkarị ji $degrees°';
  }

  @override
  String tempNormalsSource(String fromYear, String toYear) {
    return 'Okpomọkụ kachasị elu taa e jiri tụnyere nkezi okpomọkụ kachasị elu nke ụbọchị a, $fromYear–$toYear.';
  }

  @override
  String get radar => 'Radar mmiri ozuzo';

  @override
  String get radarUnavailable => 'Radar adịghị ugbu a.';

  @override
  String get radarNoCoverage =>
      'Radar na-egosi awa 2 gara aga. Mpaghara ụfọdụ enweghị mkpuchi zuru ezu.';

  @override
  String get play => 'Kpọọ';

  @override
  String get pause => 'Kwụsịtụ';

  @override
  String get aboutRainViewer =>
      'Radar: data ihu igwe sitere na RainViewer; maapụ © ndị na-enye aka na OpenStreetMap.';

  @override
  String get privacyRadarTitle => 'Maapụ radar';

  @override
  String get privacyRadarBody =>
      'Imepe radar na-ebudata akụkụ maapụ site na OpenStreetMap na foto radar site na RainViewer maka mpaghara ị na-ele. Dịka weebụsaịtị ọ bụla, ha na-ahụ adreesị IP gị.';

  @override
  String get privacyCrashTitle => 'Akụkọ nsogbu ngwa';

  @override
  String get privacyCrashBody =>
      'Ọ bụrụ na ngwa ahụ akwụsị na mberede, a nwere ike iziga akụkọ njehie na-enweghị aha (ụdị ngwaọrụ, ụdị sistemụ, ụdị ngwa na njehie ahụ) na Sentry ka anyị wee dozie ya. Ọ dịghị mgbe ọ na-agụnye ebe ị nọ, ebe ndị ị chekwara ma ọ bụ adreesị IP gị. Ị nwere ike gbanyụọ nke a na Ntọala.';

  @override
  String get aboutHistory =>
      'Nkezi ihu igwe: Open-Meteo historical weather API (ERA5).';

  @override
  String get zoomIn => 'Mee ka ọ buo ibu';

  @override
  String get zoomOut => 'Mee ka ọ dị obere';

  @override
  String get settingsAppearance => 'Ọdịdị';

  @override
  String get settingsUnits => 'Nha';

  @override
  String get settingsPrivacy => 'Nzuzo';

  @override
  String cityRemoved(String city) {
    return 'Ewepụrụ $city';
  }

  @override
  String get undo => 'Megharịa';

  @override
  String get sunAndMoon => 'Anyanwụ na ọnwa';

  @override
  String get daylight => 'Ìhè ụbọchị';

  @override
  String daylightDuration(int hours, int minutes) {
    return 'Awa $hours nkeji $minutes';
  }

  @override
  String get moonNew => 'Ọnwa ọhụrụ';

  @override
  String get moonWaxingCrescent => 'Ọnwa na-eto (obere)';

  @override
  String get moonFirstQuarter => 'Nkeji anọ mbụ';

  @override
  String get moonWaxingGibbous => 'Ọnwa na-eto (ukwu)';

  @override
  String get moonFull => 'Ọnwa zuru oke';

  @override
  String get moonWaningGibbous => 'Ọnwa na-ebelata (ukwu)';

  @override
  String get moonLastQuarter => 'Nkeji anọ ikpeazụ';

  @override
  String get moonWaningCrescent => 'Ọnwa na-ebelata (obere)';

  @override
  String moonIllumination(int percent) {
    return 'Ìhè $percent%';
  }

  @override
  String get navTrips => 'Njem';

  @override
  String get tripsEmptyTitle => 'Enweghị njem ka';

  @override
  String get tripsEmptyBody =>
      'Hazie njem iji hụ ihu igwe na ebe ọ bụla ị ga-akwụsị, ụbọchị ọ bụla.';

  @override
  String get planTrip => 'Hazie njem';

  @override
  String get newTrip => 'Njem ọhụrụ';

  @override
  String get editTrip => 'Dezie njem';

  @override
  String get tripName => 'Aha njem';

  @override
  String get tripNameHint => 'dịka: Ekeresimesi na Abuja';

  @override
  String tripDefaultName(String place) {
    return 'Njem gaa $place';
  }

  @override
  String get tripStops => 'Ebe nkwụsị';

  @override
  String get addStop => 'Tinye ebe nkwụsị';

  @override
  String get removeStop => 'Wepụ ebe nkwụsị';

  @override
  String get chooseDates => 'Họrọ ụbọchị';

  @override
  String get save => 'Chekwaa';

  @override
  String get deleteTrip => 'Hichapụ njem';

  @override
  String get tripDeleted => 'Ehichapụla njem';

  @override
  String get tripProblemNoStops => 'Tinye ma ọ dịkarịa ala otu ebe nkwụsị.';

  @override
  String get tripProblemOrder =>
      'Ebe nkwụsị ọ bụla ga-amalite n\'ụbọchị nke gara aga kwụsịrị ma ọ bụ mgbe nke ahụ gasịrị.';

  @override
  String tripProblemTooLong(int days) {
    return 'Njem enweghị ike ịka ụbọchị $days.';
  }

  @override
  String tripStartsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ọ na-amalite n\'ime ụbọchị $count',
      one: 'Ọ na-amalite echi',
      zero: 'Ọ na-amalite taa',
    );
    return '$_temp0';
  }

  @override
  String get tripOngoing => 'Ọ na-aga ugbu a';

  @override
  String get tripEnded => 'Ọ gwụla';

  @override
  String tripDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ụbọchị $count',
      one: 'Ụbọchị 1',
    );
    return '$_temp0';
  }

  @override
  String travelDay(String place) {
    return 'Ụbọchị njem site na $place';
  }

  @override
  String get typicalWeather => 'Dịka ọ na-adịkarị n\'ụbọchị a';

  @override
  String typicalWeatherNote(int days) {
    return 'Ụbọchị karịrị ụbọchị $days n\'ihu na-egosi ihu igwe a na-ahụkarị n\'ụbọchị ahụ (nkezi afọ 20 gara aga). Amụma ga-anọchi ya na-akpaghị aka ka njem na-abịaru nso.';
  }

  @override
  String get weatherUnknown => 'Enweghị data ka';

  @override
  String get packingList => 'Ndepụta ihe ị ga-eburu';

  @override
  String get packingEmpty =>
      'Ọ dịghị ihe pụrụ iche ị ga-eburu maka ihu igwe a.';

  @override
  String get packUmbrella => 'Nche anwụ';

  @override
  String get packRainJacket => 'Uwe mmiri ozuzo';

  @override
  String get packSunscreen => 'Ude nchekwa anwụ';

  @override
  String get packSunglasses => 'Ugogbe anya anwụ';

  @override
  String get packHat => 'Okpu anwụ';

  @override
  String get packLightClothes => 'Uwe dị mfe';

  @override
  String get packWaterBottle => 'Karama mmiri';

  @override
  String get packWarmLayer => 'Sweta na-ekpo ọkụ';

  @override
  String get packCoat => 'Uwe oyi';

  @override
  String get packGloves => 'Uwe aka';

  @override
  String get packWindbreaker => 'Uwe nchekwa ikuku';

  @override
  String get packInsectRepellent => 'Ọgwụ anwụnta';

  @override
  String get shareTrip => 'Kesaa';

  @override
  String get tripReminder => 'Chetara m ụbọchị tupu ya';

  @override
  String get tripReminderDetail =>
      'Ọkwa na mgbede tupu ị pụọ, ya na amụma maka ebe nkwụsị mbụ gị.';

  @override
  String tripReminderTitle(String place) {
    return 'Njem gị gaa $place na-amalite echi';
  }

  @override
  String get tripReminderBodyFallback => 'Lelee amụma ihu igwe tupu ị pụọ.';

  @override
  String tripOutlookRange(String low, String high) {
    return '$low ruo $high';
  }

  @override
  String tripRainyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mmiri nwere ike izo ụbọchị $count',
      one: 'Mmiri nwere ike izo ụbọchị 1',
      zero: 'A naghị atụ anya mmiri ozuzo',
    );
    return '$_temp0';
  }

  @override
  String shareForecastDay(
    String day,
    String place,
    String condition,
    String min,
    String max,
    int rain,
  ) {
    return '$day · $place: $condition, $min ruo $max, mmiri ozuzo $rain%';
  }

  @override
  String shareTypicalDay(String day, String place, String min, String max) {
    return '$day · $place: na-adịkarị $min ruo $max';
  }

  @override
  String get sharedFromApp => 'Ekesara site na BWeather';

  @override
  String get privacyTripsTitle => 'Njem';

  @override
  String get privacyTripsBody =>
      'A na-echekwa njem ndị ị haziri naanị na ngwaọrụ a. Iji nweta ihu igwe ha, a na-eziga nhazi na ụbọchị nke ebe nkwụsị ọ bụla na Open-Meteo.';
}

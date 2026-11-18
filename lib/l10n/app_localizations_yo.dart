// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Yoruba (`yo`).
class AppLocalizationsYo extends AppLocalizations {
  AppLocalizationsYo([String locale = 'yo']) : super(locale);

  @override
  String get appTitle => 'BWeather';

  @override
  String get navForecast => 'Àsọtẹ́lẹ̀';

  @override
  String get navLocations => 'Àwọn ibì';

  @override
  String get navSettings => 'Ètò';

  @override
  String get addCity => 'Ṣàfikún ìlú';

  @override
  String get searchHint => 'Wá àwọn ìlú';

  @override
  String get clearSearch => 'Pa ìwádìí rẹ́';

  @override
  String get close => 'Pa dé';

  @override
  String get retry => 'Gbìyànjú lẹ́ẹ̀kan sí i';

  @override
  String get keepTyping => 'Máa tẹ̀ síwájú…';

  @override
  String get searchFailed =>
      'Ìwádìí kùnà. Ṣàyẹ̀wò ìsopọ̀ íntánẹ́ẹ̀tì rẹ kí o sì gbìyànjú lẹ́ẹ̀kan sí i.';

  @override
  String noPlacesMatch(String query) {
    return 'Kò sí ibì kankan tó bá \"$query\" mu.';
  }

  @override
  String get welcomeTitle => 'Káàbọ̀ sí BWeather';

  @override
  String get welcomeSubtitle =>
      'Àsọtẹ́lẹ̀ ojú-ọjọ́ fún ibi tí o wà àti àwọn ibi tí o nífẹ̀ẹ́ sí.';

  @override
  String get useMyLocation => 'Lo ibi tí mo wà';

  @override
  String get findingYou => 'À ń wá ibi tí o wà…';

  @override
  String get openSettings => 'Ṣí ètò';

  @override
  String continueWith(String place) {
    return 'Tẹ̀ síwájú pẹ̀lú $place';
  }

  @override
  String get approximateFromNetwork => 'Ìṣirò, láti inú nẹ́tíwọ̀ọ̀kì rẹ';

  @override
  String get searchForCity => 'Wá ìlú kan';

  @override
  String get locationPrivacyNote =>
      'A máa ń lo ibi tí o wà fún gbígba àsọtẹ́lẹ̀ nìkan.';

  @override
  String get locationServiceDisabled => 'Iṣẹ́ ìdámọ̀ ibi wà ní pípa.';

  @override
  String get locationPermissionDenied =>
      'A kò fún wa ní àṣẹ láti mọ ibi tí o wà.';

  @override
  String get locationPermissionBlocked =>
      'Àṣẹ ibi tí o wà ti di dídínà. O lè fàyè gbà á nínú Ètò.';

  @override
  String get locationUnavailable => 'A kò lè rí ibi tí o wà báyìí.';

  @override
  String get approximateBanner =>
      'À ń fi ibi ìṣirò hàn láti inú nẹ́tíwọ̀ọ̀kì rẹ.';

  @override
  String get usePrecise => 'Lo èyí tó péye';

  @override
  String get noPlacesTitle => 'Kò tíì sí ibì kankan';

  @override
  String get noPlacesBody =>
      'Lo ibi tí o wà tàbí ṣàfikún ìlú láti rí àsọtẹ́lẹ̀ rẹ̀.';

  @override
  String get noSavedPlaces =>
      'Kò tíì sí ibi tí a fi pamọ́. Tẹ + láti ṣàfikún ìlú.';

  @override
  String get yourLocation => 'Ibi tí o wà';

  @override
  String get approximateLocation => 'Ibi ìṣirò';

  @override
  String removeCity(String city) {
    return 'Yọ $city kúrò';
  }

  @override
  String get reorderHint => 'Tẹ ìlú kan mọ́lẹ̀ kí o sì fà á láti tún ètò ṣe.';

  @override
  String forecastLoadFailed(String city) {
    return 'A kò lè gbé àsọtẹ́lẹ̀ fún $city wá.';
  }

  @override
  String get forecastUnavailable => 'A kò lè gbé àsọtẹ́lẹ̀ wá';

  @override
  String get forecastErrorNetwork =>
      'A kò lè dé ọ̀dọ̀ iṣẹ́ ojú-ọjọ́. Ṣàyẹ̀wò ìsopọ̀ rẹ kí o sì gbìyànjú lẹ́ẹ̀kan sí i.';

  @override
  String get forecastErrorData =>
      'Iṣẹ́ ojú-ọjọ́ fi dátà tí a kò lè kà ránṣẹ́. Jọ̀wọ́ gbìyànjú lẹ́yìn náà.';

  @override
  String get couldNotRefresh => 'A kò lè sọ ọ́ dọ̀tun';

  @override
  String updatedAgo(String age) {
    return 'A sọ ọ́ dọ̀tun ní $age';
  }

  @override
  String get ageJustNow => 'ní báyìí báyìí';

  @override
  String ageMinutes(int count) {
    return 'ìṣẹ́jú $count sẹ́yìn';
  }

  @override
  String ageHours(int count) {
    return 'wákàtí $count sẹ́yìn';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ọjọ́ $count sẹ́yìn',
      one: 'ọjọ́ 1 sẹ́yìn',
    );
    return '$_temp0';
  }

  @override
  String feelsLike(String temperature) {
    return 'Ó rí bí $temperature';
  }

  @override
  String get rainChance => 'Àǹfààní òjò';

  @override
  String windWithDirection(String direction) {
    return 'Afẹ́fẹ́ $direction';
  }

  @override
  String get humidity => 'Ọ̀rinrin';

  @override
  String get daily => 'Ojoojúmọ́';

  @override
  String get hourly => 'Wákàtí-wákàtí';

  @override
  String get today => 'Òní';

  @override
  String get now => 'Báyìí';

  @override
  String get windDirection => 'Ìdarí afẹ́fẹ́';

  @override
  String get windGusts => 'Ìjì afẹ́fẹ́';

  @override
  String get rainToday => 'Òjò òní';

  @override
  String get pressure => 'Ìtẹ̀ afẹ́fẹ́';

  @override
  String get cloudCover => 'Ìbòji ìkùukùu';

  @override
  String get dewPoint => 'Ìwọ̀n ìrì';

  @override
  String get sunrise => 'Ìyọ oòrùn';

  @override
  String get sunset => 'Ìwọ̀ oòrùn';

  @override
  String semanticsCurrent(String temperature, String condition) {
    return 'Dígírì $temperature, $condition';
  }

  @override
  String semanticsDay(String day, String condition, String min, String max) {
    return '$day: $condition, láti $min sí $max';
  }

  @override
  String semanticsRainChance(int percent) {
    return 'Àǹfààní òjò $percent%';
  }

  @override
  String get compassPoints =>
      'N,NNE,NE,ENE,E,ESE,SE,SSE,S,SSW,SW,WSW,W,WNW,NW,NNW';

  @override
  String get settingsGeneral => 'Gbogbogbò';

  @override
  String get settingsTheme => 'Àwọ̀';

  @override
  String get themeAuto => 'Aládàáṣe';

  @override
  String get themeLight => 'Ìmọ́lẹ̀';

  @override
  String get themeDark => 'Òkùnkùn';

  @override
  String get settingsLanguage => 'Èdè';

  @override
  String get languageSystem => 'Ti ẹ̀rọ';

  @override
  String get settingsTemperature => 'Ìgbóná';

  @override
  String get unitCelsius => 'Celsius (°C)';

  @override
  String get unitFahrenheit => 'Fahrenheit (°F)';

  @override
  String get settingsWindSpeed => 'Ìyára afẹ́fẹ́';

  @override
  String get unitKmh => 'Kìlómítà ní wákàtí (km/h)';

  @override
  String get unitMph => 'Máìlì ní wákàtí (mph)';

  @override
  String get unitMs => 'Mítà ní ìṣẹ́jú-àáyá (m/s)';

  @override
  String get unitKnots => 'Knots (kn)';

  @override
  String get settingsPrecipitation => 'Òjò';

  @override
  String get unitMm => 'Mìlímítà (mm)';

  @override
  String get unitInch => 'Ínṣì (in)';

  @override
  String get settingsAbout => 'Nípa';

  @override
  String get aboutApp => 'Nípa BWeather';

  @override
  String get privacyPolicy => 'Ìlànà ìpamọ́';

  @override
  String get termsOfUse => 'Àwọn òfin lílò';

  @override
  String version(String version) {
    return 'Ẹ̀dà $version';
  }

  @override
  String get aboutDescription =>
      'BWeather ń fi ojú-ọjọ́ lọ́wọ́lọ́wọ́ àti àsọtẹ́lẹ̀ hàn fún ibi tí o wà àti àwọn ibi tí o fi pamọ́. Nobel ló ń ṣe é tí ó sì ń tọ́jú rẹ̀ fún Bsoft Limited.';

  @override
  String get aboutDataSources => 'Orísun dátà';

  @override
  String get aboutOpenMeteo =>
      'Ojú-ọjọ́ àti ìwádìí ibi: Open-Meteo (open-meteo.com), lábẹ́ ìwé-àṣẹ CC BY 4.0.';

  @override
  String get aboutOsm =>
      'Orúkọ ibi: © àwọn olùkópa OpenStreetMap (Nominatim), ODbL.';

  @override
  String get aboutIpapi => 'Ibi ìṣirò: ipapi.co.';

  @override
  String get aboutIcons =>
      'Àwòrán ojú-ọjọ́: Meteocons láti ọwọ́ Bas Milius (MIT).';

  @override
  String get privacyIntro =>
      'BWeather kò ní àkáǹtì, kò ní ìpolówó, kò sì ń tọpinpin lílò. Ojú-ìwé yìí ṣàlàyé dátà tó ń kúrò lórí ẹ̀rọ rẹ àti ìdí rẹ̀.';

  @override
  String get privacyLocationTitle => 'Ibi tí o wà';

  @override
  String get privacyLocationBody =>
      'Bí o bá fàyè gbà á, àpù náà máa ka ibi tí ẹ̀rọ rẹ wà. A máa ń fi ìpoidojú ránṣẹ́ sí Open-Meteo láti gba àsọtẹ́lẹ̀, àti sí OpenStreetMap Nominatim láti gba orúkọ ibẹ̀. A kò fi wọ́n ránṣẹ́ sí ibòmíràn.';

  @override
  String get privacyApproximateTitle => 'Ibi ìṣirò';

  @override
  String get privacyApproximateBody =>
      'Nígbà tí ibi tó péye kò bá sí, àpù náà máa béèrè ibi ìṣirò ní ìpele ìlú lọ́wọ́ ipapi.co. ipapi.co máa rí àdírẹ́sì IP rẹ láti dáhùn ìbéèrè yìí.';

  @override
  String get privacySearchTitle => 'Ìwádìí ìlú';

  @override
  String get privacySearchBody =>
      'Ọ̀rọ̀ tí o tẹ̀ sínú ìwádìí ìlú ni a ń fi ránṣẹ́ sí iṣẹ́ geocoding ti Open-Meteo láti wá àwọn ibi tó bá a mu.';

  @override
  String get privacyStorageTitle => 'Dátà tí a fi pamọ́ sórí ẹ̀rọ rẹ';

  @override
  String get privacyStorageBody =>
      'Àwọn ìlú tí o fi pamọ́, àsọtẹ́lẹ̀ tuntun àti ètò rẹ wà lórí ẹ̀rọ yìí nìkan. Yíyọ àpù náà kúrò máa pa wọ́n rẹ́.';

  @override
  String get privacyContactTitle => 'Ìkànsí';

  @override
  String get privacyContactBody =>
      'Ṣé o ní ìbéèrè nípa ìpamọ́? Kàn sí Bsoft Limited nípasẹ̀ ojú-ìwé àpù náà ní ilé ìtajà.';

  @override
  String get termsIntro => 'Nípa lílo BWeather, o gbà sí àwọn òfin wọ̀nyí.';

  @override
  String get termsAccuracyTitle => 'Ìpéye àsọtẹ́lẹ̀';

  @override
  String get termsAccuracyBody =>
      'Àsọtẹ́lẹ̀ jẹ́ ìṣirò, ó sì lè ṣàṣìṣe. Má ṣe gbára lé BWeather fún ìpinnu tó kan ààbò; tẹ̀lé ìkìlọ̀ àṣẹ láti ọ̀dọ̀ àjọ ojú-ọjọ́ orílẹ̀-èdè rẹ.';

  @override
  String get termsServiceTitle => 'Iṣẹ́ náà';

  @override
  String get termsServiceBody =>
      'A pèsè BWeather \"bí ó ti rí\", láìsí ìdánilójú kankan. Àwọn ẹ̀yà lè yí padà, iṣẹ́ náà sì lè má sí nígbà mìíràn.';

  @override
  String get termsThirdPartyTitle => 'Dátà ẹlòmíràn';

  @override
  String get termsThirdPartyBody =>
      'Dátà ojú-ọjọ́ wá láti Open-Meteo, orúkọ ibi sì wá láti OpenStreetMap. Òfin àti ìwé-àṣẹ tiwọn ló kan dátà náà.';

  @override
  String legalLastUpdated(String date) {
    return 'Ìgbà ìkẹyìn tí a ṣe àtúnṣe: $date';
  }

  @override
  String get wmo0 => 'Ojú ọ̀run mọ́';

  @override
  String get wmo1 => 'Ó mọ́ jùlọ';

  @override
  String get wmo2 => 'Ìkùukùu díẹ̀';

  @override
  String get wmo3 => 'Ìkùukùu bò ó';

  @override
  String get wmo45 => 'Kùrukùru';

  @override
  String get wmo48 => 'Kùrukùru oníyìnyín';

  @override
  String get wmo51 => 'Òjò wínníwínní díẹ̀';

  @override
  String get wmo53 => 'Òjò wínníwínní';

  @override
  String get wmo55 => 'Òjò wínníwínní púpọ̀';

  @override
  String get wmo56 => 'Òjò wínníwínní dídì díẹ̀';

  @override
  String get wmo57 => 'Òjò wínníwínní dídì púpọ̀';

  @override
  String get wmo61 => 'Òjò díẹ̀';

  @override
  String get wmo63 => 'Òjò àárín';

  @override
  String get wmo65 => 'Òjò líle';

  @override
  String get wmo66 => 'Òjò dídì díẹ̀';

  @override
  String get wmo67 => 'Òjò dídì líle';

  @override
  String get wmo71 => 'Yìnyín díẹ̀';

  @override
  String get wmo73 => 'Yìnyín àárín';

  @override
  String get wmo75 => 'Yìnyín púpọ̀';

  @override
  String get wmo77 => 'Wóró yìnyín';

  @override
  String get wmo80 => 'Ọ̀wààrà òjò díẹ̀';

  @override
  String get wmo81 => 'Ọ̀wààrà òjò àárín';

  @override
  String get wmo82 => 'Ọ̀wààrà òjò líle gan-an';

  @override
  String get wmo85 => 'Ọ̀wààrà yìnyín díẹ̀';

  @override
  String get wmo86 => 'Ọ̀wààrà yìnyín púpọ̀';

  @override
  String get wmo95 => 'Ààrá àti mànàmáná';

  @override
  String get wmo96 => 'Ààrá pẹ̀lú yìnyín díẹ̀';

  @override
  String get wmo99 => 'Ààrá pẹ̀lú yìnyín púpọ̀';

  @override
  String get wmoUnknown => 'Ojú-ọjọ́ tí a kò mọ̀';

  @override
  String get pageNotFound => 'A kò rí ojú-ìwé náà';

  @override
  String get airQuality => 'Dídára afẹ́fẹ́';

  @override
  String airQualityIndex(int value) {
    return 'US AQI $value';
  }

  @override
  String get aqiGood => 'Dára';

  @override
  String get aqiModerate => 'Àárín';

  @override
  String get aqiSensitive => 'Kò dára fún àwọn tó ní ìpalára';

  @override
  String get aqiUnhealthy => 'Kò dára fún ìlera';

  @override
  String get aqiVeryUnhealthy => 'Kò dára rárá fún ìlera';

  @override
  String get aqiHazardous => 'Léwu';

  @override
  String get pm25 => 'PM2.5';

  @override
  String get pm10 => 'PM10';

  @override
  String get dust => 'Eruku';

  @override
  String get uvIndex => 'Ìwọ̀n UV';

  @override
  String get uvLow => 'kéré';

  @override
  String get uvModerate => 'àárín';

  @override
  String get uvHigh => 'ga';

  @override
  String get uvVeryHigh => 'ga gan-an';

  @override
  String get uvExtreme => 'ga jù';

  @override
  String get pollen => 'Eruku òdòdó';

  @override
  String get pollenAlder => 'Alder';

  @override
  String get pollenBirch => 'Birch';

  @override
  String get pollenGrass => 'Koríko';

  @override
  String get pollenMugwort => 'Mugwort';

  @override
  String get pollenOlive => 'Ólífì';

  @override
  String get pollenRagweed => 'Ragweed';

  @override
  String get harmattanDustHint =>
      'Eruku pọ̀ (ọyẹ́): ronú láti wọ ìbòmú ní òde.';

  @override
  String get chart => 'Àwòrán ìyàtọ̀';

  @override
  String get chartLegendTemperature => 'Ìgbóná';

  @override
  String get chartLegendRain => 'Àǹfààní òjò';

  @override
  String get settingsNotifications => 'Ìwífún';

  @override
  String get notifyMorningBrief => 'Àkópọ̀ òwúrọ̀';

  @override
  String get notifyMorningBriefDetail =>
      'Àsọtẹ́lẹ̀ òní fún ibi tí o wà ní gbogbo òwúrọ̀.';

  @override
  String get notifyBriefTime => 'Àkókò';

  @override
  String get notifyRain => 'Ìkìlọ̀ òjò';

  @override
  String get notifyRainDetail =>
      'Nígbà tí òjò lè rọ̀ láàrin wákàtí 2 tó ń bọ̀.';

  @override
  String get notifySevere => 'Ojú-ọjọ́ líle';

  @override
  String get notifySevereDetail =>
      'Ààrá, afẹ́fẹ́ líle gan-an tàbí ooru tó pọ̀ jù.';

  @override
  String get notifyPermissionDenied =>
      'Ìwífún BWeather wà ní pípa nínú ètò ẹ̀rọ rẹ.';

  @override
  String get notifyUnsupported => 'Ìwífún wà nínú àpù Android.';

  @override
  String get notifyBackgroundNote =>
      'A máa ń ṣàyẹ̀wò ìkìlọ̀ ní ẹ̀ẹ̀kan ní wákàtí kọ̀ọ̀kan, nítorí náà wọ́n lè pẹ́ díẹ̀.';

  @override
  String get notifyChannelForecast => 'Àsọtẹ́lẹ̀';

  @override
  String get notifyChannelAlerts => 'Ìkìlọ̀ ojú-ọjọ́';

  @override
  String briefTitle(String place) {
    return 'Òní ní $place';
  }

  @override
  String briefBody(String condition, String min, String max, int rain) {
    return '$condition, láti $min sí $max. Àǹfààní òjò $rain%.';
  }

  @override
  String rainAlertTitle(String place) {
    return 'A retí òjò ní $place';
  }

  @override
  String rainAlertBody(int percent, String time) {
    return 'Àǹfààní òjò $percent% ní àyíká $time.';
  }

  @override
  String severeThunderTitle(String place) {
    return 'Ààrá nítòsí $place';
  }

  @override
  String severeThunderBody(String time) {
    return 'A retí ààrá ní àyíká $time. Dúró nínú ilé bí o bá lè ṣe é.';
  }

  @override
  String severeWindTitle(String place) {
    return 'Afẹ́fẹ́ líle ní $place';
  }

  @override
  String severeWindBody(String speed) {
    return 'A retí ìjì afẹ́fẹ́ tó tó $speed lónìí.';
  }

  @override
  String severeHeatTitle(String place) {
    return 'Ooru gbígbóná ní $place';
  }

  @override
  String severeHeatBody(String temperature) {
    return 'Yóò rí bí $temperature lónìí. Mu omi kí o sì yẹra fún oòrùn ọ̀sán.';
  }

  @override
  String get aboutCams =>
      'Dídára afẹ́fẹ́: a ṣe é pẹ̀lú ìwífún láti Copernicus Atmosphere Monitoring Service (nípasẹ̀ Open-Meteo).';

  @override
  String widgetRange(String max, String min) {
    return 'Gíga $max · Kékeré $min';
  }

  @override
  String widgetUpdated(String time) {
    return 'A sọ ọ́ dọ̀tun $time';
  }

  @override
  String get tipsTitle => 'Ìmọ̀ràn òní';

  @override
  String tipUmbrella(int percent, String time) {
    return 'Mú agboòrùn: àǹfààní òjò $percent%, ó ṣeé ṣe jùlọ ní àyíká $time.';
  }

  @override
  String get tipClothesHot => 'Wọ aṣọ fífúyẹ́ tí afẹ́fẹ́ ń wọ̀.';

  @override
  String get tipClothesWarm => 'Ojú-ọjọ́ T-shirt ni.';

  @override
  String get tipClothesMild => 'Mú jákẹ́ẹ̀tì fífúyẹ́ dání.';

  @override
  String get tipClothesCool => 'Wọ jákẹ́ẹ̀tì tó ń mú ara gbóná.';

  @override
  String get tipClothesCold => 'Bo ara rẹ dáadáa: òtútù wà níta.';

  @override
  String tipSunscreen(String level) {
    return 'UV $level lónìí: lo ìpara ààbò oòrùn àti fìlà láàrin 10:00 sí 16:00.';
  }

  @override
  String tipHydrate(String temperature) {
    return 'Yóò rí bí $temperature. Mu omi púpọ̀.';
  }

  @override
  String get tipLaundryGood => 'Ọjọ́ tó dára láti sá aṣọ síta.';

  @override
  String get tipLaundryBad => 'Kì í ṣe ọjọ́ tó dára láti sá aṣọ síta.';

  @override
  String tipBestOutdoorTime(String time) {
    return 'Àkókò tó dára jùlọ láti wà níta: ní àyíká $time.';
  }

  @override
  String get tipAirQuality =>
      'Afẹ́fẹ́ kò dára: dín iṣẹ́ gígùn tàbí eré ìdárayá líle níta kù.';

  @override
  String get tipMosquitoes =>
      'Ìrọ̀lẹ́ gbígbóná àti ọ̀rinrin: ẹ̀fọn lè pọ̀, lo oògùn ẹ̀fọn tàbí àwọ̀n.';

  @override
  String tipDriveFog(String time) {
    return 'Wakọ̀ pẹ̀lú ìṣọ́ra: a retí kùrukùru ní àyíká $time.';
  }

  @override
  String tipDriveRain(String time) {
    return 'Wakọ̀ pẹ̀lú ìṣọ́ra: a retí òjò líle ní àyíká $time.';
  }

  @override
  String get refresh => 'Sọ dọ̀tun';

  @override
  String get settingsDisplay => 'Ìfihàn àti dátà';

  @override
  String get settingsAnimatedBackground => 'Ẹ̀yìn tó ń rìn';

  @override
  String get settingsAnimatedBackgroundDetail =>
      'Ojú ọ̀run tó ń rìn lẹ́yìn àsọtẹ́lẹ̀. Ó máa dúró jẹ́ẹ́ bí ẹ̀rọ rẹ bá ti dín ìṣípòpadà kù.';

  @override
  String get settingsMinuteRain => 'Òjò ìṣẹ́jú-ìṣẹ́jú';

  @override
  String get settingsMinuteRainDetail =>
      'Òjò wákàtí 2 tó ń bọ̀ ní ìṣẹ́jú 15-15. Ó ń lo dátà díẹ̀ sí i.';

  @override
  String get settingsCrashReports => 'Fi ìròyìn ìjamba àpù ránṣẹ́';

  @override
  String get settingsCrashReportsDetail =>
      'Àlàyé àṣìṣe láìsí orúkọ tó ń ṣèrànwọ́ láti tún àṣìṣe ṣe. Kò sí ibi tí o wà tàbí dátà ara ẹni.';

  @override
  String get nextTwoHours => 'Wákàtí 2 tó ń bọ̀';

  @override
  String rainStartingIn(int minutes) {
    return 'Òjò yóò bẹ̀rẹ̀ ní nǹkan bí ìṣẹ́jú $minutes';
  }

  @override
  String rainStoppingIn(int minutes) {
    return 'Òjò yóò dá ní nǹkan bí ìṣẹ́jú $minutes';
  }

  @override
  String get rainContinuing => 'Òjò fún ó kéré tán wákàtí 2 tó ń bọ̀';

  @override
  String get noRainSoon => 'A kò retí òjò láàrin wákàtí 2 tó ń bọ̀';

  @override
  String get tempAboutNormal => 'Bí ó ti máa ń rí lónìí';

  @override
  String tempWarmerThanUsual(int degrees) {
    return 'Ó gbóná ju ti tẹ́lẹ̀ lọ ní $degrees°';
  }

  @override
  String tempCoolerThanUsual(int degrees) {
    return 'Ó tutù ju ti tẹ́lẹ̀ lọ ní $degrees°';
  }

  @override
  String tempNormalsSource(String fromYear, String toYear) {
    return 'Ìgbóná gíga òní tí a fi wé ìpíndọ́gba ìgbóná gíga ọjọ́ yìí, $fromYear–$toYear.';
  }

  @override
  String get radar => 'Radar òjò';

  @override
  String get radarUnavailable => 'Radar kò sí báyìí.';

  @override
  String get radarNoCoverage =>
      'Radar ń fi wákàtí 2 tó kọjá hàn. Àwọn agbègbè kan kò ní ìbòji tó pé.';

  @override
  String get play => 'Bẹ̀rẹ̀';

  @override
  String get pause => 'Dánudúró';

  @override
  String get aboutRainViewer =>
      'Radar: dátà ojú-ọjọ́ láti RainViewer; máàpù © àwọn olùkópa OpenStreetMap.';

  @override
  String get privacyRadarTitle => 'Máàpù radar';

  @override
  String get privacyRadarBody =>
      'Ṣíṣí radar máa gba àwọn ègé máàpù láti OpenStreetMap àti àwòrán radar láti RainViewer fún agbègbè tí o ń wò. Bí ojú-òpó wẹ́ẹ̀bù èyíkéyìí, wọ́n máa rí àdírẹ́sì IP rẹ.';

  @override
  String get privacyCrashTitle => 'Ìròyìn ìjamba àpù';

  @override
  String get privacyCrashBody =>
      'Bí àpù náà bá jamba, a lè fi ìròyìn àṣìṣe láìsí orúkọ (irú ẹ̀rọ, ẹ̀dà ètò ẹ̀rọ, ẹ̀dà àpù àti àṣìṣe náà) ránṣẹ́ sí Sentry kí a lè tún un ṣe. Kò ní ibi tí o wà, àwọn ibi tí o fi pamọ́ tàbí àdírẹ́sì IP rẹ nínú rárá. O lè pa èyí nínú Ètò.';

  @override
  String get aboutHistory =>
      'Ìpíndọ́gba ojú-ọjọ́: Open-Meteo historical weather API (ERA5).';

  @override
  String get zoomIn => 'Sún mọ́';

  @override
  String get zoomOut => 'Sún jìnnà';

  @override
  String get settingsAppearance => 'Ìrísí';

  @override
  String get settingsUnits => 'Ìwọ̀n';

  @override
  String get settingsPrivacy => 'Ìpamọ́';

  @override
  String cityRemoved(String city) {
    return 'A ti yọ $city kúrò';
  }

  @override
  String get undo => 'Dá padà';

  @override
  String get sunAndMoon => 'Oòrùn àti òṣùpá';

  @override
  String get daylight => 'Ìmọ́lẹ̀ ọjọ́';

  @override
  String daylightDuration(int hours, int minutes) {
    return 'Wákàtí $hours ìṣẹ́jú $minutes';
  }

  @override
  String get moonNew => 'Òṣùpá tuntun';

  @override
  String get moonWaxingCrescent => 'Òṣùpá ń dàgbà (kékeré)';

  @override
  String get moonFirstQuarter => 'Ìdá mẹ́rin àkọ́kọ́';

  @override
  String get moonWaxingGibbous => 'Òṣùpá ń dàgbà (ńlá)';

  @override
  String get moonFull => 'Òṣùpá kíkún';

  @override
  String get moonWaningGibbous => 'Òṣùpá ń dínkù (ńlá)';

  @override
  String get moonLastQuarter => 'Ìdá mẹ́rin ìkẹyìn';

  @override
  String get moonWaningCrescent => 'Òṣùpá ń dínkù (kékeré)';

  @override
  String moonIllumination(int percent) {
    return 'Ìmọ́lẹ̀ $percent%';
  }

  @override
  String get navTrips => 'Ìrìn-àjò';

  @override
  String get tripsEmptyTitle => 'Kò tíì sí ìrìn-àjò';

  @override
  String get tripsEmptyBody =>
      'Ṣètò ìrìn-àjò kan láti rí ojú-ọjọ́ ní ibùdó kọ̀ọ̀kan, lójoojúmọ́.';

  @override
  String get planTrip => 'Ṣètò ìrìn-àjò';

  @override
  String get newTrip => 'Ìrìn-àjò tuntun';

  @override
  String get editTrip => 'Ṣàtúnṣe ìrìn-àjò';

  @override
  String get tripName => 'Orúkọ ìrìn-àjò';

  @override
  String get tripNameHint => 'àpẹẹrẹ: Kérésìmesì ní Àbújá';

  @override
  String tripDefaultName(String place) {
    return 'Ìrìn-àjò sí $place';
  }

  @override
  String get tripStops => 'Àwọn ibùdó';

  @override
  String get addStop => 'Ṣàfikún ibùdó';

  @override
  String get removeStop => 'Yọ ibùdó kúrò';

  @override
  String get chooseDates => 'Yan ọjọ́';

  @override
  String get save => 'Fi pamọ́';

  @override
  String get deleteTrip => 'Pa ìrìn-àjò rẹ́';

  @override
  String get tripDeleted => 'A ti pa ìrìn-àjò rẹ́';

  @override
  String get tripProblemNoStops => 'Ṣàfikún ó kéré tán ibùdó kan.';

  @override
  String get tripProblemOrder =>
      'Ibùdó kọ̀ọ̀kan gbọ́dọ̀ bẹ̀rẹ̀ ní ọjọ́ tí èyí tó ṣáájú parí tàbí lẹ́yìn rẹ̀.';

  @override
  String tripProblemTooLong(int days) {
    return 'Ìrìn-àjò kò lè ju ọjọ́ $days lọ.';
  }

  @override
  String tripStartsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yóò bẹ̀rẹ̀ ní ọjọ́ $count',
      one: 'Yóò bẹ̀rẹ̀ lọ́la',
      zero: 'Yóò bẹ̀rẹ̀ lónìí',
    );
    return '$_temp0';
  }

  @override
  String get tripOngoing => 'Ó ń lọ lọ́wọ́';

  @override
  String get tripEnded => 'Ó ti parí';

  @override
  String tripDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ọjọ́ $count',
      one: 'Ọjọ́ 1',
    );
    return '$_temp0';
  }

  @override
  String travelDay(String place) {
    return 'Ọjọ́ ìrìn láti $place';
  }

  @override
  String get typicalWeather => 'Bí ó ti máa ń rí ní ọjọ́ yìí';

  @override
  String typicalWeatherNote(int days) {
    return 'Àwọn ọjọ́ tó ju ọjọ́ $days lọ ń fi ojú-ọjọ́ tó wọ́pọ̀ fún ọjọ́ náà hàn (ìpíndọ́gba ọdún 20 sẹ́yìn). Àsọtẹ́lẹ̀ yóò rọ́pò rẹ̀ fúnra rẹ̀ bí ìrìn-àjò ṣe ń sún mọ́.';
  }

  @override
  String get weatherUnknown => 'Kò tíì sí dátà';

  @override
  String get packingList => 'Àkójọ ẹrù';

  @override
  String get packingEmpty => 'Kò sí nǹkan pàtàkì láti kó fún ojú-ọjọ́ yìí.';

  @override
  String get packUmbrella => 'Agboòrùn';

  @override
  String get packRainJacket => 'Aṣọ òjò';

  @override
  String get packSunscreen => 'Ìpara ààbò oòrùn';

  @override
  String get packSunglasses => 'Gíláàsì oòrùn';

  @override
  String get packHat => 'Fìlà oòrùn';

  @override
  String get packLightClothes => 'Aṣọ fífúyẹ́';

  @override
  String get packWaterBottle => 'Ìgò omi';

  @override
  String get packWarmLayer => 'Súwẹ́tà tó ń mú ara gbóná';

  @override
  String get packCoat => 'Ẹ̀wù òtútù';

  @override
  String get packGloves => 'Ìbọ̀wọ́';

  @override
  String get packWindbreaker => 'Aṣọ ààbò afẹ́fẹ́';

  @override
  String get packInsectRepellent => 'Oògùn ẹ̀fọn';

  @override
  String get shareTrip => 'Pín';

  @override
  String get tripReminder => 'Rán mi létí ní ọjọ́ tó ṣáájú';

  @override
  String get tripReminderDetail =>
      'Ìwífún ní ìrọ̀lẹ́ ọjọ́ tó ṣáájú ìrìn-àjò, pẹ̀lú àsọtẹ́lẹ̀ fún ibùdó àkọ́kọ́.';

  @override
  String tripReminderTitle(String place) {
    return 'Ìrìn-àjò rẹ sí $place bẹ̀rẹ̀ lọ́la';
  }

  @override
  String get tripReminderBodyFallback => 'Wo àsọtẹ́lẹ̀ ojú-ọjọ́ kí o tó lọ.';

  @override
  String tripOutlookRange(String low, String high) {
    return '$low sí $high';
  }

  @override
  String tripRainyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Òjò lè rọ̀ ní ọjọ́ $count',
      one: 'Òjò lè rọ̀ ní ọjọ́ 1',
      zero: 'A kò retí òjò',
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
    return '$day · $place: $condition, $min sí $max, òjò $rain%';
  }

  @override
  String shareTypicalDay(String day, String place, String min, String max) {
    return '$day · $place: ní gbogbo ìgbà $min sí $max';
  }

  @override
  String get sharedFromApp => 'A pín in láti BWeather';

  @override
  String get privacyTripsTitle => 'Ìrìn-àjò';

  @override
  String get privacyTripsBody =>
      'Àwọn ìrìn-àjò tí o ṣètò wà lórí ẹ̀rọ yìí nìkan. Láti gba ojú-ọjọ́ wọn, a ń fi ìpoidojú àti ọjọ́ ibùdó kọ̀ọ̀kan ránṣẹ́ sí Open-Meteo.';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hausa (`ha`).
class AppLocalizationsHa extends AppLocalizations {
  AppLocalizationsHa([String locale = 'ha']) : super(locale);

  @override
  String get appTitle => 'BWeather';

  @override
  String get navForecast => 'Hasashe';

  @override
  String get navLocations => 'Wurare';

  @override
  String get navSettings => 'Saituna';

  @override
  String get addCity => 'Ƙara birni';

  @override
  String get searchHint => 'Nemo birane';

  @override
  String get clearSearch => 'Share bincike';

  @override
  String get close => 'Rufe';

  @override
  String get retry => 'Sake gwadawa';

  @override
  String get keepTyping => 'Ci gaba da rubutu…';

  @override
  String get searchFailed =>
      'Bincike ya kasa. Duba haɗin intanet ɗinka sannan ka sake gwadawa.';

  @override
  String noPlacesMatch(String query) {
    return 'Babu wurin da ya dace da \"$query\".';
  }

  @override
  String get welcomeTitle => 'Barka da zuwa BWeather';

  @override
  String get welcomeSubtitle =>
      'Hasashen yanayi na inda kake da wuraren da kake damuwa da su.';

  @override
  String get useMyLocation => 'Yi amfani da wurina';

  @override
  String get findingYou => 'Ana neman wurinka…';

  @override
  String get openSettings => 'Buɗe saituna';

  @override
  String continueWith(String place) {
    return 'Ci gaba da $place';
  }

  @override
  String get approximateFromNetwork =>
      'Kimanin wuri, bisa ga hanyar sadarwarka';

  @override
  String get searchForCity => 'Nemo birni';

  @override
  String get locationPrivacyNote =>
      'Ana amfani da wurinka ne kawai don samo hasashen yanayi.';

  @override
  String get locationServiceDisabled => 'An kashe sabis ɗin wuri.';

  @override
  String get locationPermissionDenied => 'Ba a ba da izinin wuri ba.';

  @override
  String get locationPermissionBlocked =>
      'An toshe izinin wuri. Za ka iya ba da izini a cikin Saituna.';

  @override
  String get locationUnavailable => 'Ba mu iya gano wurinka a yanzu ba.';

  @override
  String get approximateBanner =>
      'Ana nuna kimanin wuri bisa ga hanyar sadarwarka.';

  @override
  String get usePrecise => 'Yi amfani da daidai';

  @override
  String get noPlacesTitle => 'Babu wurare tukuna';

  @override
  String get noPlacesBody =>
      'Yi amfani da wurinka ko ƙara birni don ganin hasashen yanayinsa.';

  @override
  String get noSavedPlaces =>
      'Babu wuraren da aka adana tukuna. Matsa + don ƙara birni.';

  @override
  String get yourLocation => 'Wurinka';

  @override
  String get approximateLocation => 'Kimanin wuri';

  @override
  String removeCity(String city) {
    return 'Cire $city';
  }

  @override
  String get reorderHint =>
      'Danna ka riƙe birni sannan ka ja shi don sake tsara jerin.';

  @override
  String forecastLoadFailed(String city) {
    return 'Ba a iya loda hasashen yanayi na $city ba.';
  }

  @override
  String get forecastUnavailable => 'Ba a iya loda hasashe ba';

  @override
  String get forecastErrorNetwork =>
      'Ba a iya isa ga sabis ɗin yanayi ba. Duba haɗinka sannan ka sake gwadawa.';

  @override
  String get forecastErrorData =>
      'Sabis ɗin yanayi ya aiko da bayanan da ba mu iya karantawa ba. Da fatan za a sake gwadawa nan gaba.';

  @override
  String get couldNotRefresh => 'Ba a iya sabuntawa ba';

  @override
  String updatedAgo(String age) {
    return 'An sabunta $age';
  }

  @override
  String get ageJustNow => 'yanzu-yanzu';

  @override
  String ageMinutes(int count) {
    return 'minti $count da suka wuce';
  }

  @override
  String ageHours(int count) {
    return 'awa $count da suka wuce';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kwanaki $count da suka wuce',
      one: 'kwana 1 da ya wuce',
    );
    return '$_temp0';
  }

  @override
  String feelsLike(String temperature) {
    return 'Ana jin kamar $temperature';
  }

  @override
  String get rainChance => 'Yiwuwar ruwan sama';

  @override
  String windWithDirection(String direction) {
    return 'Iska $direction';
  }

  @override
  String get humidity => 'Danshi';

  @override
  String get daily => 'Kullum';

  @override
  String get hourly => 'Kowace awa';

  @override
  String get today => 'Yau';

  @override
  String get now => 'Yanzu';

  @override
  String get windDirection => 'Alƙiblar iska';

  @override
  String get windGusts => 'Guguwar iska';

  @override
  String get rainToday => 'Ruwan sama yau';

  @override
  String get pressure => 'Matsin iska';

  @override
  String get cloudCover => 'Rufewar gajimare';

  @override
  String get dewPoint => 'Matakin raɓa';

  @override
  String get sunrise => 'Fitowar rana';

  @override
  String get sunset => 'Faɗuwar rana';

  @override
  String semanticsCurrent(String temperature, String condition) {
    return 'Digiri $temperature, $condition';
  }

  @override
  String semanticsDay(String day, String condition, String min, String max) {
    return '$day: $condition, daga $min zuwa $max';
  }

  @override
  String semanticsRainChance(int percent) {
    return 'Yiwuwar ruwan sama $percent%';
  }

  @override
  String get compassPoints =>
      'N,NNE,NE,ENE,E,ESE,SE,SSE,S,SSW,SW,WSW,W,WNW,NW,NNW';

  @override
  String get settingsGeneral => 'Gabaɗaya';

  @override
  String get settingsTheme => 'Jigo';

  @override
  String get themeAuto => 'Atomatik';

  @override
  String get themeLight => 'Haske';

  @override
  String get themeDark => 'Duhu';

  @override
  String get settingsLanguage => 'Harshe';

  @override
  String get languageSystem => 'Tsohon saitin na\'ura';

  @override
  String get settingsTemperature => 'Zafin jiki';

  @override
  String get unitCelsius => 'Celsius (°C)';

  @override
  String get unitFahrenheit => 'Fahrenheit (°F)';

  @override
  String get settingsWindSpeed => 'Gudun iska';

  @override
  String get unitKmh => 'Kilomita a awa (km/h)';

  @override
  String get unitMph => 'Mil a awa (mph)';

  @override
  String get unitMs => 'Mita a daƙiƙa (m/s)';

  @override
  String get unitKnots => 'Knots (kn)';

  @override
  String get settingsPrecipitation => 'Ruwan sama';

  @override
  String get unitMm => 'Milimita (mm)';

  @override
  String get unitInch => 'Inci (in)';

  @override
  String get settingsAbout => 'Game da';

  @override
  String get aboutApp => 'Game da BWeather';

  @override
  String get privacyPolicy => 'Manufar sirri';

  @override
  String get termsOfUse => 'Sharuɗɗan amfani';

  @override
  String version(String version) {
    return 'Sigar $version';
  }

  @override
  String get aboutDescription =>
      'BWeather yana nuna yanayin yanzu da hasashe na wurinka da wuraren da ka adana. Nobel ne ke haɓakawa da kula da shi don Bsoft Limited.';

  @override
  String get aboutDataSources => 'Tushen bayanai';

  @override
  String get aboutOpenMeteo =>
      'Yanayi da binciken wurare: Open-Meteo (open-meteo.com), ƙarƙashin lasisin CC BY 4.0.';

  @override
  String get aboutOsm =>
      'Sunayen wurare: © masu bayar da gudummawa na OpenStreetMap (Nominatim), ODbL.';

  @override
  String get aboutIpapi => 'Kimanin wuri: ipapi.co.';

  @override
  String get aboutIcons => 'Alamomin yanayi: Meteocons na Bas Milius (MIT).';

  @override
  String get privacyIntro =>
      'BWeather ba shi da asusu, ba tallace-tallace, kuma ba ya bin diddigin amfani. Wannan shafi yana bayyana bayanan da ke barin na\'urarka da dalilin hakan.';

  @override
  String get privacyLocationTitle => 'Wurinka';

  @override
  String get privacyLocationBody =>
      'Idan ka yarda, manhajar tana karanta wurin na\'urarka. Ana aika wurin zuwa Open-Meteo don samun hasashe, da zuwa OpenStreetMap Nominatim don samun sunan wurin. Ba a aika su ko\'ina ba.';

  @override
  String get privacyApproximateTitle => 'Kimanin wuri';

  @override
  String get privacyApproximateBody =>
      'Idan babu daidaitaccen wuri, manhajar tana tambayar ipapi.co kimanin wuri a matakin birni. ipapi.co yana ganin adireshin IP ɗinka don amsa wannan buƙata.';

  @override
  String get privacySearchTitle => 'Binciken birni';

  @override
  String get privacySearchBody =>
      'Ana aika rubutun da ka shigar a binciken birni zuwa sabis ɗin Open-Meteo don nemo wuraren da suka dace.';

  @override
  String get privacyStorageTitle => 'Bayanan da aka adana a na\'urarka';

  @override
  String get privacyStorageBody =>
      'Biranen da ka adana, sabbin hasashe da saitunanka ana adana su ne a wannan na\'urar kaɗai. Cire manhajar yana share su.';

  @override
  String get privacyContactTitle => 'Tuntuɓa';

  @override
  String get privacyContactBody =>
      'Kana da tambayoyi game da sirri? Tuntuɓi Bsoft Limited ta shafin manhajar a shagon manhajoji.';

  @override
  String get termsIntro =>
      'Ta amfani da BWeather ka yarda da waɗannan sharuɗɗa.';

  @override
  String get termsAccuracyTitle => 'Daidaiton hasashe';

  @override
  String get termsAccuracyBody =>
      'Hasashen yanayi ƙiyasi ne kuma yana iya kuskure. Kada ka dogara da BWeather don yanke shawara da ta shafi tsaro; bi gargaɗin hukuma daga hukumar yanayi ta ƙasarka.';

  @override
  String get termsServiceTitle => 'Sabis ɗin';

  @override
  String get termsServiceBody =>
      'Ana bayar da BWeather \"kamar yadda yake\", ba tare da garanti ba. Fasaloli na iya canzawa, kuma sabis ɗin na iya rashin samuwa a wasu lokuta.';

  @override
  String get termsThirdPartyTitle => 'Bayanan wasu kamfanoni';

  @override
  String get termsThirdPartyBody =>
      'Bayanan yanayi suna fitowa daga Open-Meteo, sunayen wurare kuma daga OpenStreetMap. Sharuɗɗansu da lasisinsu ne ke aiki a kan waɗannan bayanai.';

  @override
  String legalLastUpdated(String date) {
    return 'Sabuntawa ta ƙarshe: $date';
  }

  @override
  String get wmo0 => 'Sararin sama a share';

  @override
  String get wmo1 => 'Kusan a share';

  @override
  String get wmo2 => 'Gajimare kaɗan';

  @override
  String get wmo3 => 'Gajimare ya rufe';

  @override
  String get wmo45 => 'Hazo';

  @override
  String get wmo48 => 'Hazo mai ƙanƙara';

  @override
  String get wmo51 => 'Yayyafi kaɗan';

  @override
  String get wmo53 => 'Yayyafi matsakaici';

  @override
  String get wmo55 => 'Yayyafi mai yawa';

  @override
  String get wmo56 => 'Yayyafi mai daskarewa kaɗan';

  @override
  String get wmo57 => 'Yayyafi mai daskarewa mai yawa';

  @override
  String get wmo61 => 'Ruwan sama kaɗan';

  @override
  String get wmo63 => 'Ruwan sama matsakaici';

  @override
  String get wmo65 => 'Ruwan sama mai ƙarfi';

  @override
  String get wmo66 => 'Ruwan sama mai daskarewa kaɗan';

  @override
  String get wmo67 => 'Ruwan sama mai daskarewa mai ƙarfi';

  @override
  String get wmo71 => 'Dusar ƙanƙara kaɗan';

  @override
  String get wmo73 => 'Dusar ƙanƙara matsakaiciya';

  @override
  String get wmo75 => 'Dusar ƙanƙara mai yawa';

  @override
  String get wmo77 => 'Ƙwayoyin dusar ƙanƙara';

  @override
  String get wmo80 => 'Ɗan ruwan sama na ɗan lokaci';

  @override
  String get wmo81 => 'Ruwan sama na ɗan lokaci matsakaici';

  @override
  String get wmo82 => 'Ruwan sama mai tsanani na ɗan lokaci';

  @override
  String get wmo85 => 'Dusar ƙanƙara kaɗan na ɗan lokaci';

  @override
  String get wmo86 => 'Dusar ƙanƙara mai yawa na ɗan lokaci';

  @override
  String get wmo95 => 'Tsawa da walƙiya';

  @override
  String get wmo96 => 'Tsawa tare da ƙanƙara kaɗan';

  @override
  String get wmo99 => 'Tsawa tare da ƙanƙara mai yawa';

  @override
  String get wmoUnknown => 'Yanayin da ba a sani ba';

  @override
  String get pageNotFound => 'Ba a sami shafin ba';

  @override
  String get airQuality => 'Ingancin iska';

  @override
  String airQualityIndex(int value) {
    return 'US AQI $value';
  }

  @override
  String get aqiGood => 'Mai kyau';

  @override
  String get aqiModerate => 'Matsakaici';

  @override
  String get aqiSensitive => 'Ba shi da kyau ga masu rauni';

  @override
  String get aqiUnhealthy => 'Ba shi da kyau ga lafiya';

  @override
  String get aqiVeryUnhealthy => 'Ba shi da kyau ko kaɗan';

  @override
  String get aqiHazardous => 'Mai haɗari';

  @override
  String get pm25 => 'PM2.5';

  @override
  String get pm10 => 'PM10';

  @override
  String get dust => 'Ƙura';

  @override
  String get uvIndex => 'Ma\'aunin UV';

  @override
  String get uvLow => 'ƙasa';

  @override
  String get uvModerate => 'matsakaici';

  @override
  String get uvHigh => 'sama';

  @override
  String get uvVeryHigh => 'sama sosai';

  @override
  String get uvExtreme => 'mai tsanani';

  @override
  String get pollen => 'Furen fure (pollen)';

  @override
  String get pollenAlder => 'Alder';

  @override
  String get pollenBirch => 'Birch';

  @override
  String get pollenGrass => 'Ciyawa';

  @override
  String get pollenMugwort => 'Mugwort';

  @override
  String get pollenOlive => 'Zaitun';

  @override
  String get pollenRagweed => 'Ragweed';

  @override
  String get harmattanDustHint =>
      'Ƙura mai yawa (hunturu): ka yi la\'akari da sanya takunkumi a waje.';

  @override
  String get chart => 'Jadawali';

  @override
  String get chartLegendTemperature => 'Zafin jiki';

  @override
  String get chartLegendRain => 'Yiwuwar ruwan sama';

  @override
  String get settingsNotifications => 'Sanarwa';

  @override
  String get notifyMorningBrief => 'Bayanin safe';

  @override
  String get notifyMorningBriefDetail =>
      'Hasashen yau na wurinka kowace safiya.';

  @override
  String get notifyBriefTime => 'Lokaci';

  @override
  String get notifyRain => 'Gargaɗin ruwan sama';

  @override
  String get notifyRainDetail =>
      'Idan da yiwuwar ruwan sama cikin awa 2 masu zuwa.';

  @override
  String get notifySevere => 'Mummunan yanayi';

  @override
  String get notifySevereDetail =>
      'Tsawa, iska mai ƙarfi sosai ko zafi mai tsanani.';

  @override
  String get notifyPermissionDenied =>
      'An kashe sanarwar BWeather a cikin saitunan na\'urarka.';

  @override
  String get notifyUnsupported => 'Sanarwa tana samuwa a manhajar Android.';

  @override
  String get notifyBackgroundNote =>
      'Ana duba gargaɗi kusan sau ɗaya a kowace awa, don haka suna iya zuwa a makare kaɗan.';

  @override
  String get notifyChannelForecast => 'Hasashe';

  @override
  String get notifyChannelAlerts => 'Gargaɗin yanayi';

  @override
  String briefTitle(String place) {
    return 'Yau a $place';
  }

  @override
  String briefBody(String condition, String min, String max, int rain) {
    return '$condition, daga $min zuwa $max. Yiwuwar ruwan sama $rain%.';
  }

  @override
  String rainAlertTitle(String place) {
    return 'Ana sa ran ruwan sama a $place';
  }

  @override
  String rainAlertBody(int percent, String time) {
    return 'Yiwuwar ruwan sama $percent% a kusan $time.';
  }

  @override
  String severeThunderTitle(String place) {
    return 'Tsawa kusa da $place';
  }

  @override
  String severeThunderBody(String time) {
    return 'Ana sa ran tsawa a kusan $time. Ka zauna a cikin gida idan za ka iya.';
  }

  @override
  String severeWindTitle(String place) {
    return 'Iska mai ƙarfi a $place';
  }

  @override
  String severeWindBody(String speed) {
    return 'Ana sa ran guguwar iska har zuwa $speed yau.';
  }

  @override
  String severeHeatTitle(String place) {
    return 'Zafi mai tsanani a $place';
  }

  @override
  String severeHeatBody(String temperature) {
    return 'Yau za a ji kamar $temperature. Sha ruwa kuma ka guji rana ta tsakar rana.';
  }

  @override
  String get aboutCams =>
      'Ingancin iska: an samar ta amfani da bayanan Copernicus Atmosphere Monitoring Service (ta hanyar Open-Meteo).';

  @override
  String widgetRange(String max, String min) {
    return 'Mafi zafi $max · Mafi sanyi $min';
  }

  @override
  String widgetUpdated(String time) {
    return 'An sabunta $time';
  }

  @override
  String get tipsTitle => 'Shawarwarin yau';

  @override
  String tipUmbrella(int percent, String time) {
    return 'Ɗauki laima: yiwuwar ruwan sama $percent%, mafi yiwuwa a kusan $time.';
  }

  @override
  String get tipClothesHot =>
      'Sanya tufafi masu sauƙi da ke barin iska ta shiga.';

  @override
  String get tipClothesWarm => 'Yanayin rigar T-shirt ne.';

  @override
  String get tipClothesMild => 'Ɗauki jaket mai sauƙi.';

  @override
  String get tipClothesCool => 'Sanya jaket mai ɗumi.';

  @override
  String get tipClothesCold => 'Ka lulluɓe sosai: akwai sanyi a waje.';

  @override
  String tipSunscreen(String level) {
    return 'UV yana $level yau: yi amfani da man kariya daga rana da hula tsakanin 10:00 da 16:00.';
  }

  @override
  String tipHydrate(String temperature) {
    return 'Za a ji kamar $temperature. Sha ruwa sosai.';
  }

  @override
  String get tipLaundryGood => 'Rana ce mai kyau don shanya wanki a waje.';

  @override
  String get tipLaundryBad => 'Ba rana ce mai kyau ba don shanya wanki a waje.';

  @override
  String tipBestOutdoorTime(String time) {
    return 'Lokaci mafi kyau don fita waje: kusan $time.';
  }

  @override
  String get tipAirQuality =>
      'Ingancin iska ba shi da kyau: rage dogon aiki ko motsa jiki mai ƙarfi a waje.';

  @override
  String get tipMosquitoes =>
      'Maraice mai ɗumi da danshi: sauro na iya yawa, yi amfani da maganin sauro ko gidan sauro.';

  @override
  String tipDriveFog(String time) {
    return 'Ka tuƙa a hankali: ana sa ran hazo a kusan $time.';
  }

  @override
  String tipDriveRain(String time) {
    return 'Ka tuƙa a hankali: ana sa ran ruwan sama mai ƙarfi a kusan $time.';
  }

  @override
  String get refresh => 'Sabunta';

  @override
  String get settingsDisplay => 'Nuni da bayanai';

  @override
  String get settingsAnimatedBackground => 'Bangon da ke motsi';

  @override
  String get settingsAnimatedBackgroundDetail =>
      'Sararin sama mai motsi a bayan hasashe. Yana tsayawa cak idan na\'urarka an saita ta don rage motsi.';

  @override
  String get settingsMinuteRain => 'Ruwan sama minti-minti';

  @override
  String get settingsMinuteRainDetail =>
      'Ruwan sama na awa 2 masu zuwa a matakan minti 15. Yana amfani da ɗan ƙarin bayanai.';

  @override
  String get settingsCrashReports => 'Aika rahoton faɗuwar manhaja';

  @override
  String get settingsCrashReportsDetail =>
      'Bayanan kuskure ba tare da suna ba da ke taimakawa gyara matsaloli. Babu wuri ko bayanan sirri.';

  @override
  String get nextTwoHours => 'Awa 2 masu zuwa';

  @override
  String rainStartingIn(int minutes) {
    return 'Ruwan sama zai fara cikin kusan minti $minutes';
  }

  @override
  String rainStoppingIn(int minutes) {
    return 'Ruwan sama zai tsaya cikin kusan minti $minutes';
  }

  @override
  String get rainContinuing => 'Ruwan sama aƙalla cikin awa 2 masu zuwa';

  @override
  String get noRainSoon => 'Ba a sa ran ruwan sama cikin awa 2 masu zuwa';

  @override
  String get tempAboutNormal => 'Kamar yadda aka saba a yau';

  @override
  String tempWarmerThanUsual(int degrees) {
    return 'Zafi ya fi yadda aka saba da $degrees°';
  }

  @override
  String tempCoolerThanUsual(int degrees) {
    return 'Sanyi ya fi yadda aka saba da $degrees°';
  }

  @override
  String tempNormalsSource(String fromYear, String toYear) {
    return 'Mafi zafin yau idan aka kwatanta da matsakaicin mafi zafi na wannan rana, $fromYear–$toYear.';
  }

  @override
  String get radar => 'Radar ruwan sama';

  @override
  String get radarUnavailable => 'Radar ba ya samuwa a yanzu.';

  @override
  String get radarNoCoverage =>
      'Radar yana nuna awa 2 da suka wuce. Wasu yankuna ba su da cikakken ɗaukar hoto.';

  @override
  String get play => 'Kunna';

  @override
  String get pause => 'Dakata';

  @override
  String get aboutRainViewer =>
      'Radar: bayanan yanayi daga RainViewer; taswira © masu bayar da gudummawa na OpenStreetMap.';

  @override
  String get privacyRadarTitle => 'Taswirar radar';

  @override
  String get privacyRadarBody =>
      'Buɗe radar yana sauke guntun taswira daga OpenStreetMap da hotunan radar daga RainViewer na yankin da kake kallo. Kamar kowane gidan yanar gizo, suna ganin adireshin IP ɗinka.';

  @override
  String get privacyCrashTitle => 'Rahoton faɗuwar manhaja';

  @override
  String get privacyCrashBody =>
      'Idan manhajar ta faɗi, ana iya aika rahoton kuskure ba tare da suna ba (samfurin na\'ura, sigar tsarin aiki, sigar manhaja da kuskuren) zuwa Sentry don mu gyara shi. Ba ya ƙunshe da wurinka, wuraren da ka adana ko adireshin IP ɗinka. Za ka iya kashe wannan a cikin Saituna.';

  @override
  String get aboutHistory =>
      'Matsakaicin yanayi: Open-Meteo historical weather API (ERA5).';

  @override
  String get zoomIn => 'Ƙara girma';

  @override
  String get zoomOut => 'Rage girma';

  @override
  String get settingsAppearance => 'Kamanni';

  @override
  String get settingsUnits => 'Ma\'auni';

  @override
  String get settingsPrivacy => 'Sirri';

  @override
  String cityRemoved(String city) {
    return 'An cire $city';
  }

  @override
  String get undo => 'Soke';

  @override
  String get sunAndMoon => 'Rana da wata';

  @override
  String get daylight => 'Hasken rana';

  @override
  String daylightDuration(int hours, int minutes) {
    return 'Awa $hours minti $minutes';
  }

  @override
  String get moonNew => 'Sabon wata';

  @override
  String get moonWaxingCrescent => 'Jinjirin wata mai ƙaruwa';

  @override
  String get moonFirstQuarter => 'Rubu\'in farko';

  @override
  String get moonWaxingGibbous => 'Wata mai ƙaruwa';

  @override
  String get moonFull => 'Cikakken wata';

  @override
  String get moonWaningGibbous => 'Wata mai raguwa';

  @override
  String get moonLastQuarter => 'Rubu\'in ƙarshe';

  @override
  String get moonWaningCrescent => 'Jinjirin wata mai raguwa';

  @override
  String moonIllumination(int percent) {
    return 'Haske $percent%';
  }

  @override
  String get navTrips => 'Tafiye-tafiye';

  @override
  String get tripsEmptyTitle => 'Babu tafiya tukuna';

  @override
  String get tripsEmptyBody =>
      'Shirya tafiya don ganin yanayi a kowane wurin sauka, rana-rana.';

  @override
  String get planTrip => 'Shirya tafiya';

  @override
  String get newTrip => 'Sabuwar tafiya';

  @override
  String get editTrip => 'Gyara tafiya';

  @override
  String get tripName => 'Sunan tafiya';

  @override
  String get tripNameHint => 'misali: Kirsimeti a Abuja';

  @override
  String tripDefaultName(String place) {
    return 'Tafiya zuwa $place';
  }

  @override
  String get tripStops => 'Wuraren sauka';

  @override
  String get addStop => 'Ƙara wurin sauka';

  @override
  String get removeStop => 'Cire wurin sauka';

  @override
  String get chooseDates => 'Zaɓi kwanaki';

  @override
  String get save => 'Adana';

  @override
  String get deleteTrip => 'Share tafiya';

  @override
  String get tripDeleted => 'An share tafiya';

  @override
  String get tripProblemNoStops => 'Ƙara aƙalla wurin sauka ɗaya.';

  @override
  String get tripProblemOrder =>
      'Kowane wurin sauka dole ya fara a ranar da na baya ya ƙare ko bayan haka.';

  @override
  String tripProblemTooLong(int days) {
    return 'Tafiya ba za ta wuce kwanaki $days ba.';
  }

  @override
  String tripStartsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Za a fara cikin kwanaki $count',
      one: 'Za a fara gobe',
      zero: 'Za a fara yau',
    );
    return '$_temp0';
  }

  @override
  String get tripOngoing => 'Ana ciki yanzu';

  @override
  String get tripEnded => 'Ta ƙare';

  @override
  String tripDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kwanaki $count',
      one: 'Kwana 1',
    );
    return '$_temp0';
  }

  @override
  String travelDay(String place) {
    return 'Ranar tafiya daga $place';
  }

  @override
  String get typicalWeather => 'Yadda aka saba a wannan rana';

  @override
  String typicalWeatherNote(int days) {
    return 'Ranakun da suka wuce kwanaki $days gaba suna nuna yanayin da aka saba na ranar (matsakaicin shekaru 20 da suka wuce). Hasashe zai maye gurbinsa kai tsaye yayin da tafiya ke matsowa.';
  }

  @override
  String get weatherUnknown => 'Babu bayanai tukuna';

  @override
  String get packingList => 'Jerin kaya';

  @override
  String get packingEmpty =>
      'Babu wani abu na musamman da za a ɗauka don wannan yanayi.';

  @override
  String get packUmbrella => 'Laima';

  @override
  String get packRainJacket => 'Rigar ruwan sama';

  @override
  String get packSunscreen => 'Man kariya daga rana';

  @override
  String get packSunglasses => 'Tabarau na rana';

  @override
  String get packHat => 'Hular rana';

  @override
  String get packLightClothes => 'Tufafi masu sauƙi';

  @override
  String get packWaterBottle => 'Kwalbar ruwa';

  @override
  String get packWarmLayer => 'Suwaita mai ɗumi';

  @override
  String get packCoat => 'Babbar riga ta sanyi';

  @override
  String get packGloves => 'Safar hannu';

  @override
  String get packWindbreaker => 'Rigar kariya daga iska';

  @override
  String get packInsectRepellent => 'Maganin sauro';

  @override
  String get shareTrip => 'Raba';

  @override
  String get tripReminder => 'Tunatar da ni ranar da ta gabata';

  @override
  String get tripReminderDetail =>
      'Sanarwa a maraicen ranar kafin tafiya, tare da hasashen wurin sauka na farko.';

  @override
  String tripReminderTitle(String place) {
    return 'Tafiyarka zuwa $place za ta fara gobe';
  }

  @override
  String get tripReminderBodyFallback => 'Duba hasashen yanayi kafin ka tafi.';

  @override
  String tripOutlookRange(String low, String high) {
    return '$low zuwa $high';
  }

  @override
  String tripRainyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ana iya ruwan sama kwanaki $count',
      one: 'Ana iya ruwan sama rana 1',
      zero: 'Ba a sa ran ruwan sama',
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
    return '$day · $place: $condition, $min zuwa $max, ruwan sama $rain%';
  }

  @override
  String shareTypicalDay(String day, String place, String min, String max) {
    return '$day · $place: yawanci $min zuwa $max';
  }

  @override
  String get sharedFromApp => 'An raba daga BWeather';

  @override
  String get privacyTripsTitle => 'Tafiye-tafiye';

  @override
  String get privacyTripsBody =>
      'Ana adana tafiye-tafiyen da ka shirya a wannan na\'urar kaɗai. Don samun yanayinsu, ana aika wurare da kwanakin kowane wurin sauka zuwa Open-Meteo.';
}

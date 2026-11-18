// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'BWeather';

  @override
  String get navForecast => 'Prévisions';

  @override
  String get navLocations => 'Lieux';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get addCity => 'Ajouter une ville';

  @override
  String get searchHint => 'Rechercher une ville';

  @override
  String get clearSearch => 'Effacer la recherche';

  @override
  String get close => 'Fermer';

  @override
  String get retry => 'Réessayer';

  @override
  String get keepTyping => 'Continuez à taper…';

  @override
  String get searchFailed =>
      'La recherche a échoué. Vérifiez votre connexion Internet et réessayez.';

  @override
  String noPlacesMatch(String query) {
    return 'Aucun lieu ne correspond à « $query ».';
  }

  @override
  String get welcomeTitle => 'Bienvenue sur BWeather';

  @override
  String get welcomeSubtitle =>
      'Les prévisions là où vous êtes et pour les lieux qui comptent pour vous.';

  @override
  String get useMyLocation => 'Utiliser ma position';

  @override
  String get findingYou => 'Recherche de votre position…';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String continueWith(String place) {
    return 'Continuer avec $place';
  }

  @override
  String get approximateFromNetwork => 'Approximative, d\'après votre réseau';

  @override
  String get searchForCity => 'Rechercher une ville';

  @override
  String get locationPrivacyNote =>
      'Votre position sert uniquement à obtenir les prévisions.';

  @override
  String get locationServiceDisabled =>
      'Les services de localisation sont désactivés.';

  @override
  String get locationPermissionDenied =>
      'L\'autorisation de localisation n\'a pas été accordée.';

  @override
  String get locationPermissionBlocked =>
      'L\'autorisation de localisation est bloquée. Vous pouvez l\'activer dans les Paramètres.';

  @override
  String get locationUnavailable =>
      'Impossible de trouver votre position pour le moment.';

  @override
  String get approximateBanner =>
      'Position approximative affichée, d\'après votre réseau.';

  @override
  String get usePrecise => 'Position précise';

  @override
  String get noPlacesTitle => 'Aucun lieu pour l\'instant';

  @override
  String get noPlacesBody =>
      'Utilisez votre position ou ajoutez une ville pour voir ses prévisions.';

  @override
  String get noSavedPlaces =>
      'Aucun lieu enregistré. Touchez + pour ajouter une ville.';

  @override
  String get yourLocation => 'Votre position';

  @override
  String get approximateLocation => 'Position approximative';

  @override
  String removeCity(String city) {
    return 'Retirer $city';
  }

  @override
  String get reorderHint =>
      'Appuyez longuement et faites glisser une ville pour la déplacer.';

  @override
  String forecastLoadFailed(String city) {
    return 'Impossible de charger les prévisions pour $city.';
  }

  @override
  String get forecastUnavailable => 'Prévisions indisponibles';

  @override
  String get forecastErrorNetwork =>
      'Impossible de joindre le service météo. Vérifiez votre connexion et réessayez.';

  @override
  String get forecastErrorData =>
      'Le service météo a renvoyé des données illisibles. Réessayez plus tard.';

  @override
  String get couldNotRefresh => 'Actualisation impossible';

  @override
  String updatedAgo(String age) {
    return 'Mis à jour $age';
  }

  @override
  String get ageJustNow => 'à l\'instant';

  @override
  String ageMinutes(int count) {
    return 'il y a $count min';
  }

  @override
  String ageHours(int count) {
    return 'il y a $count h';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String feelsLike(String temperature) {
    return 'Ressenti $temperature';
  }

  @override
  String get rainChance => 'Risque de pluie';

  @override
  String windWithDirection(String direction) {
    return 'Vent $direction';
  }

  @override
  String get humidity => 'Humidité';

  @override
  String get daily => 'Par jour';

  @override
  String get hourly => 'Par heure';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get now => 'Maintenant';

  @override
  String get windDirection => 'Direction du vent';

  @override
  String get windGusts => 'Rafales';

  @override
  String get rainToday => 'Pluie aujourd\'hui';

  @override
  String get pressure => 'Pression';

  @override
  String get cloudCover => 'Couverture nuageuse';

  @override
  String get dewPoint => 'Point de rosée';

  @override
  String get sunrise => 'Lever du soleil';

  @override
  String get sunset => 'Coucher du soleil';

  @override
  String semanticsCurrent(String temperature, String condition) {
    return '$temperature degrés, $condition';
  }

  @override
  String semanticsDay(String day, String condition, String min, String max) {
    return '$day : $condition, de $min à $max';
  }

  @override
  String semanticsRainChance(int percent) {
    return '$percent % de risque de pluie';
  }

  @override
  String get compassPoints =>
      'N,NNE,NE,ENE,E,ESE,SE,SSE,S,SSO,SO,OSO,O,ONO,NO,NNO';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get themeAuto => 'Automatique';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get languageSystem => 'Langue du système';

  @override
  String get settingsTemperature => 'Température';

  @override
  String get unitCelsius => 'Celsius (°C)';

  @override
  String get unitFahrenheit => 'Fahrenheit (°F)';

  @override
  String get settingsWindSpeed => 'Vitesse du vent';

  @override
  String get unitKmh => 'Kilomètres par heure (km/h)';

  @override
  String get unitMph => 'Miles par heure (mph)';

  @override
  String get unitMs => 'Mètres par seconde (m/s)';

  @override
  String get unitKnots => 'Nœuds (kn)';

  @override
  String get settingsPrecipitation => 'Précipitations';

  @override
  String get unitMm => 'Millimètres (mm)';

  @override
  String get unitInch => 'Pouces (in)';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get aboutApp => 'À propos de BWeather';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfUse => 'Conditions d\'utilisation';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'BWeather affiche la météo actuelle et les prévisions pour votre position et les lieux que vous enregistrez. Elle est développée et maintenue par Nobel pour Bsoft Limited.';

  @override
  String get aboutDataSources => 'Sources des données';

  @override
  String get aboutOpenMeteo =>
      'Météo et recherche de lieux : Open-Meteo (open-meteo.com), sous licence CC BY 4.0.';

  @override
  String get aboutOsm =>
      'Noms de lieux : © contributeurs OpenStreetMap (Nominatim), ODbL.';

  @override
  String get aboutIpapi => 'Position approximative : ipapi.co.';

  @override
  String get aboutIcons => 'Icônes météo : Meteocons de Bas Milius (MIT).';

  @override
  String get privacyIntro =>
      'BWeather n\'a ni compte, ni publicité, ni outil d\'analyse. Cette page explique quelles données quittent votre appareil et pourquoi.';

  @override
  String get privacyLocationTitle => 'Votre position';

  @override
  String get privacyLocationBody =>
      'Si vous l\'autorisez, l\'application lit la position de votre appareil. Les coordonnées sont envoyées à Open-Meteo pour obtenir les prévisions et à OpenStreetMap Nominatim pour obtenir le nom du lieu. Elles ne sont envoyées nulle part ailleurs.';

  @override
  String get privacyApproximateTitle => 'Position approximative';

  @override
  String get privacyApproximateBody =>
      'Lorsque la position précise n\'est pas disponible, l\'application demande à ipapi.co une position approximative au niveau de la ville. ipapi.co voit votre adresse IP pour répondre à cette demande.';

  @override
  String get privacySearchTitle => 'Recherche de villes';

  @override
  String get privacySearchBody =>
      'Le texte saisi dans la recherche de villes est envoyé au service de géocodage d\'Open-Meteo pour trouver les lieux correspondants.';

  @override
  String get privacyStorageTitle => 'Données stockées sur votre appareil';

  @override
  String get privacyStorageBody =>
      'Vos villes enregistrées, les dernières prévisions et vos paramètres sont stockés uniquement sur cet appareil. Désinstaller l\'application les supprime.';

  @override
  String get privacyContactTitle => 'Contact';

  @override
  String get privacyContactBody =>
      'Des questions sur la confidentialité ? Contactez Bsoft Limited via la fiche de l\'application dans la boutique.';

  @override
  String get termsIntro =>
      'En utilisant BWeather, vous acceptez ces conditions.';

  @override
  String get termsAccuracyTitle => 'Précision des prévisions';

  @override
  String get termsAccuracyBody =>
      'Les prévisions sont des estimations et peuvent être erronées. Ne vous fiez pas à BWeather pour des décisions où la sécurité est en jeu ; suivez les alertes officielles de votre service météorologique national.';

  @override
  String get termsServiceTitle => 'Le service';

  @override
  String get termsServiceBody =>
      'BWeather est fourni « tel quel », sans garantie. Les fonctionnalités peuvent évoluer et le service peut être parfois indisponible.';

  @override
  String get termsThirdPartyTitle => 'Données de tiers';

  @override
  String get termsThirdPartyBody =>
      'Les données météo proviennent d\'Open-Meteo et les noms de lieux d\'OpenStreetMap. Leurs propres conditions et licences s\'appliquent à ces données.';

  @override
  String legalLastUpdated(String date) {
    return 'Dernière mise à jour : $date';
  }

  @override
  String get wmo0 => 'Ciel dégagé';

  @override
  String get wmo1 => 'Plutôt dégagé';

  @override
  String get wmo2 => 'Partiellement nuageux';

  @override
  String get wmo3 => 'Couvert';

  @override
  String get wmo45 => 'Brouillard';

  @override
  String get wmo48 => 'Brouillard givrant';

  @override
  String get wmo51 => 'Bruine légère';

  @override
  String get wmo53 => 'Bruine modérée';

  @override
  String get wmo55 => 'Bruine dense';

  @override
  String get wmo56 => 'Bruine verglaçante légère';

  @override
  String get wmo57 => 'Bruine verglaçante dense';

  @override
  String get wmo61 => 'Pluie faible';

  @override
  String get wmo63 => 'Pluie modérée';

  @override
  String get wmo65 => 'Forte pluie';

  @override
  String get wmo66 => 'Pluie verglaçante faible';

  @override
  String get wmo67 => 'Forte pluie verglaçante';

  @override
  String get wmo71 => 'Faibles chutes de neige';

  @override
  String get wmo73 => 'Chutes de neige modérées';

  @override
  String get wmo75 => 'Fortes chutes de neige';

  @override
  String get wmo77 => 'Neige en grains';

  @override
  String get wmo80 => 'Averses de pluie faibles';

  @override
  String get wmo81 => 'Averses de pluie modérées';

  @override
  String get wmo82 => 'Averses de pluie violentes';

  @override
  String get wmo85 => 'Averses de neige faibles';

  @override
  String get wmo86 => 'Fortes averses de neige';

  @override
  String get wmo95 => 'Orage';

  @override
  String get wmo96 => 'Orage avec grêle faible';

  @override
  String get wmo99 => 'Orage avec forte grêle';

  @override
  String get wmoUnknown => 'Conditions inconnues';

  @override
  String get pageNotFound => 'Page introuvable';

  @override
  String get airQuality => 'Qualité de l\'air';

  @override
  String airQualityIndex(int value) {
    return 'IQA (US) $value';
  }

  @override
  String get aqiGood => 'Bonne';

  @override
  String get aqiModerate => 'Moyenne';

  @override
  String get aqiSensitive => 'Mauvaise pour les personnes sensibles';

  @override
  String get aqiUnhealthy => 'Mauvaise';

  @override
  String get aqiVeryUnhealthy => 'Très mauvaise';

  @override
  String get aqiHazardous => 'Dangereuse';

  @override
  String get pm25 => 'PM2,5';

  @override
  String get pm10 => 'PM10';

  @override
  String get dust => 'Poussière';

  @override
  String get uvIndex => 'Indice UV';

  @override
  String get uvLow => 'Faible';

  @override
  String get uvModerate => 'Modéré';

  @override
  String get uvHigh => 'Élevé';

  @override
  String get uvVeryHigh => 'Très élevé';

  @override
  String get uvExtreme => 'Extrême';

  @override
  String get pollen => 'Pollen';

  @override
  String get pollenAlder => 'Aulne';

  @override
  String get pollenBirch => 'Bouleau';

  @override
  String get pollenGrass => 'Graminées';

  @override
  String get pollenMugwort => 'Armoise';

  @override
  String get pollenOlive => 'Olivier';

  @override
  String get pollenRagweed => 'Ambroisie';

  @override
  String get harmattanDustHint =>
      'Beaucoup de poussière : pensez à un masque à l\'extérieur.';

  @override
  String get chart => 'Graphique';

  @override
  String get chartLegendTemperature => 'Température';

  @override
  String get chartLegendRain => 'Risque de pluie';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get notifyMorningBrief => 'Résumé du matin';

  @override
  String get notifyMorningBriefDetail =>
      'Les prévisions du jour pour votre position chaque matin.';

  @override
  String get notifyBriefTime => 'Heure';

  @override
  String get notifyRain => 'Alertes pluie';

  @override
  String get notifyRainDetail =>
      'Quand de la pluie est probable dans les 2 prochaines heures.';

  @override
  String get notifySevere => 'Météo dangereuse';

  @override
  String get notifySevereDetail =>
      'Orages, vents très forts ou chaleur extrême.';

  @override
  String get notifyPermissionDenied =>
      'Les notifications de BWeather sont désactivées dans les paramètres de l\'appareil.';

  @override
  String get notifyUnsupported =>
      'Les notifications sont disponibles dans l\'application Android.';

  @override
  String get notifyBackgroundNote =>
      'Les alertes sont vérifiées environ une fois par heure et peuvent donc arriver avec un peu de retard.';

  @override
  String get notifyChannelForecast => 'Prévisions';

  @override
  String get notifyChannelAlerts => 'Alertes météo';

  @override
  String briefTitle(String place) {
    return 'Aujourd\'hui à $place';
  }

  @override
  String briefBody(String condition, String min, String max, int rain) {
    return '$condition, de $min à $max. Risque de pluie $rain %.';
  }

  @override
  String rainAlertTitle(String place) {
    return 'Pluie prévue à $place';
  }

  @override
  String rainAlertBody(int percent, String time) {
    return '$percent % de risque de pluie vers $time.';
  }

  @override
  String severeThunderTitle(String place) {
    return 'Orages près de $place';
  }

  @override
  String severeThunderBody(String time) {
    return 'Des orages sont prévus vers $time. Restez à l\'intérieur si possible.';
  }

  @override
  String severeWindTitle(String place) {
    return 'Vents forts à $place';
  }

  @override
  String severeWindBody(String speed) {
    return 'Rafales jusqu\'à $speed prévues aujourd\'hui.';
  }

  @override
  String severeHeatTitle(String place) {
    return 'Chaleur extrême à $place';
  }

  @override
  String severeHeatBody(String temperature) {
    return 'Le ressenti atteindra $temperature aujourd\'hui. Buvez de l\'eau et évitez le soleil de midi.';
  }

  @override
  String get aboutCams =>
      'Qualité de l\'air : générée à partir d\'informations du service Copernicus de surveillance de l\'atmosphère (via Open-Meteo).';

  @override
  String widgetRange(String max, String min) {
    return 'Max $max · Min $min';
  }

  @override
  String widgetUpdated(String time) {
    return 'Mis à jour à $time';
  }

  @override
  String get tipsTitle => 'Conseils du jour';

  @override
  String tipUmbrella(int percent, String time) {
    return 'Prenez un parapluie : $percent % de risque de pluie, surtout vers $time.';
  }

  @override
  String get tipClothesHot => 'Portez des vêtements légers et respirants.';

  @override
  String get tipClothesWarm => 'Un t-shirt suffira.';

  @override
  String get tipClothesMild => 'Prenez une veste légère.';

  @override
  String get tipClothesCool => 'Portez une veste chaude.';

  @override
  String get tipClothesCold => 'Couvrez-vous bien : il fait froid.';

  @override
  String tipSunscreen(String level) {
    return 'UV $level aujourd\'hui : crème solaire et chapeau entre 10 h et 16 h.';
  }

  @override
  String tipHydrate(String temperature) {
    return 'Le ressenti atteindra $temperature. Buvez beaucoup d\'eau.';
  }

  @override
  String get tipLaundryGood =>
      'Bonne journée pour faire sécher le linge dehors.';

  @override
  String get tipLaundryBad => 'Pas idéal pour faire sécher le linge dehors.';

  @override
  String tipBestOutdoorTime(String time) {
    return 'Meilleur moment pour sortir : vers $time.';
  }

  @override
  String get tipAirQuality =>
      'Qualité de l\'air médiocre : limitez les efforts longs ou intenses à l\'extérieur.';

  @override
  String get tipMosquitoes =>
      'Soirée chaude et humide : moustiques probables, utilisez un répulsif ou une moustiquaire.';

  @override
  String tipDriveFog(String time) {
    return 'Prudence au volant : brouillard prévu vers $time.';
  }

  @override
  String tipDriveRain(String time) {
    return 'Prudence au volant : fortes pluies prévues vers $time.';
  }

  @override
  String get refresh => 'Actualiser';

  @override
  String get settingsDisplay => 'Affichage et données';

  @override
  String get settingsAnimatedBackground => 'Arrière-plans animés';

  @override
  String get settingsAnimatedBackgroundDetail =>
      'Un ciel animé derrière les prévisions. Reste immobile si votre appareil limite les animations.';

  @override
  String get settingsMinuteRain => 'Pluie minute par minute';

  @override
  String get settingsMinuteRainDetail =>
      'La pluie des 2 prochaines heures par tranches de 15 minutes. Consomme un peu plus de données.';

  @override
  String get settingsCrashReports => 'Envoyer les rapports de plantage';

  @override
  String get settingsCrashReportsDetail =>
      'Des détails d\'erreur anonymes qui aident à corriger les bugs. Aucune position ni donnée personnelle.';

  @override
  String get nextTwoHours => '2 prochaines heures';

  @override
  String rainStartingIn(int minutes) {
    return 'Pluie dans environ $minutes min';
  }

  @override
  String rainStoppingIn(int minutes) {
    return 'Fin de la pluie dans environ $minutes min';
  }

  @override
  String get rainContinuing => 'Pluie pendant au moins les 2 prochaines heures';

  @override
  String get noRainSoon => 'Pas de pluie prévue dans les 2 prochaines heures';

  @override
  String get tempAboutNormal => 'Normal pour la saison';

  @override
  String tempWarmerThanUsual(int degrees) {
    return '$degrees° de plus que la normale';
  }

  @override
  String tempCoolerThanUsual(int degrees) {
    return '$degrees° de moins que la normale';
  }

  @override
  String tempNormalsSource(String fromYear, String toYear) {
    return 'Maximale du jour comparée à la maximale moyenne à cette date, $fromYear–$toYear.';
  }

  @override
  String get radar => 'Radar de pluie';

  @override
  String get radarUnavailable =>
      'Le radar n\'est pas disponible pour le moment.';

  @override
  String get radarNoCoverage =>
      'Le radar couvre les 2 dernières heures. Certaines régions sont peu ou pas couvertes.';

  @override
  String get play => 'Lecture';

  @override
  String get pause => 'Pause';

  @override
  String get aboutRainViewer =>
      'Radar : données météo de RainViewer ; carte © les contributeurs d\'OpenStreetMap.';

  @override
  String get privacyRadarTitle => 'Carte radar';

  @override
  String get privacyRadarBody =>
      'L\'ouverture du radar télécharge des tuiles de carte depuis OpenStreetMap et des images radar depuis RainViewer pour la zone affichée. Comme tout site web, ils voient votre adresse IP.';

  @override
  String get privacyCrashTitle => 'Rapports de plantage';

  @override
  String get privacyCrashBody =>
      'Si l\'application plante, un rapport d\'erreur anonyme (modèle de l\'appareil, version du système, version de l\'application et l\'erreur) peut être envoyé à Sentry pour que nous puissions corriger le problème. Il ne contient jamais votre position, vos lieux enregistrés ni votre adresse IP. Vous pouvez le désactiver dans les Paramètres.';

  @override
  String get aboutHistory =>
      'Moyennes climatiques : API météo historique d\'Open-Meteo (ERA5).';

  @override
  String get zoomIn => 'Zoom avant';

  @override
  String get zoomOut => 'Zoom arrière';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsUnits => 'Unités';

  @override
  String get settingsPrivacy => 'Confidentialité';

  @override
  String cityRemoved(String city) {
    return 'Lieu supprimé : $city';
  }

  @override
  String get undo => 'Annuler';

  @override
  String get sunAndMoon => 'Soleil et lune';

  @override
  String get daylight => 'Durée du jour';

  @override
  String daylightDuration(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get moonNew => 'Nouvelle lune';

  @override
  String get moonWaxingCrescent => 'Premier croissant';

  @override
  String get moonFirstQuarter => 'Premier quartier';

  @override
  String get moonWaxingGibbous => 'Gibbeuse croissante';

  @override
  String get moonFull => 'Pleine lune';

  @override
  String get moonWaningGibbous => 'Gibbeuse décroissante';

  @override
  String get moonLastQuarter => 'Dernier quartier';

  @override
  String get moonWaningCrescent => 'Dernier croissant';

  @override
  String moonIllumination(int percent) {
    return 'Éclairée à $percent %';
  }

  @override
  String get navTrips => 'Voyages';

  @override
  String get tripsEmptyTitle => 'Aucun voyage pour l\'instant';

  @override
  String get tripsEmptyBody =>
      'Planifiez un voyage pour voir la météo à chaque étape, jour par jour.';

  @override
  String get planTrip => 'Planifier un voyage';

  @override
  String get newTrip => 'Nouveau voyage';

  @override
  String get editTrip => 'Modifier le voyage';

  @override
  String get tripName => 'Nom du voyage';

  @override
  String get tripNameHint => 'p. ex. Noël à Abuja';

  @override
  String tripDefaultName(String place) {
    return 'Voyage à $place';
  }

  @override
  String get tripStops => 'Étapes';

  @override
  String get addStop => 'Ajouter une étape';

  @override
  String get removeStop => 'Retirer l\'étape';

  @override
  String get chooseDates => 'Choisir les dates';

  @override
  String get save => 'Enregistrer';

  @override
  String get deleteTrip => 'Supprimer le voyage';

  @override
  String get tripDeleted => 'Voyage supprimé';

  @override
  String get tripProblemNoStops => 'Ajoutez au moins une étape.';

  @override
  String get tripProblemOrder =>
      'Chaque étape doit commencer le jour où la précédente se termine ou après.';

  @override
  String tripProblemTooLong(int days) {
    return 'Un voyage peut durer au plus $days jours.';
  }

  @override
  String tripStartsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Commence dans $count jours',
      one: 'Commence demain',
      zero: 'Commence aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String get tripOngoing => 'En cours';

  @override
  String get tripEnded => 'Terminé';

  @override
  String tripDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String travelDay(String place) {
    return 'Jour de trajet depuis $place';
  }

  @override
  String get typicalWeather => 'Habituel pour la date';

  @override
  String typicalWeatherNote(int days) {
    return 'Les jours à plus de $days jours affichent la météo habituelle pour la date (moyenne des 20 dernières années). Les prévisions la remplacent automatiquement à l\'approche du voyage.';
  }

  @override
  String get weatherUnknown => 'Pas encore de données';

  @override
  String get packingList => 'Liste de bagages';

  @override
  String get packingEmpty => 'Rien de particulier à emporter pour cette météo.';

  @override
  String get packUmbrella => 'Parapluie';

  @override
  String get packRainJacket => 'Veste de pluie';

  @override
  String get packSunscreen => 'Crème solaire';

  @override
  String get packSunglasses => 'Lunettes de soleil';

  @override
  String get packHat => 'Chapeau de soleil';

  @override
  String get packLightClothes => 'Vêtements légers et respirants';

  @override
  String get packWaterBottle => 'Gourde réutilisable';

  @override
  String get packWarmLayer => 'Pull chaud ou polaire';

  @override
  String get packCoat => 'Manteau d\'hiver';

  @override
  String get packGloves => 'Gants';

  @override
  String get packWindbreaker => 'Coupe-vent';

  @override
  String get packInsectRepellent => 'Anti-moustiques';

  @override
  String get shareTrip => 'Partager';

  @override
  String get tripReminder => 'Me le rappeler la veille';

  @override
  String get tripReminderDetail =>
      'Une notification la veille du départ, avec les prévisions pour votre première étape.';

  @override
  String tripReminderTitle(String place) {
    return 'Votre voyage à $place commence demain';
  }

  @override
  String get tripReminderBodyFallback =>
      'Consultez les prévisions avant de partir.';

  @override
  String tripOutlookRange(String low, String high) {
    return '$low à $high';
  }

  @override
  String tripRainyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pluie probable $count jours',
      one: 'Pluie probable 1 jour',
      zero: 'Pas de pluie prévue',
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
    return '$day · $place : $condition, $min à $max, pluie $rain %';
  }

  @override
  String shareTypicalDay(String day, String place, String min, String max) {
    return '$day · $place : habituellement $min à $max';
  }

  @override
  String get sharedFromApp => 'Partagé depuis BWeather';

  @override
  String get privacyTripsTitle => 'Voyages';

  @override
  String get privacyTripsBody =>
      'Les voyages que vous planifiez sont stockés uniquement sur cet appareil. Pour obtenir leur météo, les coordonnées et les dates de chaque étape sont envoyées à Open-Meteo.';
}

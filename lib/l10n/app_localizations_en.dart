// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BWeather';

  @override
  String get navForecast => 'Forecast';

  @override
  String get navLocations => 'Locations';

  @override
  String get navSettings => 'Settings';

  @override
  String get addCity => 'Add a city';

  @override
  String get searchHint => 'Search cities';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get keepTyping => 'Keep typing…';

  @override
  String get searchFailed =>
      'Search failed. Check your internet connection and try again.';

  @override
  String noPlacesMatch(String query) {
    return 'No places match \"$query\".';
  }

  @override
  String get welcomeTitle => 'Welcome to BWeather';

  @override
  String get welcomeSubtitle =>
      'Forecasts for where you are and the places you care about.';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get findingYou => 'Finding you…';

  @override
  String get openSettings => 'Open settings';

  @override
  String continueWith(String place) {
    return 'Continue with $place';
  }

  @override
  String get approximateFromNetwork => 'Approximate, based on your network';

  @override
  String get searchForCity => 'Search for a city';

  @override
  String get locationPrivacyNote =>
      'Your location is only used to fetch the forecast.';

  @override
  String get locationServiceDisabled => 'Location services are turned off.';

  @override
  String get locationPermissionDenied => 'Location permission wasn\'t granted.';

  @override
  String get locationPermissionBlocked =>
      'Location permission is blocked. You can allow it in Settings.';

  @override
  String get locationUnavailable =>
      'We couldn\'t find your location right now.';

  @override
  String get approximateBanner =>
      'Showing an approximate location based on your network.';

  @override
  String get usePrecise => 'Use precise';

  @override
  String get noPlacesTitle => 'No places yet';

  @override
  String get noPlacesBody =>
      'Use your location or add a city to see its forecast.';

  @override
  String get noSavedPlaces => 'No saved places yet. Tap + to add a city.';

  @override
  String get yourLocation => 'Your location';

  @override
  String get approximateLocation => 'Approximate location';

  @override
  String removeCity(String city) {
    return 'Remove $city';
  }

  @override
  String get reorderHint => 'Long-press and drag a city to reorder.';

  @override
  String forecastLoadFailed(String city) {
    return 'Couldn\'t load the forecast for $city.';
  }

  @override
  String get forecastUnavailable => 'Couldn\'t load forecast';

  @override
  String get forecastErrorNetwork =>
      'Couldn\'t reach the weather service. Check your connection and try again.';

  @override
  String get forecastErrorData =>
      'The weather service sent data we couldn\'t read. Please try again later.';

  @override
  String get couldNotRefresh => 'Couldn\'t refresh';

  @override
  String updatedAgo(String age) {
    return 'Updated $age';
  }

  @override
  String get ageJustNow => 'just now';

  @override
  String ageMinutes(int count) {
    return '$count min ago';
  }

  @override
  String ageHours(int count) {
    return '$count h ago';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String feelsLike(String temperature) {
    return 'Feels like $temperature';
  }

  @override
  String get rainChance => 'Rain chance';

  @override
  String windWithDirection(String direction) {
    return 'Wind $direction';
  }

  @override
  String get humidity => 'Humidity';

  @override
  String get daily => 'Daily';

  @override
  String get hourly => 'Hourly';

  @override
  String get today => 'Today';

  @override
  String get now => 'Now';

  @override
  String get windDirection => 'Wind direction';

  @override
  String get windGusts => 'Wind gusts';

  @override
  String get rainToday => 'Rain today';

  @override
  String get pressure => 'Pressure';

  @override
  String get cloudCover => 'Cloud cover';

  @override
  String get dewPoint => 'Dew point';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String semanticsCurrent(String temperature, String condition) {
    return '$temperature degrees, $condition';
  }

  @override
  String semanticsDay(String day, String condition, String min, String max) {
    return '$day: $condition, $min to $max';
  }

  @override
  String semanticsRainChance(int percent) {
    return '$percent% chance of rain';
  }

  @override
  String get compassPoints =>
      'N,NNE,NE,ENE,E,ESE,SE,SSE,S,SSW,SW,WSW,W,WNW,NW,NNW';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get settingsTemperature => 'Temperature';

  @override
  String get unitCelsius => 'Celsius (°C)';

  @override
  String get unitFahrenheit => 'Fahrenheit (°F)';

  @override
  String get settingsWindSpeed => 'Wind speed';

  @override
  String get unitKmh => 'Kilometres per hour (km/h)';

  @override
  String get unitMph => 'Miles per hour (mph)';

  @override
  String get unitMs => 'Metres per second (m/s)';

  @override
  String get unitKnots => 'Knots (kn)';

  @override
  String get settingsPrecipitation => 'Precipitation';

  @override
  String get unitMm => 'Millimetres (mm)';

  @override
  String get unitInch => 'Inches (in)';

  @override
  String get settingsAbout => 'About';

  @override
  String get aboutApp => 'About BWeather';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'BWeather shows the current weather and forecasts for your location and the places you save. It is developed and maintained by Nobel for Bsoft Limited.';

  @override
  String get aboutDataSources => 'Data sources';

  @override
  String get aboutOpenMeteo =>
      'Weather and place search: Open-Meteo (open-meteo.com), licensed under CC BY 4.0.';

  @override
  String get aboutOsm =>
      'Place names: © OpenStreetMap contributors (Nominatim), ODbL.';

  @override
  String get aboutIpapi => 'Approximate location: ipapi.co.';

  @override
  String get aboutIcons => 'Weather icons: Meteocons by Bas Milius (MIT).';

  @override
  String get privacyIntro =>
      'BWeather has no accounts, no ads and no analytics. This page explains which data leaves your device and why.';

  @override
  String get privacyLocationTitle => 'Your location';

  @override
  String get privacyLocationBody =>
      'If you allow it, the app reads your device\'s location. The coordinates are sent to Open-Meteo to get the forecast and to OpenStreetMap Nominatim to get the name of the place. They are not sent anywhere else.';

  @override
  String get privacyApproximateTitle => 'Approximate location';

  @override
  String get privacyApproximateBody =>
      'When precise location isn\'t available, the app asks ipapi.co for an approximate, city-level location. ipapi.co sees your IP address to answer this request.';

  @override
  String get privacySearchTitle => 'City search';

  @override
  String get privacySearchBody =>
      'The text you type in the city search is sent to Open-Meteo\'s geocoding service to find matching places.';

  @override
  String get privacyStorageTitle => 'Data stored on your device';

  @override
  String get privacyStorageBody =>
      'Your saved cities, the latest forecasts and your settings are stored only on this device. Uninstalling the app deletes them.';

  @override
  String get privacyContactTitle => 'Contact';

  @override
  String get privacyContactBody =>
      'Questions about privacy? Contact Bsoft Limited through the app\'s store listing.';

  @override
  String get termsIntro => 'By using BWeather you agree to these terms.';

  @override
  String get termsAccuracyTitle => 'Forecast accuracy';

  @override
  String get termsAccuracyBody =>
      'Forecasts are estimates and can be wrong. Don\'t rely on BWeather for decisions where safety is at stake; follow official warnings from your national weather service.';

  @override
  String get termsServiceTitle => 'The service';

  @override
  String get termsServiceBody =>
      'BWeather is provided \"as is\", without warranties. Features may change, and the service may be unavailable at times.';

  @override
  String get termsThirdPartyTitle => 'Third-party data';

  @override
  String get termsThirdPartyBody =>
      'Weather data comes from Open-Meteo and place names from OpenStreetMap. Their own terms and licences apply to that data.';

  @override
  String legalLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get wmo0 => 'Clear sky';

  @override
  String get wmo1 => 'Mainly clear';

  @override
  String get wmo2 => 'Partly cloudy';

  @override
  String get wmo3 => 'Overcast';

  @override
  String get wmo45 => 'Fog';

  @override
  String get wmo48 => 'Rime fog';

  @override
  String get wmo51 => 'Light drizzle';

  @override
  String get wmo53 => 'Moderate drizzle';

  @override
  String get wmo55 => 'Dense drizzle';

  @override
  String get wmo56 => 'Light freezing drizzle';

  @override
  String get wmo57 => 'Dense freezing drizzle';

  @override
  String get wmo61 => 'Light rain';

  @override
  String get wmo63 => 'Moderate rain';

  @override
  String get wmo65 => 'Heavy rain';

  @override
  String get wmo66 => 'Light freezing rain';

  @override
  String get wmo67 => 'Heavy freezing rain';

  @override
  String get wmo71 => 'Light snowfall';

  @override
  String get wmo73 => 'Moderate snowfall';

  @override
  String get wmo75 => 'Heavy snowfall';

  @override
  String get wmo77 => 'Snow grains';

  @override
  String get wmo80 => 'Light rain showers';

  @override
  String get wmo81 => 'Moderate rain showers';

  @override
  String get wmo82 => 'Violent rain showers';

  @override
  String get wmo85 => 'Light snow showers';

  @override
  String get wmo86 => 'Heavy snow showers';

  @override
  String get wmo95 => 'Thunderstorm';

  @override
  String get wmo96 => 'Thunderstorm with light hail';

  @override
  String get wmo99 => 'Thunderstorm with heavy hail';

  @override
  String get wmoUnknown => 'Unknown conditions';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get airQuality => 'Air quality';

  @override
  String airQualityIndex(int value) {
    return 'US AQI $value';
  }

  @override
  String get aqiGood => 'Good';

  @override
  String get aqiModerate => 'Moderate';

  @override
  String get aqiSensitive => 'Unhealthy for sensitive groups';

  @override
  String get aqiUnhealthy => 'Unhealthy';

  @override
  String get aqiVeryUnhealthy => 'Very unhealthy';

  @override
  String get aqiHazardous => 'Hazardous';

  @override
  String get pm25 => 'PM2.5';

  @override
  String get pm10 => 'PM10';

  @override
  String get dust => 'Dust';

  @override
  String get uvIndex => 'UV index';

  @override
  String get uvLow => 'Low';

  @override
  String get uvModerate => 'Moderate';

  @override
  String get uvHigh => 'High';

  @override
  String get uvVeryHigh => 'Very high';

  @override
  String get uvExtreme => 'Extreme';

  @override
  String get pollen => 'Pollen';

  @override
  String get pollenAlder => 'Alder';

  @override
  String get pollenBirch => 'Birch';

  @override
  String get pollenGrass => 'Grass';

  @override
  String get pollenMugwort => 'Mugwort';

  @override
  String get pollenOlive => 'Olive';

  @override
  String get pollenRagweed => 'Ragweed';

  @override
  String get harmattanDustHint => 'High dust levels: consider a mask outdoors.';

  @override
  String get chart => 'Chart';

  @override
  String get chartLegendTemperature => 'Temperature';

  @override
  String get chartLegendRain => 'Rain chance';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get notifyMorningBrief => 'Morning briefing';

  @override
  String get notifyMorningBriefDetail =>
      'Today\'s forecast for your location each morning.';

  @override
  String get notifyBriefTime => 'Time';

  @override
  String get notifyRain => 'Rain alerts';

  @override
  String get notifyRainDetail => 'When rain is likely within the next 2 hours.';

  @override
  String get notifySevere => 'Severe weather';

  @override
  String get notifySevereDetail =>
      'Thunderstorms, very strong winds or extreme heat.';

  @override
  String get notifyPermissionDenied =>
      'Notifications are turned off for BWeather in your device settings.';

  @override
  String get notifyUnsupported =>
      'Notifications are available in the Android app.';

  @override
  String get notifyBackgroundNote =>
      'Alerts are checked about once an hour, so they can arrive a little late.';

  @override
  String get notifyChannelForecast => 'Forecasts';

  @override
  String get notifyChannelAlerts => 'Weather alerts';

  @override
  String briefTitle(String place) {
    return 'Today in $place';
  }

  @override
  String briefBody(String condition, String min, String max, int rain) {
    return '$condition, $min to $max. Rain chance $rain%.';
  }

  @override
  String rainAlertTitle(String place) {
    return 'Rain expected in $place';
  }

  @override
  String rainAlertBody(int percent, String time) {
    return '$percent% chance of rain around $time.';
  }

  @override
  String severeThunderTitle(String place) {
    return 'Thunderstorms near $place';
  }

  @override
  String severeThunderBody(String time) {
    return 'Thunderstorms are expected around $time. Stay indoors if you can.';
  }

  @override
  String severeWindTitle(String place) {
    return 'Strong winds in $place';
  }

  @override
  String severeWindBody(String speed) {
    return 'Gusts up to $speed expected today.';
  }

  @override
  String severeHeatTitle(String place) {
    return 'Extreme heat in $place';
  }

  @override
  String severeHeatBody(String temperature) {
    return 'It will feel like $temperature today. Drink water and avoid the midday sun.';
  }

  @override
  String get aboutCams =>
      'Air quality: generated using Copernicus Atmosphere Monitoring Service information (via Open-Meteo).';

  @override
  String widgetRange(String max, String min) {
    return 'H $max · L $min';
  }

  @override
  String widgetUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get tipsTitle => 'Today\'s tips';

  @override
  String tipUmbrella(int percent, String time) {
    return 'Take an umbrella: $percent% chance of rain, most likely around $time.';
  }

  @override
  String get tipClothesHot => 'Wear light, breathable clothes.';

  @override
  String get tipClothesWarm => 'T-shirt weather.';

  @override
  String get tipClothesMild => 'Bring a light jacket.';

  @override
  String get tipClothesCool => 'Wear a warm jacket.';

  @override
  String get tipClothesCold => 'Bundle up: it\'s cold out.';

  @override
  String tipSunscreen(String level) {
    return 'UV is $level today: use sunscreen and a hat between 10:00 and 16:00.';
  }

  @override
  String tipHydrate(String temperature) {
    return 'It will feel like $temperature. Drink plenty of water.';
  }

  @override
  String get tipLaundryGood => 'Good day to dry laundry outside.';

  @override
  String get tipLaundryBad => 'Not a good day to dry laundry outside.';

  @override
  String tipBestOutdoorTime(String time) {
    return 'Best time to be outdoors: around $time.';
  }

  @override
  String get tipAirQuality =>
      'Air quality is poor: limit long or intense activity outdoors.';

  @override
  String get tipMosquitoes =>
      'Warm, humid evening: mosquitoes are likely, so use repellent or a net.';

  @override
  String tipDriveFog(String time) {
    return 'Drive carefully: fog expected around $time.';
  }

  @override
  String tipDriveRain(String time) {
    return 'Drive carefully: heavy rain expected around $time.';
  }

  @override
  String get refresh => 'Refresh';

  @override
  String get settingsDisplay => 'Display & data';

  @override
  String get settingsAnimatedBackground => 'Animated backgrounds';

  @override
  String get settingsAnimatedBackgroundDetail =>
      'A moving sky behind the forecast. Stays still when your device is set to reduce motion.';

  @override
  String get settingsMinuteRain => 'Minute-by-minute rain';

  @override
  String get settingsMinuteRainDetail =>
      'Rain for the next 2 hours in 15-minute steps. Uses slightly more data.';

  @override
  String get settingsCrashReports => 'Send crash reports';

  @override
  String get settingsCrashReportsDetail =>
      'Anonymous error details that help fix bugs. No location or personal data.';

  @override
  String get nextTwoHours => 'Next 2 hours';

  @override
  String rainStartingIn(int minutes) {
    return 'Rain starting in about $minutes min';
  }

  @override
  String rainStoppingIn(int minutes) {
    return 'Rain stopping in about $minutes min';
  }

  @override
  String get rainContinuing => 'Rain for at least the next 2 hours';

  @override
  String get noRainSoon => 'No rain expected in the next 2 hours';

  @override
  String get tempAboutNormal => 'About normal for today';

  @override
  String tempWarmerThanUsual(int degrees) {
    return '$degrees° warmer than usual';
  }

  @override
  String tempCoolerThanUsual(int degrees) {
    return '$degrees° cooler than usual';
  }

  @override
  String tempNormalsSource(String fromYear, String toYear) {
    return 'Today\'s high compared with the average high for this date, $fromYear–$toYear.';
  }

  @override
  String get radar => 'Rain radar';

  @override
  String get radarUnavailable => 'The radar isn\'t available right now.';

  @override
  String get radarNoCoverage =>
      'Radar covers the past 2 hours. Some regions have little or no coverage.';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get aboutRainViewer =>
      'Radar: weather data by RainViewer; map © OpenStreetMap contributors.';

  @override
  String get privacyRadarTitle => 'Radar map';

  @override
  String get privacyRadarBody =>
      'Opening the radar downloads map tiles from OpenStreetMap and radar images from RainViewer for the area you view. Like any website, they see your IP address.';

  @override
  String get privacyCrashTitle => 'Crash reports';

  @override
  String get privacyCrashBody =>
      'If the app crashes, an anonymous error report (device model, OS version, app version and the error) may be sent to Sentry so we can fix it. It never includes your location, saved places or IP address. You can turn this off in Settings.';

  @override
  String get aboutHistory =>
      'Climate averages: Open-Meteo historical weather API (ERA5).';

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get zoomOut => 'Zoom out';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsUnits => 'Units';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String cityRemoved(String city) {
    return '$city removed';
  }

  @override
  String get undo => 'Undo';

  @override
  String get sunAndMoon => 'Sun & moon';

  @override
  String get daylight => 'Daylight';

  @override
  String daylightDuration(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get moonNew => 'New moon';

  @override
  String get moonWaxingCrescent => 'Waxing crescent';

  @override
  String get moonFirstQuarter => 'First quarter';

  @override
  String get moonWaxingGibbous => 'Waxing gibbous';

  @override
  String get moonFull => 'Full moon';

  @override
  String get moonWaningGibbous => 'Waning gibbous';

  @override
  String get moonLastQuarter => 'Last quarter';

  @override
  String get moonWaningCrescent => 'Waning crescent';

  @override
  String moonIllumination(int percent) {
    return '$percent% lit';
  }

  @override
  String get navTrips => 'Trips';

  @override
  String get tripsEmptyTitle => 'No trips yet';

  @override
  String get tripsEmptyBody =>
      'Plan a trip to see the weather at each stop, day by day.';

  @override
  String get planTrip => 'Plan a trip';

  @override
  String get newTrip => 'New trip';

  @override
  String get editTrip => 'Edit trip';

  @override
  String get tripName => 'Trip name';

  @override
  String get tripNameHint => 'e.g. Christmas in Abuja';

  @override
  String tripDefaultName(String place) {
    return 'Trip to $place';
  }

  @override
  String get tripStops => 'Stops';

  @override
  String get addStop => 'Add a stop';

  @override
  String get removeStop => 'Remove stop';

  @override
  String get chooseDates => 'Choose dates';

  @override
  String get save => 'Save';

  @override
  String get deleteTrip => 'Delete trip';

  @override
  String get tripDeleted => 'Trip deleted';

  @override
  String get tripProblemNoStops => 'Add at least one stop.';

  @override
  String get tripProblemOrder =>
      'Each stop must start on or after the day the previous one ends.';

  @override
  String tripProblemTooLong(int days) {
    return 'Trips can be at most $days days long.';
  }

  @override
  String tripStartsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Starts in $count days',
      one: 'Starts tomorrow',
      zero: 'Starts today',
    );
    return '$_temp0';
  }

  @override
  String get tripOngoing => 'Happening now';

  @override
  String get tripEnded => 'Ended';

  @override
  String tripDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String travelDay(String place) {
    return 'Travel day from $place';
  }

  @override
  String get typicalWeather => 'Typical for the date';

  @override
  String typicalWeatherNote(int days) {
    return 'Days more than $days days away show typical weather for the date (the average of the last 20 years). The forecast replaces it automatically as the trip gets closer.';
  }

  @override
  String get weatherUnknown => 'No data yet';

  @override
  String get packingList => 'Packing list';

  @override
  String get packingEmpty => 'Nothing special to pack for this weather.';

  @override
  String get packUmbrella => 'Umbrella';

  @override
  String get packRainJacket => 'Rain jacket';

  @override
  String get packSunscreen => 'Sunscreen';

  @override
  String get packSunglasses => 'Sunglasses';

  @override
  String get packHat => 'Sun hat';

  @override
  String get packLightClothes => 'Light, breathable clothes';

  @override
  String get packWaterBottle => 'Reusable water bottle';

  @override
  String get packWarmLayer => 'Warm sweater or fleece';

  @override
  String get packCoat => 'Winter coat';

  @override
  String get packGloves => 'Gloves';

  @override
  String get packWindbreaker => 'Windbreaker';

  @override
  String get packInsectRepellent => 'Insect repellent';

  @override
  String get shareTrip => 'Share';

  @override
  String get tripReminder => 'Remind me the day before';

  @override
  String get tripReminderDetail =>
      'A notification the evening before you leave, with the forecast for your first stop.';

  @override
  String tripReminderTitle(String place) {
    return 'Your trip to $place starts tomorrow';
  }

  @override
  String get tripReminderBodyFallback => 'Check the forecast before you go.';

  @override
  String tripOutlookRange(String low, String high) {
    return '$low to $high';
  }

  @override
  String tripRainyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rain likely on $count days',
      one: 'Rain likely on 1 day',
      zero: 'No rain expected',
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
    return '$day · $place: $condition, $min to $max, rain $rain%';
  }

  @override
  String shareTypicalDay(String day, String place, String min, String max) {
    return '$day · $place: typically $min to $max';
  }

  @override
  String get sharedFromApp => 'Shared from BWeather';

  @override
  String get privacyTripsTitle => 'Trips';

  @override
  String get privacyTripsBody =>
      'The trips you plan are stored only on this device. To get their weather, the coordinates and dates of each stop are sent to Open-Meteo.';
}

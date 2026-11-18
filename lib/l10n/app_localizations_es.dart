// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'BWeather';

  @override
  String get navForecast => 'Pronóstico';

  @override
  String get navLocations => 'Lugares';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get addCity => 'Añadir una ciudad';

  @override
  String get searchHint => 'Buscar ciudades';

  @override
  String get clearSearch => 'Borrar búsqueda';

  @override
  String get close => 'Cerrar';

  @override
  String get retry => 'Reintentar';

  @override
  String get keepTyping => 'Sigue escribiendo…';

  @override
  String get searchFailed =>
      'La búsqueda falló. Comprueba tu conexión a internet e inténtalo de nuevo.';

  @override
  String noPlacesMatch(String query) {
    return 'Ningún lugar coincide con \"$query\".';
  }

  @override
  String get welcomeTitle => 'Bienvenido a BWeather';

  @override
  String get welcomeSubtitle =>
      'Pronósticos para donde estás y para los lugares que te importan.';

  @override
  String get useMyLocation => 'Usar mi ubicación';

  @override
  String get findingYou => 'Buscando tu ubicación…';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String continueWith(String place) {
    return 'Continuar con $place';
  }

  @override
  String get approximateFromNetwork => 'Aproximada, según tu red';

  @override
  String get searchForCity => 'Buscar una ciudad';

  @override
  String get locationPrivacyNote =>
      'Tu ubicación solo se usa para obtener el pronóstico.';

  @override
  String get locationServiceDisabled =>
      'Los servicios de ubicación están desactivados.';

  @override
  String get locationPermissionDenied =>
      'No se concedió el permiso de ubicación.';

  @override
  String get locationPermissionBlocked =>
      'El permiso de ubicación está bloqueado. Puedes permitirlo en Ajustes.';

  @override
  String get locationUnavailable =>
      'No hemos podido encontrar tu ubicación en este momento.';

  @override
  String get approximateBanner =>
      'Mostrando una ubicación aproximada según tu red.';

  @override
  String get usePrecise => 'Usar precisa';

  @override
  String get noPlacesTitle => 'Aún no hay lugares';

  @override
  String get noPlacesBody =>
      'Usa tu ubicación o añade una ciudad para ver su pronóstico.';

  @override
  String get noSavedPlaces =>
      'Aún no hay lugares guardados. Toca + para añadir una ciudad.';

  @override
  String get yourLocation => 'Tu ubicación';

  @override
  String get approximateLocation => 'Ubicación aproximada';

  @override
  String removeCity(String city) {
    return 'Quitar $city';
  }

  @override
  String get reorderHint =>
      'Mantén pulsada una ciudad y arrástrala para reordenar.';

  @override
  String forecastLoadFailed(String city) {
    return 'No se pudo cargar el pronóstico de $city.';
  }

  @override
  String get forecastUnavailable => 'No se pudo cargar el pronóstico';

  @override
  String get forecastErrorNetwork =>
      'No se pudo conectar con el servicio meteorológico. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get forecastErrorData =>
      'El servicio meteorológico envió datos que no pudimos leer. Inténtalo más tarde.';

  @override
  String get couldNotRefresh => 'No se pudo actualizar';

  @override
  String updatedAgo(String age) {
    return 'Actualizado $age';
  }

  @override
  String get ageJustNow => 'ahora mismo';

  @override
  String ageMinutes(int count) {
    return 'hace $count min';
  }

  @override
  String ageHours(int count) {
    return 'hace $count h';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String feelsLike(String temperature) {
    return 'Sensación de $temperature';
  }

  @override
  String get rainChance => 'Prob. de lluvia';

  @override
  String windWithDirection(String direction) {
    return 'Viento $direction';
  }

  @override
  String get humidity => 'Humedad';

  @override
  String get daily => 'Diario';

  @override
  String get hourly => 'Por horas';

  @override
  String get today => 'Hoy';

  @override
  String get now => 'Ahora';

  @override
  String get windDirection => 'Dirección del viento';

  @override
  String get windGusts => 'Ráfagas';

  @override
  String get rainToday => 'Lluvia hoy';

  @override
  String get pressure => 'Presión';

  @override
  String get cloudCover => 'Nubosidad';

  @override
  String get dewPoint => 'Punto de rocío';

  @override
  String get sunrise => 'Amanecer';

  @override
  String get sunset => 'Atardecer';

  @override
  String semanticsCurrent(String temperature, String condition) {
    return '$temperature grados, $condition';
  }

  @override
  String semanticsDay(String day, String condition, String min, String max) {
    return '$day: $condition, de $min a $max';
  }

  @override
  String semanticsRainChance(int percent) {
    return '$percent% de probabilidad de lluvia';
  }

  @override
  String get compassPoints =>
      'N,NNE,NE,ENE,E,ESE,SE,SSE,S,SSO,SO,OSO,O,ONO,NO,NNO';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeAuto => 'Automático';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get settingsTemperature => 'Temperatura';

  @override
  String get unitCelsius => 'Celsius (°C)';

  @override
  String get unitFahrenheit => 'Fahrenheit (°F)';

  @override
  String get settingsWindSpeed => 'Velocidad del viento';

  @override
  String get unitKmh => 'Kilómetros por hora (km/h)';

  @override
  String get unitMph => 'Millas por hora (mph)';

  @override
  String get unitMs => 'Metros por segundo (m/s)';

  @override
  String get unitKnots => 'Nudos (kn)';

  @override
  String get settingsPrecipitation => 'Precipitación';

  @override
  String get unitMm => 'Milímetros (mm)';

  @override
  String get unitInch => 'Pulgadas (in)';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get aboutApp => 'Acerca de BWeather';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get aboutDescription =>
      'BWeather muestra el tiempo actual y los pronósticos para tu ubicación y los lugares que guardes. Lo desarrolla y mantiene Nobel para Bsoft Limited.';

  @override
  String get aboutDataSources => 'Fuentes de datos';

  @override
  String get aboutOpenMeteo =>
      'Tiempo y búsqueda de lugares: Open-Meteo (open-meteo.com), con licencia CC BY 4.0.';

  @override
  String get aboutOsm =>
      'Nombres de lugares: © colaboradores de OpenStreetMap (Nominatim), ODbL.';

  @override
  String get aboutIpapi => 'Ubicación aproximada: ipapi.co.';

  @override
  String get aboutIcons => 'Iconos del tiempo: Meteocons de Bas Milius (MIT).';

  @override
  String get privacyIntro =>
      'BWeather no tiene cuentas, ni anuncios, ni analíticas. Esta página explica qué datos salen de tu dispositivo y por qué.';

  @override
  String get privacyLocationTitle => 'Tu ubicación';

  @override
  String get privacyLocationBody =>
      'Si lo permites, la app lee la ubicación de tu dispositivo. Las coordenadas se envían a Open-Meteo para obtener el pronóstico y a OpenStreetMap Nominatim para obtener el nombre del lugar. No se envían a ningún otro sitio.';

  @override
  String get privacyApproximateTitle => 'Ubicación aproximada';

  @override
  String get privacyApproximateBody =>
      'Cuando la ubicación precisa no está disponible, la app pide a ipapi.co una ubicación aproximada a nivel de ciudad. ipapi.co ve tu dirección IP para responder a esta solicitud.';

  @override
  String get privacySearchTitle => 'Búsqueda de ciudades';

  @override
  String get privacySearchBody =>
      'El texto que escribes en la búsqueda de ciudades se envía al servicio de geocodificación de Open-Meteo para encontrar lugares.';

  @override
  String get privacyStorageTitle => 'Datos guardados en tu dispositivo';

  @override
  String get privacyStorageBody =>
      'Tus ciudades guardadas, los últimos pronósticos y tus ajustes se guardan solo en este dispositivo. Al desinstalar la app se eliminan.';

  @override
  String get privacyContactTitle => 'Contacto';

  @override
  String get privacyContactBody =>
      '¿Preguntas sobre privacidad? Contacta con Bsoft Limited a través de la ficha de la app en la tienda.';

  @override
  String get termsIntro => 'Al usar BWeather aceptas estos términos.';

  @override
  String get termsAccuracyTitle => 'Precisión del pronóstico';

  @override
  String get termsAccuracyBody =>
      'Los pronósticos son estimaciones y pueden fallar. No dependas de BWeather para decisiones en las que esté en juego la seguridad; sigue los avisos oficiales de tu servicio meteorológico nacional.';

  @override
  String get termsServiceTitle => 'El servicio';

  @override
  String get termsServiceBody =>
      'BWeather se ofrece \"tal cual\", sin garantías. Las funciones pueden cambiar y el servicio puede no estar disponible en ocasiones.';

  @override
  String get termsThirdPartyTitle => 'Datos de terceros';

  @override
  String get termsThirdPartyBody =>
      'Los datos meteorológicos proceden de Open-Meteo y los nombres de lugares de OpenStreetMap. Sus propios términos y licencias se aplican a esos datos.';

  @override
  String legalLastUpdated(String date) {
    return 'Última actualización: $date';
  }

  @override
  String get wmo0 => 'Cielo despejado';

  @override
  String get wmo1 => 'Mayormente despejado';

  @override
  String get wmo2 => 'Parcialmente nublado';

  @override
  String get wmo3 => 'Cubierto';

  @override
  String get wmo45 => 'Niebla';

  @override
  String get wmo48 => 'Niebla helada';

  @override
  String get wmo51 => 'Llovizna ligera';

  @override
  String get wmo53 => 'Llovizna moderada';

  @override
  String get wmo55 => 'Llovizna densa';

  @override
  String get wmo56 => 'Llovizna helada ligera';

  @override
  String get wmo57 => 'Llovizna helada densa';

  @override
  String get wmo61 => 'Lluvia ligera';

  @override
  String get wmo63 => 'Lluvia moderada';

  @override
  String get wmo65 => 'Lluvia fuerte';

  @override
  String get wmo66 => 'Lluvia helada ligera';

  @override
  String get wmo67 => 'Lluvia helada fuerte';

  @override
  String get wmo71 => 'Nevada ligera';

  @override
  String get wmo73 => 'Nevada moderada';

  @override
  String get wmo75 => 'Nevada fuerte';

  @override
  String get wmo77 => 'Granos de nieve';

  @override
  String get wmo80 => 'Chubascos ligeros';

  @override
  String get wmo81 => 'Chubascos moderados';

  @override
  String get wmo82 => 'Chubascos violentos';

  @override
  String get wmo85 => 'Chubascos de nieve ligeros';

  @override
  String get wmo86 => 'Chubascos de nieve fuertes';

  @override
  String get wmo95 => 'Tormenta';

  @override
  String get wmo96 => 'Tormenta con granizo ligero';

  @override
  String get wmo99 => 'Tormenta con granizo fuerte';

  @override
  String get wmoUnknown => 'Condiciones desconocidas';

  @override
  String get pageNotFound => 'Página no encontrada';

  @override
  String get airQuality => 'Calidad del aire';

  @override
  String airQualityIndex(int value) {
    return 'ICA EE. UU. $value';
  }

  @override
  String get aqiGood => 'Buena';

  @override
  String get aqiModerate => 'Moderada';

  @override
  String get aqiSensitive => 'Dañina para grupos sensibles';

  @override
  String get aqiUnhealthy => 'Dañina';

  @override
  String get aqiVeryUnhealthy => 'Muy dañina';

  @override
  String get aqiHazardous => 'Peligrosa';

  @override
  String get pm25 => 'PM2,5';

  @override
  String get pm10 => 'PM10';

  @override
  String get dust => 'Polvo';

  @override
  String get uvIndex => 'Índice UV';

  @override
  String get uvLow => 'Bajo';

  @override
  String get uvModerate => 'Moderado';

  @override
  String get uvHigh => 'Alto';

  @override
  String get uvVeryHigh => 'Muy alto';

  @override
  String get uvExtreme => 'Extremo';

  @override
  String get pollen => 'Polen';

  @override
  String get pollenAlder => 'Aliso';

  @override
  String get pollenBirch => 'Abedul';

  @override
  String get pollenGrass => 'Gramíneas';

  @override
  String get pollenMugwort => 'Artemisa';

  @override
  String get pollenOlive => 'Olivo';

  @override
  String get pollenRagweed => 'Ambrosía';

  @override
  String get harmattanDustHint =>
      'Mucho polvo en el aire: considera usar mascarilla en el exterior.';

  @override
  String get chart => 'Gráfico';

  @override
  String get chartLegendTemperature => 'Temperatura';

  @override
  String get chartLegendRain => 'Prob. de lluvia';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get notifyMorningBrief => 'Resumen matinal';

  @override
  String get notifyMorningBriefDetail =>
      'El pronóstico del día para tu ubicación cada mañana.';

  @override
  String get notifyBriefTime => 'Hora';

  @override
  String get notifyRain => 'Avisos de lluvia';

  @override
  String get notifyRainDetail =>
      'Cuando es probable que llueva en las próximas 2 horas.';

  @override
  String get notifySevere => 'Tiempo severo';

  @override
  String get notifySevereDetail =>
      'Tormentas, vientos muy fuertes o calor extremo.';

  @override
  String get notifyPermissionDenied =>
      'Las notificaciones de BWeather están desactivadas en los ajustes del dispositivo.';

  @override
  String get notifyUnsupported =>
      'Las notificaciones están disponibles en la app de Android.';

  @override
  String get notifyBackgroundNote =>
      'Los avisos se comprueban aproximadamente una vez por hora, así que pueden llegar con un poco de retraso.';

  @override
  String get notifyChannelForecast => 'Pronósticos';

  @override
  String get notifyChannelAlerts => 'Avisos meteorológicos';

  @override
  String briefTitle(String place) {
    return 'Hoy en $place';
  }

  @override
  String briefBody(String condition, String min, String max, int rain) {
    return '$condition, de $min a $max. Probabilidad de lluvia $rain%.';
  }

  @override
  String rainAlertTitle(String place) {
    return 'Se espera lluvia en $place';
  }

  @override
  String rainAlertBody(int percent, String time) {
    return '$percent% de probabilidad de lluvia hacia las $time.';
  }

  @override
  String severeThunderTitle(String place) {
    return 'Tormentas cerca de $place';
  }

  @override
  String severeThunderBody(String time) {
    return 'Se esperan tormentas hacia las $time. Quédate en interiores si puedes.';
  }

  @override
  String severeWindTitle(String place) {
    return 'Vientos fuertes en $place';
  }

  @override
  String severeWindBody(String speed) {
    return 'Se esperan ráfagas de hasta $speed hoy.';
  }

  @override
  String severeHeatTitle(String place) {
    return 'Calor extremo en $place';
  }

  @override
  String severeHeatBody(String temperature) {
    return 'Hoy la sensación térmica será de $temperature. Bebe agua y evita el sol del mediodía.';
  }

  @override
  String get aboutCams =>
      'Calidad del aire: generado con información del Servicio de Vigilancia Atmosférica de Copernicus (a través de Open-Meteo).';

  @override
  String widgetRange(String max, String min) {
    return 'Máx. $max · Mín. $min';
  }

  @override
  String widgetUpdated(String time) {
    return 'Actualizado $time';
  }

  @override
  String get tipsTitle => 'Consejos de hoy';

  @override
  String tipUmbrella(int percent, String time) {
    return 'Lleva paraguas: $percent% de probabilidad de lluvia, sobre todo hacia las $time.';
  }

  @override
  String get tipClothesHot => 'Lleva ropa ligera y transpirable.';

  @override
  String get tipClothesWarm => 'Tiempo de camiseta.';

  @override
  String get tipClothesMild => 'Lleva una chaqueta ligera.';

  @override
  String get tipClothesCool => 'Ponte una chaqueta abrigada.';

  @override
  String get tipClothesCold => 'Abrígate bien: hace frío.';

  @override
  String tipSunscreen(String level) {
    return 'El índice UV es $level hoy: usa protector solar y sombrero entre las 10:00 y las 16:00.';
  }

  @override
  String tipHydrate(String temperature) {
    return 'La sensación térmica será de $temperature. Bebe mucha agua.';
  }

  @override
  String get tipLaundryGood => 'Buen día para tender la ropa fuera.';

  @override
  String get tipLaundryBad => 'No es buen día para tender la ropa fuera.';

  @override
  String tipBestOutdoorTime(String time) {
    return 'Mejor momento para estar al aire libre: hacia las $time.';
  }

  @override
  String get tipAirQuality =>
      'La calidad del aire es mala: limita la actividad larga o intensa al aire libre.';

  @override
  String get tipMosquitoes =>
      'Tarde cálida y húmeda: probablemente haya mosquitos, usa repelente o mosquitera.';

  @override
  String tipDriveFog(String time) {
    return 'Conduce con cuidado: se espera niebla hacia las $time.';
  }

  @override
  String tipDriveRain(String time) {
    return 'Conduce con cuidado: se espera lluvia fuerte hacia las $time.';
  }

  @override
  String get refresh => 'Actualizar';

  @override
  String get settingsDisplay => 'Pantalla y datos';

  @override
  String get settingsAnimatedBackground => 'Fondos animados';

  @override
  String get settingsAnimatedBackgroundDetail =>
      'Un cielo en movimiento detrás del pronóstico. Se queda quieto si tu dispositivo reduce el movimiento.';

  @override
  String get settingsMinuteRain => 'Lluvia minuto a minuto';

  @override
  String get settingsMinuteRainDetail =>
      'La lluvia de las próximas 2 horas en intervalos de 15 minutos. Usa algo más de datos.';

  @override
  String get settingsCrashReports => 'Enviar informes de errores';

  @override
  String get settingsCrashReportsDetail =>
      'Detalles anónimos de errores que ayudan a corregir fallos. Sin ubicación ni datos personales.';

  @override
  String get nextTwoHours => 'Próximas 2 horas';

  @override
  String rainStartingIn(int minutes) {
    return 'Lluvia en unos $minutes min';
  }

  @override
  String rainStoppingIn(int minutes) {
    return 'La lluvia parará en unos $minutes min';
  }

  @override
  String get rainContinuing => 'Lluvia durante al menos las próximas 2 horas';

  @override
  String get noRainSoon => 'No se espera lluvia en las próximas 2 horas';

  @override
  String get tempAboutNormal => 'Normal para hoy';

  @override
  String tempWarmerThanUsual(int degrees) {
    return '$degrees° más cálido de lo habitual';
  }

  @override
  String tempCoolerThanUsual(int degrees) {
    return '$degrees° más fresco de lo habitual';
  }

  @override
  String tempNormalsSource(String fromYear, String toYear) {
    return 'Máxima de hoy comparada con la máxima media de esta fecha, $fromYear–$toYear.';
  }

  @override
  String get radar => 'Radar de lluvia';

  @override
  String get radarUnavailable => 'El radar no está disponible en este momento.';

  @override
  String get radarNoCoverage =>
      'El radar muestra las últimas 2 horas. Algunas regiones tienen poca o ninguna cobertura.';

  @override
  String get play => 'Reproducir';

  @override
  String get pause => 'Pausar';

  @override
  String get aboutRainViewer =>
      'Radar: datos meteorológicos de RainViewer; mapa © colaboradores de OpenStreetMap.';

  @override
  String get privacyRadarTitle => 'Mapa del radar';

  @override
  String get privacyRadarBody =>
      'Al abrir el radar se descargan teselas de mapa de OpenStreetMap e imágenes de radar de RainViewer para la zona que ves. Como cualquier sitio web, ven tu dirección IP.';

  @override
  String get privacyCrashTitle => 'Informes de errores';

  @override
  String get privacyCrashBody =>
      'Si la app falla, se puede enviar a Sentry un informe de error anónimo (modelo del dispositivo, versión del sistema, versión de la app y el error) para que podamos corregirlo. Nunca incluye tu ubicación, tus lugares guardados ni tu dirección IP. Puedes desactivarlo en Ajustes.';

  @override
  String get aboutHistory =>
      'Promedios climáticos: API de tiempo histórico de Open-Meteo (ERA5).';

  @override
  String get zoomIn => 'Acercar';

  @override
  String get zoomOut => 'Alejar';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsUnits => 'Unidades';

  @override
  String get settingsPrivacy => 'Privacidad';

  @override
  String cityRemoved(String city) {
    return 'Se quitó $city';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get sunAndMoon => 'Sol y luna';

  @override
  String get daylight => 'Horas de luz';

  @override
  String daylightDuration(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get moonNew => 'Luna nueva';

  @override
  String get moonWaxingCrescent => 'Creciente';

  @override
  String get moonFirstQuarter => 'Cuarto creciente';

  @override
  String get moonWaxingGibbous => 'Gibosa creciente';

  @override
  String get moonFull => 'Luna llena';

  @override
  String get moonWaningGibbous => 'Gibosa menguante';

  @override
  String get moonLastQuarter => 'Cuarto menguante';

  @override
  String get moonWaningCrescent => 'Menguante';

  @override
  String moonIllumination(int percent) {
    return '$percent % iluminada';
  }

  @override
  String get navTrips => 'Viajes';

  @override
  String get tripsEmptyTitle => 'Aún no hay viajes';

  @override
  String get tripsEmptyBody =>
      'Planifica un viaje para ver el tiempo en cada parada, día a día.';

  @override
  String get planTrip => 'Planificar un viaje';

  @override
  String get newTrip => 'Nuevo viaje';

  @override
  String get editTrip => 'Editar viaje';

  @override
  String get tripName => 'Nombre del viaje';

  @override
  String get tripNameHint => 'p. ej. Navidad en Abuya';

  @override
  String tripDefaultName(String place) {
    return 'Viaje a $place';
  }

  @override
  String get tripStops => 'Paradas';

  @override
  String get addStop => 'Añadir una parada';

  @override
  String get removeStop => 'Quitar parada';

  @override
  String get chooseDates => 'Elegir fechas';

  @override
  String get save => 'Guardar';

  @override
  String get deleteTrip => 'Eliminar viaje';

  @override
  String get tripDeleted => 'Viaje eliminado';

  @override
  String get tripProblemNoStops => 'Añade al menos una parada.';

  @override
  String get tripProblemOrder =>
      'Cada parada debe empezar el día en que termina la anterior o después.';

  @override
  String tripProblemTooLong(int days) {
    return 'Un viaje puede durar como máximo $days días.';
  }

  @override
  String tripStartsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Empieza en $count días',
      one: 'Empieza mañana',
      zero: 'Empieza hoy',
    );
    return '$_temp0';
  }

  @override
  String get tripOngoing => 'En curso';

  @override
  String get tripEnded => 'Terminado';

  @override
  String tripDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String travelDay(String place) {
    return 'Día de viaje desde $place';
  }

  @override
  String get typicalWeather => 'Habitual para la fecha';

  @override
  String typicalWeatherNote(int days) {
    return 'Los días a más de $days días muestran el tiempo habitual para la fecha (media de los últimos 20 años). El pronóstico lo sustituye automáticamente cuando se acerca el viaje.';
  }

  @override
  String get weatherUnknown => 'Aún sin datos';

  @override
  String get packingList => 'Lista de equipaje';

  @override
  String get packingEmpty => 'Nada especial que llevar para este tiempo.';

  @override
  String get packUmbrella => 'Paraguas';

  @override
  String get packRainJacket => 'Chubasquero';

  @override
  String get packSunscreen => 'Protector solar';

  @override
  String get packSunglasses => 'Gafas de sol';

  @override
  String get packHat => 'Sombrero';

  @override
  String get packLightClothes => 'Ropa ligera y transpirable';

  @override
  String get packWaterBottle => 'Botella de agua reutilizable';

  @override
  String get packWarmLayer => 'Jersey o forro polar';

  @override
  String get packCoat => 'Abrigo de invierno';

  @override
  String get packGloves => 'Guantes';

  @override
  String get packWindbreaker => 'Cortavientos';

  @override
  String get packInsectRepellent => 'Repelente de insectos';

  @override
  String get shareTrip => 'Compartir';

  @override
  String get tripReminder => 'Recordármelo el día antes';

  @override
  String get tripReminderDetail =>
      'Una notificación la tarde antes de salir, con el pronóstico de tu primera parada.';

  @override
  String tripReminderTitle(String place) {
    return 'Tu viaje a $place empieza mañana';
  }

  @override
  String get tripReminderBodyFallback =>
      'Consulta el pronóstico antes de salir.';

  @override
  String tripOutlookRange(String low, String high) {
    return '$low a $high';
  }

  @override
  String tripRainyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lluvia probable $count días',
      one: 'Lluvia probable 1 día',
      zero: 'No se espera lluvia',
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
    return '$day · $place: $condition, $min a $max, lluvia $rain %';
  }

  @override
  String shareTypicalDay(String day, String place, String min, String max) {
    return '$day · $place: normalmente $min a $max';
  }

  @override
  String get sharedFromApp => 'Compartido desde BWeather';

  @override
  String get privacyTripsTitle => 'Viajes';

  @override
  String get privacyTripsBody =>
      'Los viajes que planificas se guardan solo en este dispositivo. Para obtener su tiempo, las coordenadas y fechas de cada parada se envían a Open-Meteo.';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BWeather';

  @override
  String get navForecast => '预报';

  @override
  String get navLocations => '地点';

  @override
  String get navSettings => '设置';

  @override
  String get addCity => '添加城市';

  @override
  String get searchHint => '搜索城市';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get close => '关闭';

  @override
  String get retry => '重试';

  @override
  String get keepTyping => '请继续输入…';

  @override
  String get searchFailed => '搜索失败。请检查网络连接后重试。';

  @override
  String noPlacesMatch(String query) {
    return '没有与“$query”匹配的地点。';
  }

  @override
  String get welcomeTitle => '欢迎使用 BWeather';

  @override
  String get welcomeSubtitle => '查看你所在位置和关注地点的天气预报。';

  @override
  String get useMyLocation => '使用我的位置';

  @override
  String get findingYou => '正在定位…';

  @override
  String get openSettings => '打开设置';

  @override
  String continueWith(String place) {
    return '继续使用$place';
  }

  @override
  String get approximateFromNetwork => '大致位置，基于你的网络';

  @override
  String get searchForCity => '搜索城市';

  @override
  String get locationPrivacyNote => '你的位置仅用于获取天气预报。';

  @override
  String get locationServiceDisabled => '定位服务已关闭。';

  @override
  String get locationPermissionDenied => '未授予位置权限。';

  @override
  String get locationPermissionBlocked => '位置权限已被阻止。你可以在设置中允许。';

  @override
  String get locationUnavailable => '暂时无法获取你的位置。';

  @override
  String get approximateBanner => '正在显示基于网络的大致位置。';

  @override
  String get usePrecise => '使用精确位置';

  @override
  String get noPlacesTitle => '还没有地点';

  @override
  String get noPlacesBody => '使用你的位置或添加城市来查看天气预报。';

  @override
  String get noSavedPlaces => '还没有保存的地点。点按 + 添加城市。';

  @override
  String get yourLocation => '你的位置';

  @override
  String get approximateLocation => '大致位置';

  @override
  String removeCity(String city) {
    return '移除$city';
  }

  @override
  String get reorderHint => '长按并拖动城市可调整顺序。';

  @override
  String forecastLoadFailed(String city) {
    return '无法加载$city的天气预报。';
  }

  @override
  String get forecastUnavailable => '无法加载天气预报';

  @override
  String get forecastErrorNetwork => '无法连接天气服务。请检查网络连接后重试。';

  @override
  String get forecastErrorData => '天气服务返回了无法读取的数据。请稍后重试。';

  @override
  String get couldNotRefresh => '无法刷新';

  @override
  String updatedAgo(String age) {
    return '$age更新';
  }

  @override
  String get ageJustNow => '刚刚';

  @override
  String ageMinutes(int count) {
    return '$count 分钟前';
  }

  @override
  String ageHours(int count) {
    return '$count 小时前';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天前',
      one: '1 天前',
    );
    return '$_temp0';
  }

  @override
  String feelsLike(String temperature) {
    return '体感 $temperature';
  }

  @override
  String get rainChance => '降雨概率';

  @override
  String windWithDirection(String direction) {
    return '$direction风';
  }

  @override
  String get humidity => '湿度';

  @override
  String get daily => '每日';

  @override
  String get hourly => '逐小时';

  @override
  String get today => '今天';

  @override
  String get now => '现在';

  @override
  String get windDirection => '风向';

  @override
  String get windGusts => '阵风';

  @override
  String get rainToday => '今日降雨';

  @override
  String get pressure => '气压';

  @override
  String get cloudCover => '云量';

  @override
  String get dewPoint => '露点';

  @override
  String get sunrise => '日出';

  @override
  String get sunset => '日落';

  @override
  String semanticsCurrent(String temperature, String condition) {
    return '$temperature 度，$condition';
  }

  @override
  String semanticsDay(String day, String condition, String min, String max) {
    return '$day：$condition，$min 至 $max';
  }

  @override
  String semanticsRainChance(int percent) {
    return '降雨概率 $percent%';
  }

  @override
  String get compassPoints =>
      '北,东北偏北,东北,东北偏东,东,东南偏东,东南,东南偏南,南,西南偏南,西南,西南偏西,西,西北偏西,西北,西北偏北';

  @override
  String get settingsGeneral => '常规';

  @override
  String get settingsTheme => '主题';

  @override
  String get themeAuto => '自动';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get settingsLanguage => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get settingsTemperature => '温度';

  @override
  String get unitCelsius => '摄氏度 (°C)';

  @override
  String get unitFahrenheit => '华氏度 (°F)';

  @override
  String get settingsWindSpeed => '风速';

  @override
  String get unitKmh => '千米/小时 (km/h)';

  @override
  String get unitMph => '英里/小时 (mph)';

  @override
  String get unitMs => '米/秒 (m/s)';

  @override
  String get unitKnots => '节 (kn)';

  @override
  String get settingsPrecipitation => '降水量';

  @override
  String get unitMm => '毫米 (mm)';

  @override
  String get unitInch => '英寸 (in)';

  @override
  String get settingsAbout => '关于';

  @override
  String get aboutApp => '关于 BWeather';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfUse => '使用条款';

  @override
  String version(String version) {
    return '版本 $version';
  }

  @override
  String get aboutDescription =>
      'BWeather 显示你所在位置和已保存地点的当前天气与预报。由 Nobel 为 Bsoft Limited 开发和维护。';

  @override
  String get aboutDataSources => '数据来源';

  @override
  String get aboutOpenMeteo =>
      '天气与地点搜索：Open-Meteo (open-meteo.com)，采用 CC BY 4.0 许可。';

  @override
  String get aboutOsm => '地名：© OpenStreetMap 贡献者 (Nominatim)，ODbL。';

  @override
  String get aboutIpapi => '大致位置：ipapi.co。';

  @override
  String get aboutIcons => '天气图标：Bas Milius 的 Meteocons (MIT)。';

  @override
  String get privacyIntro => 'BWeather 没有账户、没有广告，也没有分析统计。本页说明哪些数据会离开你的设备以及原因。';

  @override
  String get privacyLocationTitle => '你的位置';

  @override
  String get privacyLocationBody =>
      '如果你允许，应用会读取设备的位置。坐标会发送给 Open-Meteo 以获取天气预报，并发送给 OpenStreetMap Nominatim 以获取地名。不会发送到其他任何地方。';

  @override
  String get privacyApproximateTitle => '大致位置';

  @override
  String get privacyApproximateBody =>
      '当无法获取精确位置时，应用会向 ipapi.co 请求城市级别的大致位置。ipapi.co 需要看到你的 IP 地址才能响应此请求。';

  @override
  String get privacySearchTitle => '城市搜索';

  @override
  String get privacySearchBody =>
      '你在城市搜索中输入的文字会发送到 Open-Meteo 的地理编码服务，以查找匹配的地点。';

  @override
  String get privacyStorageTitle => '存储在设备上的数据';

  @override
  String get privacyStorageBody => '你保存的城市、最新的天气预报和设置仅存储在此设备上。卸载应用会将其删除。';

  @override
  String get privacyContactTitle => '联系方式';

  @override
  String get privacyContactBody => '有隐私方面的问题？请通过应用商店页面联系 Bsoft Limited。';

  @override
  String get termsIntro => '使用 BWeather 即表示你同意这些条款。';

  @override
  String get termsAccuracyTitle => '预报准确性';

  @override
  String get termsAccuracyBody =>
      '天气预报是估计值，可能会出错。涉及安全的决定请勿依赖 BWeather；请遵循本国气象部门发布的官方预警。';

  @override
  String get termsServiceTitle => '服务';

  @override
  String get termsServiceBody => 'BWeather 按“现状”提供，不作任何保证。功能可能会变化，服务有时可能无法使用。';

  @override
  String get termsThirdPartyTitle => '第三方数据';

  @override
  String get termsThirdPartyBody =>
      '天气数据来自 Open-Meteo，地名来自 OpenStreetMap。这些数据适用其各自的条款和许可。';

  @override
  String legalLastUpdated(String date) {
    return '最后更新：$date';
  }

  @override
  String get wmo0 => '晴朗';

  @override
  String get wmo1 => '大致晴朗';

  @override
  String get wmo2 => '局部多云';

  @override
  String get wmo3 => '阴天';

  @override
  String get wmo45 => '雾';

  @override
  String get wmo48 => '雾凇';

  @override
  String get wmo51 => '小毛毛雨';

  @override
  String get wmo53 => '中毛毛雨';

  @override
  String get wmo55 => '大毛毛雨';

  @override
  String get wmo56 => '轻度冻毛毛雨';

  @override
  String get wmo57 => '重度冻毛毛雨';

  @override
  String get wmo61 => '小雨';

  @override
  String get wmo63 => '中雨';

  @override
  String get wmo65 => '大雨';

  @override
  String get wmo66 => '小冻雨';

  @override
  String get wmo67 => '大冻雨';

  @override
  String get wmo71 => '小雪';

  @override
  String get wmo73 => '中雪';

  @override
  String get wmo75 => '大雪';

  @override
  String get wmo77 => '米雪';

  @override
  String get wmo80 => '小阵雨';

  @override
  String get wmo81 => '中阵雨';

  @override
  String get wmo82 => '强阵雨';

  @override
  String get wmo85 => '小阵雪';

  @override
  String get wmo86 => '大阵雪';

  @override
  String get wmo95 => '雷暴';

  @override
  String get wmo96 => '雷暴伴小冰雹';

  @override
  String get wmo99 => '雷暴伴大冰雹';

  @override
  String get wmoUnknown => '未知天气';

  @override
  String get pageNotFound => '找不到页面';

  @override
  String get airQuality => '空气质量';

  @override
  String airQualityIndex(int value) {
    return '美国 AQI $value';
  }

  @override
  String get aqiGood => '良好';

  @override
  String get aqiModerate => '中等';

  @override
  String get aqiSensitive => '对敏感人群不健康';

  @override
  String get aqiUnhealthy => '不健康';

  @override
  String get aqiVeryUnhealthy => '非常不健康';

  @override
  String get aqiHazardous => '危险';

  @override
  String get pm25 => 'PM2.5';

  @override
  String get pm10 => 'PM10';

  @override
  String get dust => '沙尘';

  @override
  String get uvIndex => '紫外线指数';

  @override
  String get uvLow => '低';

  @override
  String get uvModerate => '中等';

  @override
  String get uvHigh => '高';

  @override
  String get uvVeryHigh => '很高';

  @override
  String get uvExtreme => '极高';

  @override
  String get pollen => '花粉';

  @override
  String get pollenAlder => '桤木';

  @override
  String get pollenBirch => '桦树';

  @override
  String get pollenGrass => '禾草';

  @override
  String get pollenMugwort => '艾蒿';

  @override
  String get pollenOlive => '橄榄';

  @override
  String get pollenRagweed => '豚草';

  @override
  String get harmattanDustHint => '沙尘浓度高：外出时建议戴口罩。';

  @override
  String get chart => '图表';

  @override
  String get chartLegendTemperature => '温度';

  @override
  String get chartLegendRain => '降雨概率';

  @override
  String get settingsNotifications => '通知';

  @override
  String get notifyMorningBrief => '早间简报';

  @override
  String get notifyMorningBriefDetail => '每天早上推送你所在位置的今日预报。';

  @override
  String get notifyBriefTime => '时间';

  @override
  String get notifyRain => '降雨提醒';

  @override
  String get notifyRainDetail => '未来 2 小时内可能下雨时提醒。';

  @override
  String get notifySevere => '恶劣天气';

  @override
  String get notifySevereDetail => '雷暴、强风或极端高温。';

  @override
  String get notifyPermissionDenied => 'BWeather 的通知已在设备设置中关闭。';

  @override
  String get notifyUnsupported => '通知功能仅在 Android 应用中提供。';

  @override
  String get notifyBackgroundNote => '提醒大约每小时检查一次，因此可能会稍有延迟。';

  @override
  String get notifyChannelForecast => '天气预报';

  @override
  String get notifyChannelAlerts => '天气提醒';

  @override
  String briefTitle(String place) {
    return '$place今日天气';
  }

  @override
  String briefBody(String condition, String min, String max, int rain) {
    return '$condition，$min 至 $max。降雨概率 $rain%。';
  }

  @override
  String rainAlertTitle(String place) {
    return '$place预计有雨';
  }

  @override
  String rainAlertBody(int percent, String time) {
    return '$time前后降雨概率 $percent%。';
  }

  @override
  String severeThunderTitle(String place) {
    return '$place附近有雷暴';
  }

  @override
  String severeThunderBody(String time) {
    return '预计 $time前后有雷暴。请尽量留在室内。';
  }

  @override
  String severeWindTitle(String place) {
    return '$place有强风';
  }

  @override
  String severeWindBody(String speed) {
    return '今天预计阵风最高可达 $speed。';
  }

  @override
  String severeHeatTitle(String place) {
    return '$place极端高温';
  }

  @override
  String severeHeatBody(String temperature) {
    return '今天体感温度将达 $temperature。请多喝水，避开正午阳光。';
  }

  @override
  String get aboutCams => '空气质量：使用哥白尼大气监测服务的信息生成（通过 Open-Meteo）。';

  @override
  String widgetRange(String max, String min) {
    return '最高 $max · 最低 $min';
  }

  @override
  String widgetUpdated(String time) {
    return '$time 更新';
  }

  @override
  String get tipsTitle => '今日提示';

  @override
  String tipUmbrella(int percent, String time) {
    return '记得带伞：降雨概率 $percent%，最可能在 $time前后。';
  }

  @override
  String get tipClothesHot => '穿轻薄透气的衣服。';

  @override
  String get tipClothesWarm => '适合穿 T 恤。';

  @override
  String get tipClothesMild => '带一件薄外套。';

  @override
  String get tipClothesCool => '穿一件保暖外套。';

  @override
  String get tipClothesCold => '外面很冷，注意保暖。';

  @override
  String tipSunscreen(String level) {
    return '今天紫外线$level：10:00 至 16:00 之间请涂防晒霜并戴帽子。';
  }

  @override
  String tipHydrate(String temperature) {
    return '体感温度将达 $temperature。请多喝水。';
  }

  @override
  String get tipLaundryGood => '今天适合在户外晾衣服。';

  @override
  String get tipLaundryBad => '今天不适合在户外晾衣服。';

  @override
  String tipBestOutdoorTime(String time) {
    return '最适合户外活动的时间：$time前后。';
  }

  @override
  String get tipAirQuality => '空气质量差：减少长时间或高强度的户外活动。';

  @override
  String get tipMosquitoes => '傍晚温暖潮湿：蚊子可能较多，请使用驱蚊剂或蚊帐。';

  @override
  String tipDriveFog(String time) {
    return '小心驾驶：预计 $time前后有雾。';
  }

  @override
  String tipDriveRain(String time) {
    return '小心驾驶：预计 $time前后有大雨。';
  }

  @override
  String get refresh => '刷新';

  @override
  String get settingsDisplay => '显示与数据';

  @override
  String get settingsAnimatedBackground => '动态背景';

  @override
  String get settingsAnimatedBackgroundDetail => '在预报后面显示动态天空。设备开启减少动态效果时保持静止。';

  @override
  String get settingsMinuteRain => '分钟级降雨';

  @override
  String get settingsMinuteRainDetail => '以 15 分钟为间隔显示未来 2 小时的降雨。会略微多用一些数据。';

  @override
  String get settingsCrashReports => '发送崩溃报告';

  @override
  String get settingsCrashReportsDetail => '匿名错误信息，帮助修复问题。不含位置或个人数据。';

  @override
  String get nextTwoHours => '未来 2 小时';

  @override
  String rainStartingIn(int minutes) {
    return '约 $minutes 分钟后开始下雨';
  }

  @override
  String rainStoppingIn(int minutes) {
    return '约 $minutes 分钟后雨停';
  }

  @override
  String get rainContinuing => '未来至少 2 小时持续降雨';

  @override
  String get noRainSoon => '未来 2 小时预计无雨';

  @override
  String get tempAboutNormal => '与往年同期持平';

  @override
  String tempWarmerThanUsual(int degrees) {
    return '比往年同期高 $degrees°';
  }

  @override
  String tempCoolerThanUsual(int degrees) {
    return '比往年同期低 $degrees°';
  }

  @override
  String tempNormalsSource(String fromYear, String toYear) {
    return '今日最高气温与 $fromYear–$toYear 年同日平均最高气温的比较。';
  }

  @override
  String get radar => '降雨雷达';

  @override
  String get radarUnavailable => '雷达暂时不可用。';

  @override
  String get radarNoCoverage => '雷达显示过去 2 小时。部分地区覆盖较少或没有覆盖。';

  @override
  String get play => '播放';

  @override
  String get pause => '暂停';

  @override
  String get aboutRainViewer =>
      '雷达：天气数据由 RainViewer 提供；地图 © OpenStreetMap 贡献者。';

  @override
  String get privacyRadarTitle => '雷达地图';

  @override
  String get privacyRadarBody =>
      '打开雷达时，会从 OpenStreetMap 下载你所查看区域的地图图块，并从 RainViewer 下载雷达图像。与任何网站一样，它们会看到你的 IP 地址。';

  @override
  String get privacyCrashTitle => '崩溃报告';

  @override
  String get privacyCrashBody =>
      '如果应用崩溃，可能会向 Sentry 发送一份匿名错误报告（设备型号、系统版本、应用版本和错误信息），以便我们修复问题。报告绝不包含你的位置、保存的地点或 IP 地址。你可以在设置中关闭此功能。';

  @override
  String get aboutHistory => '气候平均值：Open-Meteo 历史天气 API (ERA5)。';

  @override
  String get zoomIn => '放大';

  @override
  String get zoomOut => '缩小';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsUnits => '单位';

  @override
  String get settingsPrivacy => '隐私';

  @override
  String cityRemoved(String city) {
    return '已移除$city';
  }

  @override
  String get undo => '撤销';

  @override
  String get sunAndMoon => '日月';

  @override
  String get daylight => '白昼时长';

  @override
  String daylightDuration(int hours, int minutes) {
    return '$hours 小时 $minutes 分钟';
  }

  @override
  String get moonNew => '新月';

  @override
  String get moonWaxingCrescent => '蛾眉月';

  @override
  String get moonFirstQuarter => '上弦月';

  @override
  String get moonWaxingGibbous => '盈凸月';

  @override
  String get moonFull => '满月';

  @override
  String get moonWaningGibbous => '亏凸月';

  @override
  String get moonLastQuarter => '下弦月';

  @override
  String get moonWaningCrescent => '残月';

  @override
  String moonIllumination(int percent) {
    return '亮度 $percent%';
  }

  @override
  String get navTrips => '行程';

  @override
  String get tripsEmptyTitle => '还没有行程';

  @override
  String get tripsEmptyBody => '规划行程，逐日查看每一站的天气。';

  @override
  String get planTrip => '规划行程';

  @override
  String get newTrip => '新建行程';

  @override
  String get editTrip => '编辑行程';

  @override
  String get tripName => '行程名称';

  @override
  String get tripNameHint => '例如：阿布贾过圣诞';

  @override
  String tripDefaultName(String place) {
    return '$place之旅';
  }

  @override
  String get tripStops => '站点';

  @override
  String get addStop => '添加站点';

  @override
  String get removeStop => '移除站点';

  @override
  String get chooseDates => '选择日期';

  @override
  String get save => '保存';

  @override
  String get deleteTrip => '删除行程';

  @override
  String get tripDeleted => '已删除行程';

  @override
  String get tripProblemNoStops => '请至少添加一个站点。';

  @override
  String get tripProblemOrder => '每一站的开始日期不能早于上一站的结束日期。';

  @override
  String tripProblemTooLong(int days) {
    return '行程最长 $days 天。';
  }

  @override
  String tripStartsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天后出发',
      one: '明天出发',
      zero: '今天出发',
    );
    return '$_temp0';
  }

  @override
  String get tripOngoing => '进行中';

  @override
  String get tripEnded => '已结束';

  @override
  String tripDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
      one: '1 天',
    );
    return '$_temp0';
  }

  @override
  String travelDay(String place) {
    return '从$place出发的旅行日';
  }

  @override
  String get typicalWeather => '往年同期天气';

  @override
  String typicalWeatherNote(int days) {
    return '$days 天以后的日子显示往年同期天气（过去 20 年平均值）。行程临近时会自动换成天气预报。';
  }

  @override
  String get weatherUnknown => '暂无数据';

  @override
  String get packingList => '行李清单';

  @override
  String get packingEmpty => '这样的天气无需特别准备。';

  @override
  String get packUmbrella => '雨伞';

  @override
  String get packRainJacket => '雨衣';

  @override
  String get packSunscreen => '防晒霜';

  @override
  String get packSunglasses => '太阳镜';

  @override
  String get packHat => '遮阳帽';

  @override
  String get packLightClothes => '轻薄透气的衣服';

  @override
  String get packWaterBottle => '可重复使用的水瓶';

  @override
  String get packWarmLayer => '保暖毛衣或抓绒衣';

  @override
  String get packCoat => '冬季外套';

  @override
  String get packGloves => '手套';

  @override
  String get packWindbreaker => '防风外套';

  @override
  String get packInsectRepellent => '驱蚊剂';

  @override
  String get shareTrip => '分享';

  @override
  String get tripReminder => '出发前一天提醒我';

  @override
  String get tripReminderDetail => '出发前一天傍晚发送通知，附上第一站的天气预报。';

  @override
  String tripReminderTitle(String place) {
    return '您的$place之旅明天开始';
  }

  @override
  String get tripReminderBodyFallback => '出发前请查看天气预报。';

  @override
  String tripOutlookRange(String low, String high) {
    return '$low 至 $high';
  }

  @override
  String tripRainyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天可能下雨',
      one: '1 天可能下雨',
      zero: '预计无雨',
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
    return '$day · $place：$condition，$min 至 $max，降雨概率 $rain%';
  }

  @override
  String shareTypicalDay(String day, String place, String min, String max) {
    return '$day · $place：往年 $min 至 $max';
  }

  @override
  String get sharedFromApp => '分享自 BWeather';

  @override
  String get privacyTripsTitle => '行程';

  @override
  String get privacyTripsBody =>
      '您规划的行程仅存储在此设备上。为获取天气，每一站的坐标和日期会发送给 Open-Meteo。';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'BWeather';

  @override
  String get navForecast => '予報';

  @override
  String get navLocations => '地点';

  @override
  String get navSettings => '設定';

  @override
  String get addCity => '都市を追加';

  @override
  String get searchHint => '都市を検索';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get close => '閉じる';

  @override
  String get retry => '再試行';

  @override
  String get keepTyping => '続けて入力してください…';

  @override
  String get searchFailed => '検索できませんでした。インターネット接続を確認して、もう一度お試しください。';

  @override
  String noPlacesMatch(String query) {
    return '「$query」に一致する地点はありません。';
  }

  @override
  String get welcomeTitle => 'BWeather へようこそ';

  @override
  String get welcomeSubtitle => '現在地と大切な場所の天気予報をお届けします。';

  @override
  String get useMyLocation => '現在地を使用';

  @override
  String get findingYou => '現在地を取得中…';

  @override
  String get openSettings => '設定を開く';

  @override
  String continueWith(String place) {
    return '$place で続ける';
  }

  @override
  String get approximateFromNetwork => 'ネットワークに基づくおおよその位置';

  @override
  String get searchForCity => '都市を検索';

  @override
  String get locationPrivacyNote => '位置情報は天気予報の取得にのみ使用されます。';

  @override
  String get locationServiceDisabled => '位置情報サービスがオフになっています。';

  @override
  String get locationPermissionDenied => '位置情報の権限が許可されませんでした。';

  @override
  String get locationPermissionBlocked => '位置情報の権限がブロックされています。設定で許可できます。';

  @override
  String get locationUnavailable => '現在地を取得できませんでした。';

  @override
  String get approximateBanner => 'ネットワークに基づくおおよその位置を表示しています。';

  @override
  String get usePrecise => '正確な位置を使用';

  @override
  String get noPlacesTitle => '地点がまだありません';

  @override
  String get noPlacesBody => '現在地を使用するか、都市を追加して天気予報を表示します。';

  @override
  String get noSavedPlaces => '保存した地点はまだありません。+ をタップして都市を追加してください。';

  @override
  String get yourLocation => '現在地';

  @override
  String get approximateLocation => 'おおよその位置';

  @override
  String removeCity(String city) {
    return '$city を削除';
  }

  @override
  String get reorderHint => '都市を長押ししてドラッグすると並べ替えられます。';

  @override
  String forecastLoadFailed(String city) {
    return '$city の天気予報を読み込めませんでした。';
  }

  @override
  String get forecastUnavailable => '天気予報を読み込めませんでした';

  @override
  String get forecastErrorNetwork => '気象サービスに接続できませんでした。接続を確認して、もう一度お試しください。';

  @override
  String get forecastErrorData =>
      '気象サービスから読み取れないデータが届きました。しばらくしてからもう一度お試しください。';

  @override
  String get couldNotRefresh => '更新できませんでした';

  @override
  String updatedAgo(String age) {
    return '$ageに更新';
  }

  @override
  String get ageJustNow => 'たった今';

  @override
  String ageMinutes(int count) {
    return '$count 分前';
  }

  @override
  String ageHours(int count) {
    return '$count 時間前';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 日前',
      one: '1 日前',
    );
    return '$_temp0';
  }

  @override
  String feelsLike(String temperature) {
    return '体感 $temperature';
  }

  @override
  String get rainChance => '降水確率';

  @override
  String windWithDirection(String direction) {
    return '風 $direction';
  }

  @override
  String get humidity => '湿度';

  @override
  String get daily => '日別';

  @override
  String get hourly => '時間別';

  @override
  String get today => '今日';

  @override
  String get now => '現在';

  @override
  String get windDirection => '風向';

  @override
  String get windGusts => '最大瞬間風速';

  @override
  String get rainToday => '今日の降水量';

  @override
  String get pressure => '気圧';

  @override
  String get cloudCover => '雲量';

  @override
  String get dewPoint => '露点';

  @override
  String get sunrise => '日の出';

  @override
  String get sunset => '日の入り';

  @override
  String semanticsCurrent(String temperature, String condition) {
    return '$temperature 度、$condition';
  }

  @override
  String semanticsDay(String day, String condition, String min, String max) {
    return '$day：$condition、$min から $max';
  }

  @override
  String semanticsRainChance(int percent) {
    return '降水確率 $percent%';
  }

  @override
  String get compassPoints =>
      '北,北北東,北東,東北東,東,東南東,南東,南南東,南,南南西,南西,西南西,西,西北西,北西,北北西';

  @override
  String get settingsGeneral => '一般';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get themeAuto => '自動';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get settingsLanguage => '言語';

  @override
  String get languageSystem => 'システムの設定';

  @override
  String get settingsTemperature => '気温';

  @override
  String get unitCelsius => '摂氏 (°C)';

  @override
  String get unitFahrenheit => '華氏 (°F)';

  @override
  String get settingsWindSpeed => '風速';

  @override
  String get unitKmh => 'キロメートル毎時 (km/h)';

  @override
  String get unitMph => 'マイル毎時 (mph)';

  @override
  String get unitMs => 'メートル毎秒 (m/s)';

  @override
  String get unitKnots => 'ノット (kn)';

  @override
  String get settingsPrecipitation => '降水量';

  @override
  String get unitMm => 'ミリメートル (mm)';

  @override
  String get unitInch => 'インチ (in)';

  @override
  String get settingsAbout => '情報';

  @override
  String get aboutApp => 'BWeather について';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfUse => '利用規約';

  @override
  String version(String version) {
    return 'バージョン $version';
  }

  @override
  String get aboutDescription =>
      'BWeather は、現在地と保存した地点の現在の天気と予報を表示します。Bsoft Limited のために Nobel が開発・保守しています。';

  @override
  String get aboutDataSources => 'データ提供元';

  @override
  String get aboutOpenMeteo =>
      '天気と地点検索：Open-Meteo (open-meteo.com)、CC BY 4.0 ライセンス。';

  @override
  String get aboutOsm => '地名：© OpenStreetMap contributors (Nominatim)、ODbL。';

  @override
  String get aboutIpapi => 'おおよその位置：ipapi.co。';

  @override
  String get aboutIcons => '天気アイコン：Bas Milius による Meteocons (MIT)。';

  @override
  String get privacyIntro =>
      'BWeather にはアカウント、広告、アクセス解析はありません。このページでは、どのデータが端末の外に送信されるのか、その理由を説明します。';

  @override
  String get privacyLocationTitle => '現在地';

  @override
  String get privacyLocationBody =>
      '許可した場合、アプリは端末の位置情報を読み取ります。座標は天気予報の取得のために Open-Meteo へ、地名の取得のために OpenStreetMap Nominatim へ送信されます。それ以外には送信されません。';

  @override
  String get privacyApproximateTitle => 'おおよその位置';

  @override
  String get privacyApproximateBody =>
      '正確な位置情報が使えない場合、アプリは ipapi.co に都市レベルのおおよその位置を問い合わせます。この要求に応答するため、ipapi.co はあなたの IP アドレスを確認します。';

  @override
  String get privacySearchTitle => '都市の検索';

  @override
  String get privacySearchBody =>
      '都市検索に入力したテキストは、一致する地点を探すために Open-Meteo のジオコーディングサービスへ送信されます。';

  @override
  String get privacyStorageTitle => '端末に保存されるデータ';

  @override
  String get privacyStorageBody =>
      '保存した都市、最新の予報、設定はこの端末にのみ保存されます。アプリをアンインストールすると削除されます。';

  @override
  String get privacyContactTitle => 'お問い合わせ';

  @override
  String get privacyContactBody =>
      'プライバシーに関するご質問は、アプリストアの掲載ページから Bsoft Limited にお問い合わせください。';

  @override
  String get termsIntro => 'BWeather を使用すると、これらの規約に同意したものとみなされます。';

  @override
  String get termsAccuracyTitle => '予報の精度';

  @override
  String get termsAccuracyBody =>
      '天気予報は推定であり、外れることがあります。安全に関わる判断を BWeather に頼らず、国の気象機関が発表する公式の警報に従ってください。';

  @override
  String get termsServiceTitle => 'サービス';

  @override
  String get termsServiceBody =>
      'BWeather は「現状のまま」提供され、いかなる保証もありません。機能は変更されることがあり、サービスを利用できない場合があります。';

  @override
  String get termsThirdPartyTitle => '第三者のデータ';

  @override
  String get termsThirdPartyBody =>
      '気象データは Open-Meteo、地名は OpenStreetMap から提供されています。これらのデータにはそれぞれの規約とライセンスが適用されます。';

  @override
  String legalLastUpdated(String date) {
    return '最終更新日：$date';
  }

  @override
  String get wmo0 => '快晴';

  @override
  String get wmo1 => '晴れ';

  @override
  String get wmo2 => '晴れ時々曇り';

  @override
  String get wmo3 => '曇り';

  @override
  String get wmo45 => '霧';

  @override
  String get wmo48 => '着氷性の霧';

  @override
  String get wmo51 => '弱い霧雨';

  @override
  String get wmo53 => '霧雨';

  @override
  String get wmo55 => '強い霧雨';

  @override
  String get wmo56 => '弱い着氷性の霧雨';

  @override
  String get wmo57 => '強い着氷性の霧雨';

  @override
  String get wmo61 => '弱い雨';

  @override
  String get wmo63 => '雨';

  @override
  String get wmo65 => '強い雨';

  @override
  String get wmo66 => '弱い着氷性の雨';

  @override
  String get wmo67 => '強い着氷性の雨';

  @override
  String get wmo71 => '弱い雪';

  @override
  String get wmo73 => '雪';

  @override
  String get wmo75 => '強い雪';

  @override
  String get wmo77 => '霧雪';

  @override
  String get wmo80 => '弱いにわか雨';

  @override
  String get wmo81 => 'にわか雨';

  @override
  String get wmo82 => '激しいにわか雨';

  @override
  String get wmo85 => '弱いにわか雪';

  @override
  String get wmo86 => '強いにわか雪';

  @override
  String get wmo95 => '雷雨';

  @override
  String get wmo96 => '雷雨（弱いひょう）';

  @override
  String get wmo99 => '雷雨（強いひょう）';

  @override
  String get wmoUnknown => '不明';

  @override
  String get pageNotFound => 'ページが見つかりません';

  @override
  String get airQuality => '大気質';

  @override
  String airQualityIndex(int value) {
    return '米国 AQI $value';
  }

  @override
  String get aqiGood => '良い';

  @override
  String get aqiModerate => '普通';

  @override
  String get aqiSensitive => '敏感な人には健康に悪い';

  @override
  String get aqiUnhealthy => '健康に悪い';

  @override
  String get aqiVeryUnhealthy => '非常に健康に悪い';

  @override
  String get aqiHazardous => '危険';

  @override
  String get pm25 => 'PM2.5';

  @override
  String get pm10 => 'PM10';

  @override
  String get dust => '黄砂・粉じん';

  @override
  String get uvIndex => 'UV インデックス';

  @override
  String get uvLow => '弱い';

  @override
  String get uvModerate => '中程度';

  @override
  String get uvHigh => '強い';

  @override
  String get uvVeryHigh => '非常に強い';

  @override
  String get uvExtreme => '極端に強い';

  @override
  String get pollen => '花粉';

  @override
  String get pollenAlder => 'ハンノキ';

  @override
  String get pollenBirch => 'シラカバ';

  @override
  String get pollenGrass => 'イネ科';

  @override
  String get pollenMugwort => 'ヨモギ';

  @override
  String get pollenOlive => 'オリーブ';

  @override
  String get pollenRagweed => 'ブタクサ';

  @override
  String get harmattanDustHint => '粉じんが多いです。屋外ではマスクの着用をおすすめします。';

  @override
  String get chart => 'グラフ';

  @override
  String get chartLegendTemperature => '気温';

  @override
  String get chartLegendRain => '降水確率';

  @override
  String get settingsNotifications => '通知';

  @override
  String get notifyMorningBrief => '朝のお知らせ';

  @override
  String get notifyMorningBriefDetail => '毎朝、現在地の今日の予報をお知らせします。';

  @override
  String get notifyBriefTime => '時刻';

  @override
  String get notifyRain => '雨のお知らせ';

  @override
  String get notifyRainDetail => '2 時間以内に雨が降りそうなときにお知らせします。';

  @override
  String get notifySevere => '荒天';

  @override
  String get notifySevereDetail => '雷雨、非常に強い風、猛暑。';

  @override
  String get notifyPermissionDenied => '端末の設定で BWeather の通知がオフになっています。';

  @override
  String get notifyUnsupported => '通知は Android アプリで利用できます。';

  @override
  String get notifyBackgroundNote => 'お知らせの確認は約 1 時間ごとのため、少し遅れて届くことがあります。';

  @override
  String get notifyChannelForecast => '天気予報';

  @override
  String get notifyChannelAlerts => '気象のお知らせ';

  @override
  String briefTitle(String place) {
    return '$place の今日の天気';
  }

  @override
  String briefBody(String condition, String min, String max, int rain) {
    return '$condition、$min〜$max。降水確率 $rain%。';
  }

  @override
  String rainAlertTitle(String place) {
    return '$place で雨の予報';
  }

  @override
  String rainAlertBody(int percent, String time) {
    return '$time ごろの降水確率は $percent% です。';
  }

  @override
  String severeThunderTitle(String place) {
    return '$place 付近で雷雨';
  }

  @override
  String severeThunderBody(String time) {
    return '$time ごろに雷雨が予想されます。できるだけ屋内にいてください。';
  }

  @override
  String severeWindTitle(String place) {
    return '$place で強風';
  }

  @override
  String severeWindBody(String speed) {
    return '今日は最大 $speed の突風が予想されます。';
  }

  @override
  String severeHeatTitle(String place) {
    return '$place で猛暑';
  }

  @override
  String severeHeatBody(String temperature) {
    return '今日は体感温度が $temperature になります。水分をとり、日中の日差しを避けてください。';
  }

  @override
  String get aboutCams => '大気質：コペルニクス大気監視サービスの情報を使用して生成（Open-Meteo 経由）。';

  @override
  String widgetRange(String max, String min) {
    return '最高 $max · 最低 $min';
  }

  @override
  String widgetUpdated(String time) {
    return '$time に更新';
  }

  @override
  String get tipsTitle => '今日のヒント';

  @override
  String tipUmbrella(int percent, String time) {
    return '傘を持っていきましょう：降水確率 $percent%、$time ごろが最も降りやすいです。';
  }

  @override
  String get tipClothesHot => '軽くて通気性のよい服装で。';

  @override
  String get tipClothesWarm => 'T シャツで過ごせる陽気です。';

  @override
  String get tipClothesMild => '薄手の上着を持っていきましょう。';

  @override
  String get tipClothesCool => '暖かい上着を着ましょう。';

  @override
  String get tipClothesCold => 'しっかり防寒を。外は寒いです。';

  @override
  String tipSunscreen(String level) {
    return '今日の紫外線は$levelです。10:00〜16:00 は日焼け止めと帽子を使いましょう。';
  }

  @override
  String tipHydrate(String temperature) {
    return '体感温度は $temperature になります。こまめに水分をとりましょう。';
  }

  @override
  String get tipLaundryGood => '洗濯物の外干し日和です。';

  @override
  String get tipLaundryBad => '洗濯物の外干しには向かない日です。';

  @override
  String tipBestOutdoorTime(String time) {
    return '外出におすすめの時間：$time ごろ。';
  }

  @override
  String get tipAirQuality => '大気質が悪いです。屋外での長時間や激しい運動は控えましょう。';

  @override
  String get tipMosquitoes => '暖かく湿った夜です。蚊が多そうなので虫よけや蚊帳を使いましょう。';

  @override
  String tipDriveFog(String time) {
    return '運転に注意：$time ごろに霧が予想されます。';
  }

  @override
  String tipDriveRain(String time) {
    return '運転に注意：$time ごろに強い雨が予想されます。';
  }

  @override
  String get refresh => '更新';

  @override
  String get settingsDisplay => '表示とデータ';

  @override
  String get settingsAnimatedBackground => 'アニメーション背景';

  @override
  String get settingsAnimatedBackgroundDetail =>
      '予報の背景に動く空を表示します。端末でアニメーションを減らす設定がオンのときは静止します。';

  @override
  String get settingsMinuteRain => '分単位の雨';

  @override
  String get settingsMinuteRainDetail =>
      '今後 2 時間の雨を 15 分ごとに表示します。データ使用量が少し増えます。';

  @override
  String get settingsCrashReports => 'クラッシュレポートを送信';

  @override
  String get settingsCrashReportsDetail =>
      '不具合の修正に役立つ匿名のエラー情報です。位置情報や個人データは含まれません。';

  @override
  String get nextTwoHours => '今後 2 時間';

  @override
  String rainStartingIn(int minutes) {
    return '約 $minutes 分後に雨が降り始めます';
  }

  @override
  String rainStoppingIn(int minutes) {
    return '約 $minutes 分後に雨がやみます';
  }

  @override
  String get rainContinuing => '少なくとも今後 2 時間は雨が続きます';

  @override
  String get noRainSoon => '今後 2 時間は雨の予報はありません';

  @override
  String get tempAboutNormal => '平年並み';

  @override
  String tempWarmerThanUsual(int degrees) {
    return '平年より $degrees° 高い';
  }

  @override
  String tempCoolerThanUsual(int degrees) {
    return '平年より $degrees° 低い';
  }

  @override
  String tempNormalsSource(String fromYear, String toYear) {
    return '今日の最高気温を、$fromYear〜$toYear 年の同じ日の平均最高気温と比較しています。';
  }

  @override
  String get radar => '雨雲レーダー';

  @override
  String get radarUnavailable => '現在レーダーを利用できません。';

  @override
  String get radarNoCoverage => 'レーダーは過去 2 時間を表示します。地域によっては観測範囲が限られるか、対象外です。';

  @override
  String get play => '再生';

  @override
  String get pause => '一時停止';

  @override
  String get aboutRainViewer =>
      'レーダー：気象データ提供 RainViewer、地図 © OpenStreetMap contributors。';

  @override
  String get privacyRadarTitle => 'レーダー地図';

  @override
  String get privacyRadarBody =>
      'レーダーを開くと、表示している範囲の地図タイルを OpenStreetMap から、レーダー画像を RainViewer からダウンロードします。一般的なウェブサイトと同様に、これらのサービスにはあなたの IP アドレスが見えます。';

  @override
  String get privacyCrashTitle => 'クラッシュレポート';

  @override
  String get privacyCrashBody =>
      'アプリがクラッシュした場合、修正のために匿名のエラーレポート（端末のモデル、OS のバージョン、アプリのバージョン、エラー内容）が Sentry に送信されることがあります。位置情報、保存した地点、IP アドレスが含まれることはありません。設定でオフにできます。';

  @override
  String get aboutHistory => '気候の平均値：Open-Meteo 過去の気象データ API (ERA5)。';

  @override
  String get zoomIn => '拡大';

  @override
  String get zoomOut => '縮小';

  @override
  String get settingsAppearance => '外観';

  @override
  String get settingsUnits => '単位';

  @override
  String get settingsPrivacy => 'プライバシー';

  @override
  String cityRemoved(String city) {
    return '$city を削除しました';
  }

  @override
  String get undo => '元に戻す';

  @override
  String get sunAndMoon => '太陽と月';

  @override
  String get daylight => '昼の長さ';

  @override
  String daylightDuration(int hours, int minutes) {
    return '$hours 時間 $minutes 分';
  }

  @override
  String get moonNew => '新月';

  @override
  String get moonWaxingCrescent => '三日月';

  @override
  String get moonFirstQuarter => '上弦の月';

  @override
  String get moonWaxingGibbous => '十三夜月';

  @override
  String get moonFull => '満月';

  @override
  String get moonWaningGibbous => '寝待月';

  @override
  String get moonLastQuarter => '下弦の月';

  @override
  String get moonWaningCrescent => '有明月';

  @override
  String moonIllumination(int percent) {
    return '輝面比 $percent%';
  }

  @override
  String get navTrips => '旅行';

  @override
  String get tripsEmptyTitle => '旅行はまだありません';

  @override
  String get tripsEmptyBody => '旅行を計画すると、各立ち寄り先の天気を日ごとに確認できます。';

  @override
  String get planTrip => '旅行を計画';

  @override
  String get newTrip => '新しい旅行';

  @override
  String get editTrip => '旅行を編集';

  @override
  String get tripName => '旅行の名前';

  @override
  String get tripNameHint => '例：アブジャでクリスマス';

  @override
  String tripDefaultName(String place) {
    return '$place への旅行';
  }

  @override
  String get tripStops => '立ち寄り先';

  @override
  String get addStop => '立ち寄り先を追加';

  @override
  String get removeStop => '立ち寄り先を削除';

  @override
  String get chooseDates => '日付を選択';

  @override
  String get save => '保存';

  @override
  String get deleteTrip => '旅行を削除';

  @override
  String get tripDeleted => '旅行を削除しました';

  @override
  String get tripProblemNoStops => '立ち寄り先を 1 つ以上追加してください。';

  @override
  String get tripProblemOrder => '各立ち寄り先は、前の立ち寄り先が終わる日以降に始まる必要があります。';

  @override
  String tripProblemTooLong(int days) {
    return '旅行の期間は最長 $days 日です。';
  }

  @override
  String tripStartsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 日後に出発',
      one: '明日出発',
      zero: '今日出発',
    );
    return '$_temp0';
  }

  @override
  String get tripOngoing => '旅行中';

  @override
  String get tripEnded => '終了';

  @override
  String tripDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 日間',
      one: '1 日間',
    );
    return '$_temp0';
  }

  @override
  String travelDay(String place) {
    return '$place からの移動日';
  }

  @override
  String get typicalWeather => '例年の天気';

  @override
  String typicalWeatherNote(int days) {
    return '$days 日以上先の日は、その日付の例年の天気（過去 20 年の平均）を表示します。旅行が近づくと自動的に天気予報に切り替わります。';
  }

  @override
  String get weatherUnknown => 'データがまだありません';

  @override
  String get packingList => '持ち物リスト';

  @override
  String get packingEmpty => 'この天気なら特別な持ち物は必要ありません。';

  @override
  String get packUmbrella => '傘';

  @override
  String get packRainJacket => 'レインジャケット';

  @override
  String get packSunscreen => '日焼け止め';

  @override
  String get packSunglasses => 'サングラス';

  @override
  String get packHat => '日よけ帽子';

  @override
  String get packLightClothes => '軽くて通気性のよい服';

  @override
  String get packWaterBottle => 'マイボトル';

  @override
  String get packWarmLayer => '暖かいセーターやフリース';

  @override
  String get packCoat => '冬用コート';

  @override
  String get packGloves => '手袋';

  @override
  String get packWindbreaker => 'ウインドブレーカー';

  @override
  String get packInsectRepellent => '虫よけ';

  @override
  String get shareTrip => '共有';

  @override
  String get tripReminder => '前日にお知らせ';

  @override
  String get tripReminderDetail => '出発前日の夕方に、最初の立ち寄り先の天気予報をお知らせします。';

  @override
  String tripReminderTitle(String place) {
    return '$place への旅行は明日からです';
  }

  @override
  String get tripReminderBodyFallback => '出発前に天気予報を確認しましょう。';

  @override
  String tripOutlookRange(String low, String high) {
    return '$low〜$high';
  }

  @override
  String tripRainyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 日は雨の可能性',
      one: '1 日は雨の可能性',
      zero: '雨の予報なし',
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
    return '$day · $place：$condition、$min〜$max、降水確率 $rain%';
  }

  @override
  String shareTypicalDay(String day, String place, String min, String max) {
    return '$day · $place：例年 $min〜$max';
  }

  @override
  String get sharedFromApp => 'BWeather から共有';

  @override
  String get privacyTripsTitle => '旅行';

  @override
  String get privacyTripsBody =>
      '計画した旅行はこの端末にのみ保存されます。天気を取得するため、各立ち寄り先の座標と日付が Open-Meteo に送信されます。';
}

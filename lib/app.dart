import 'dart:async';

import 'package:bweather/l10n/fallback_localizations.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/screens/cities.dart';
import 'package:bweather/services/alert_scheduler.dart';
import 'package:bweather/services/notification_service.dart';
import 'package:bweather/screens/info.dart';
import 'package:bweather/screens/legal.dart';
import 'package:bweather/screens/main.dart';
import 'package:bweather/screens/not_found.dart';
import 'package:bweather/screens/onboarding.dart';
import 'package:bweather/screens/radar.dart';
import 'package:bweather/screens/city_picker.dart';
import 'package:bweather/screens/trips/trip_detail.dart';
import 'package:bweather/screens/trips/trip_editor.dart';
import 'package:bweather/states/trips/trips_cubit.dart';
import 'package:bweather/states/cities_cubit.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/main_cubit.dart';
import 'package:bweather/states/settings_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:bweather/utils/day_night.dart';
import 'package:bweather/utils/theme.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Root widget: one shared repository, then the cubits, then the MaterialApp.
class App extends StatelessWidget {
    const App({ super.key });

    @override
    Widget build(BuildContext context) {
        return MultiRepositoryProvider(
            providers: [
                RepositoryProvider(create: (_) => ForecastRepository()),
                RepositoryProvider(create: (_) => NotificationService()),
            ],
            child: BlocProvider(
                create: (_) => SettingsCubit(),
                child: MultiBlocProvider(
                    providers: [
                        BlocProvider(create: (context) => CitiesCubit(repository: context.read<ForecastRepository>())),
                        BlocProvider(create: (_) => MainCubit()),
                        BlocProvider(create: (context) => WeatherCubit(context.read<SettingsCubit>(), repository: context.read<ForecastRepository>()), lazy: false),
                        BlocProvider(create: (context) => TripsCubit(context.read<SettingsCubit>(), repository: context.read<ForecastRepository>()), lazy: false),
                    ],
                    child: const _AlertsSync(child: BWeather()),
                ),
            ),
        );
    }
}

class BWeather extends StatelessWidget {
    const BWeather({ super.key });

    @override
    Widget build(BuildContext context) {
        // Inter for text, Outfit for headings and big numbers: clean and easy to read.
        final theme = MaterialTheme(createTextTheme(context, body: GoogleFonts.inter, display: GoogleFonts.outfit));

        return _DayNightClock(builder: (context, isDay) => BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) => previous.themeMode != current.themeMode || previous.languageCode != current.languageCode,
            builder: (context, prefs) {
                return MaterialApp(
                    onGenerateTitle: (context) => context.l10n.appTitle,
                    debugShowCheckedModeBanner: false,
                    theme: theme.light(),
                    darkTheme: theme.dark(),
                    themeMode: prefs.themeModeFor(isDay: isDay),
                    locale: prefs.locale,
                    // Fallbacks first: they only claim languages Flutter has no strings for.
                    // GlobalMaterialLocalizations.delegates (material_ui) also brings the
                    // Cupertino and Widgets delegates. The generated
                    // AppLocalizations.localizationsDelegates is not used: it still lists the
                    // deprecated SDK delegates.
                    localizationsDelegates: [
                        ...fallbackLocalizationsDelegates,
                        AppLocalizations.delegate,
                        ...GlobalMaterialLocalizations.delegates,
                    ],
                    supportedLocales: AppLocalizations.supportedLocales,
                    initialRoute: MainScreen.routeName,
                    builder: (context, child) => ResponsiveBreakpoints.builder(
                        // Material 3 window classes: compact < 600 (phones, narrow windows),
                        // medium 600–1023 (tablets, half-screen windows), expanded ≥ 1024.
                        breakpoints: [
                            const Breakpoint(start: 0, end: 599, name: MOBILE),
                            const Breakpoint(start: 600, end: 1023, name: TABLET),
                            const Breakpoint(start: 1024, end: double.infinity, name: DESKTOP),
                        ],
                        child: child!,
                    ),
                    onGenerateRoute: (settings) => MaterialPageRoute(
                        settings: settings,
                        builder: (context) => switch (settings.name) {
                            MainScreen.routeName => const _OnboardingGate(child: MainScreen()),
                            CitiesScreen.routeName => const CitiesScreen(),
                            Info.routeName => const Info(),
                            LegalScreen.privacyRoute => const LegalScreen(document: LegalDocument.privacy),
                            LegalScreen.termsRoute => const LegalScreen(document: LegalDocument.terms),
                            RadarScreen.routeName when settings.arguments is RadarTarget => RadarScreen(target: settings.arguments! as RadarTarget),
                            CityPickerScreen.routeName => const CityPickerScreen(),
                            TripEditorScreen.routeName => TripEditorScreen(tripId: settings.arguments as String?),
                            TripDetailScreen.routeName when settings.arguments is String => TripDetailScreen(tripId: settings.arguments! as String),
                            _ => const NotFound(),
                        },
                    ),
                );
            },
        ));
    }
}

/// Tells [builder] whether it is daytime for the user (for the "Auto" theme),
/// using the sun at their location. Checks every minute and when the app
/// comes back to the foreground.
class _DayNightClock extends StatefulWidget {
    final Widget Function(BuildContext context, bool isDay) builder;

    const _DayNightClock({ required this.builder });

    @override
    State<_DayNightClock> createState() => _DayNightClockState();
}

class _DayNightClockState extends State<_DayNightClock> with WidgetsBindingObserver {
    Timer? _timer;
    DateTime _now = DateTime.now();

    @override
    void initState() {
        super.initState();
        WidgetsBinding.instance.addObserver(this);
        _timer = Timer.periodic(const Duration(minutes: 1), (_) => _tick());
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
        if (state == AppLifecycleState.resumed) _tick();
    }

    void _tick() {
        if (mounted) setState(() => _now = DateTime.now());
    }

    @override
    void dispose() {
        _timer?.cancel();
        WidgetsBinding.instance.removeObserver(this);
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final position = context.select<WeatherCubit, (double, double)?>((cubit) {
            final city = cubit.state.location?.city;
            return city == null ? null : (city.latitude, city.longitude);
        });
        final isDay = DayNight.isDay(_now, latitude: position?.$1, longitude: position?.$2);
        return widget.builder(context, isDay);
    }
}

/// Shows the welcome screen until the user has picked a location or a city.
class _OnboardingGate extends StatelessWidget {
    final Widget child;

    const _OnboardingGate({ required this.child });

    @override
    Widget build(BuildContext context) {
        return BlocSelector<WeatherCubit, WeatherState, bool>(
            selector: (state) => state.onboarded,
            builder: (context, onboarded) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: onboarded ? child : const Onboarding(),
            ),
        );
    }
}

/// Keeps background weather alerts in sync with settings and saved places.
class _AlertsSync extends StatefulWidget {
    final Widget child;

    const _AlertsSync({ required this.child });

    @override
    State<_AlertsSync> createState() => _AlertsSyncState();
}

class _AlertsSyncState extends State<_AlertsSync> {
    late final AlertScheduler _scheduler;

    @override
    void initState() {
        super.initState();
        _scheduler = AlertScheduler(context.read<SettingsCubit>(), context.read<WeatherCubit>(), trips: context.read<TripsCubit>())..start();
    }

    @override
    void dispose() {
        _scheduler.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) => widget.child;
}

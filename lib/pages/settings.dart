import 'package:bweather/components/settings_tiles.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/screens/info.dart';
import 'package:bweather/screens/legal.dart';
import 'package:bweather/services/alerts.dart';
import 'package:bweather/services/crash_reporting.dart';
import 'package:bweather/services/notification_service.dart';
import 'package:bweather/states/settings_cubit.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Language names are shown in their own language on purpose.
const _languageNames = {
    "en": "English",
    "fr": "Français",
    "es": "Español",
    "zh": "中文（简体）",
    "ja": "日本語",
    "ha": "Hausa",
    "yo": "Yorùbá",
    "ig": "Igbo",
};

class Settings extends StatelessWidget {
    const Settings({ super.key });

    /// Keeps lines readable on tablets and desktop windows.
    static const maxContentWidth = 720.0;

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final cubit = context.read<SettingsCubit>();

        return CustomScrollView(
            slivers: [
                SliverAppBar.large(
                    automaticallyImplyLeading: false,
                    title: Text(l10n.navSettings),
                ),
                SliverToBoxAdapter(
                    child: Center(
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: maxContentWidth),
                            child: BlocBuilder<SettingsCubit, SettingsState>(
                                builder: (context, state) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                    const SizedBox(height: 8),
                                    SettingsSection(title: l10n.settingsAppearance, footer: state.themeMode == "auto" ? l10n.themeAutoHint : null, children: [
                                        SettingsSegmentedTile<String>(
                                            icon: Icons.contrast,
                                            color: SettingsColors.indigo,
                                            title: l10n.settingsTheme,
                                            value: state.themeMode,
                                            onChanged: (value) => cubit.themeMode = value,
                                            options: {
                                                "auto": (l10n.themeAuto, null),
                                                "light": (l10n.themeLight, null),
                                                "dark": (l10n.themeDark, null),
                                            },
                                        ),
                                        SettingsTile(
                                            icon: Icons.translate,
                                            color: SettingsColors.blue,
                                            title: l10n.settingsLanguage,
                                            value: _languageNames[state.languageCode] ?? l10n.languageSystem,
                                            onTap: () async {
                                                final picked = await showChoiceSheet<String>(
                                                    context,
                                                    title: l10n.settingsLanguage,
                                                    value: state.languageCode,
                                                    options: {"": l10n.languageSystem, ..._languageNames},
                                                );
                                                if (picked != null) cubit.languageCode = picked;
                                            },
                                        ),
                                        SettingsSwitchTile(
                                            icon: Icons.auto_awesome,
                                            color: SettingsColors.pink,
                                            title: l10n.settingsAnimatedBackground,
                                            subtitle: l10n.settingsAnimatedBackgroundDetail,
                                            value: state.animatedBackground,
                                            onChanged: (value) => cubit.animatedBackground = value,
                                        ),
                                    ]),
                                    SettingsSection(title: l10n.settingsUnits, children: [
                                        SettingsSegmentedTile<TempUnit>(
                                            icon: Icons.thermostat,
                                            color: SettingsColors.orange,
                                            title: l10n.settingsTemperature,
                                            value: state.tempUnit,
                                            onChanged: (value) => cubit.tempUnit = value,
                                            options: {
                                                TempUnit.celsius: ("°C", l10n.unitCelsius),
                                                TempUnit.fahrenheit: ("°F", l10n.unitFahrenheit),
                                            },
                                        ),
                                        SettingsSegmentedTile<WindSpeedUnit>(
                                            icon: Icons.air,
                                            color: SettingsColors.teal,
                                            title: l10n.settingsWindSpeed,
                                            value: state.windSpeedUnit,
                                            onChanged: (value) => cubit.windSpeedUnit = value,
                                            options: {
                                                WindSpeedUnit.kmh: ("km/h", l10n.unitKmh),
                                                WindSpeedUnit.mph: ("mph", l10n.unitMph),
                                                WindSpeedUnit.ms: ("m/s", l10n.unitMs),
                                                WindSpeedUnit.kn: ("kn", l10n.unitKnots),
                                            },
                                        ),
                                        SettingsSegmentedTile<PrecipitationUnit>(
                                            icon: Icons.water_drop_outlined,
                                            color: SettingsColors.blue,
                                            title: l10n.settingsPrecipitation,
                                            value: state.precipitationUnit,
                                            onChanged: (value) => cubit.precipitationUnit = value,
                                            options: {
                                                PrecipitationUnit.mm: ("mm", l10n.unitMm),
                                                PrecipitationUnit.inch: ("in", l10n.unitInch),
                                            },
                                        ),
                                    ]),
                                    SettingsSection(title: l10n.navForecast, children: [
                                        SettingsSwitchTile(
                                            icon: Icons.grain,
                                            color: SettingsColors.indigo,
                                            title: l10n.settingsMinuteRain,
                                            subtitle: l10n.settingsMinuteRainDetail,
                                            value: state.minuteRain,
                                            onChanged: (value) => cubit.minuteRain = value,
                                        ),
                                    ]),
                                    _NotificationsSection(prefs: state.alerts),
                                    // Only builds made with a Sentry DSN can send reports.
                                    if (CrashReporting.available)
                                        SettingsSection(title: l10n.settingsPrivacy, children: [
                                            SettingsSwitchTile(
                                                icon: Icons.bug_report_outlined,
                                                color: SettingsColors.grey,
                                                title: l10n.settingsCrashReports,
                                                subtitle: l10n.settingsCrashReportsDetail,
                                                value: state.crashReports,
                                                onChanged: (value) => cubit.crashReports = value,
                                            ),
                                        ]),
                                    SettingsSection(title: l10n.settingsAbout, children: [
                                        SettingsTile(
                                            icon: Icons.info_outline,
                                            color: SettingsColors.blue,
                                            title: l10n.aboutApp,
                                            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                                AppVersionText(style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                                Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                            ]),
                                            onTap: () => Navigator.of(context).pushNamed(Info.routeName),
                                        ),
                                        SettingsTile(
                                            icon: Icons.privacy_tip_outlined,
                                            color: SettingsColors.green,
                                            title: l10n.privacyPolicy,
                                            onTap: () => Navigator.of(context).pushNamed(LegalScreen.privacyRoute),
                                        ),
                                        SettingsTile(
                                            icon: Icons.gavel_outlined,
                                            color: SettingsColors.grey,
                                            title: l10n.termsOfUse,
                                            onTap: () => Navigator.of(context).pushNamed(LegalScreen.termsRoute),
                                        ),
                                    ]),
                                    const SizedBox(height: 16),
                                ]),
                            ),
                        ),
                    ),
                ),
            ],
        );
    }
}

/// Opt-in switches for the morning briefing and weather alerts.
class _NotificationsSection extends StatelessWidget {
    final AlertPrefs prefs;

    const _NotificationsSection({ required this.prefs });

    /// Turning an alert on first asks for notification permission.
    Future<void> _update(BuildContext context, AlertPrefs updated, { required bool turningOn }) async {
        final cubit = context.read<SettingsCubit>();
        if (turningOn && !prefs.anyEnabled) {
            final messenger = ScaffoldMessenger.of(context);
            final message = context.l10n.notifyPermissionDenied;
            final granted = await context.read<NotificationService>().requestPermission();
            if (!granted) {
                messenger.showSnackBar(SnackBar(content: Text(message)));
                return;
            }
        }
        cubit.alerts = updated;
    }

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;

        if (!NotificationService.isSupported) {
            return SettingsSection(title: l10n.settingsNotifications, children: [
                SettingsTile(icon: Icons.notifications_off_outlined, color: SettingsColors.grey, title: l10n.notifyUnsupported),
            ]);
        }

        final times = {
            for (int hour = 5; hour <= 10; hour++)
                hour: MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay(hour: hour, minute: 0)),
        };

        return SettingsSection(
            title: l10n.settingsNotifications,
            footer: l10n.notifyBackgroundNote,
            children: [
                SettingsSwitchTile(
                    icon: Icons.wb_sunny_outlined,
                    color: SettingsColors.orange,
                    title: l10n.notifyMorningBrief,
                    subtitle: l10n.notifyMorningBriefDetail,
                    value: prefs.morningBrief,
                    onChanged: (value) => _update(context, prefs.copy(morningBrief: value), turningOn: value),
                ),
                if (prefs.morningBrief)
                    SettingsTile(
                        icon: Icons.schedule,
                        color: SettingsColors.orange,
                        title: l10n.notifyBriefTime,
                        value: times[prefs.briefHour],
                        onTap: () async {
                            final cubit = context.read<SettingsCubit>();
                            final hour = await showChoiceSheet<int>(context, title: l10n.notifyBriefTime, options: times, value: prefs.briefHour);
                            if (hour != null) cubit.alerts = prefs.copy(briefHour: hour);
                        },
                    ),
                SettingsSwitchTile(
                    icon: Icons.umbrella_outlined,
                    color: SettingsColors.blue,
                    title: l10n.notifyRain,
                    subtitle: l10n.notifyRainDetail,
                    value: prefs.rain,
                    onChanged: (value) => _update(context, prefs.copy(rain: value), turningOn: value),
                ),
                SettingsSwitchTile(
                    icon: Icons.thunderstorm_outlined,
                    color: SettingsColors.red,
                    title: l10n.notifySevere,
                    subtitle: l10n.notifySevereDetail,
                    value: prefs.severe,
                    onChanged: (value) => _update(context, prefs.copy(severe: value), turningOn: value),
                ),
            ],
        );
    }
}

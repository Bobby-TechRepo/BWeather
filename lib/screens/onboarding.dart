import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/l10n/messages.dart';
import 'package:bweather/screens/cities.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:bweather/utils/status.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

/// First-run welcome screen. Replaces the old behaviour of closing the app
/// when location permission was denied.
class Onboarding extends StatelessWidget {
    const Onboarding({ super.key });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final cubit = context.read<WeatherCubit>();
        final l10n = context.l10n;

        return Scaffold(
            backgroundColor: colors.surface,
            body: SafeArea(
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: BlocBuilder<WeatherCubit, WeatherState>(
                                builder: (context, state) {
                                    final approximate = state.location;
                                    final busy = state.status.isLoading;
                                    final blocked = state.locationIssue == LocationIssue.permissionDeniedForever
                                        || state.locationIssue == LocationIssue.serviceDisabled;

                                    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                        Lottie.asset("files/animations/Animation - 1730523394311.json", height: 220),
                                        const SizedBox(height: 16),
                                        Text(l10n.welcomeTitle, textAlign: TextAlign.center, style: theme.textTheme.headlineMedium?.copyWith(color: colors.primary)),
                                        const SizedBox(height: 8),
                                        Text(
                                            l10n.welcomeSubtitle,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
                                        ),
                                        const SizedBox(height: 32),
                                        FilledButton.icon(
                                            onPressed: busy ? null : cubit.useMyLocation,
                                            icon: busy
                                                ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                                : const Icon(Icons.my_location),
                                            label: Text(busy ? l10n.findingYou : l10n.useMyLocation),
                                        ),
                                        if (state.locationIssue != LocationIssue.none) ...[
                                            const SizedBox(height: 8),
                                            Text(l10n.locationIssue(state.locationIssue), textAlign: TextAlign.center, style: TextStyle(color: colors.error)),
                                            if (blocked)
                                                TextButton(onPressed: cubit.openLocationSettings, child: Text(l10n.openSettings)),
                                        ],
                                        if (approximate != null) ...[
                                            const SizedBox(height: 12),
                                            OutlinedButton(
                                                onPressed: cubit.completeOnboarding,
                                                child: Text(
                                                    l10n.continueWith(approximate.city.country.isEmpty ? approximate.city.name : "${approximate.city.name}, ${approximate.city.country}"),
                                                    textAlign: TextAlign.center,
                                                ),
                                            ),
                                            if (approximate.approximate)
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 4),
                                                    child: Text(l10n.approximateFromNetwork, textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                                                ),
                                        ],
                                        const SizedBox(height: 12),
                                        TextButton.icon(
                                            onPressed: () => Navigator.of(context).pushNamed(CitiesScreen.routeName),
                                            icon: const Icon(Icons.search),
                                            label: Text(l10n.searchForCity),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                            l10n.locationPrivacyNote,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                                        ),
                                    ]);
                                },
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}

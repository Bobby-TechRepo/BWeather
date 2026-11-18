import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/components/city.dart';
import 'package:bweather/states/cities_cubit.dart';
import 'package:bweather/utils/status.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The built-in capitals (and [quick] shortcuts) until the user types, then
/// live results in a card, with loading, empty and error states.
class CitiesView extends StatelessWidget {
    final OnCitySelected onSelected;
    final List<QuickPlace> quick;

    /// Ids of places already in Locations; they get a tick.
    final Set<String> savedIds;

    const CitiesView({ super.key, required this.onSelected, this.quick = const [], this.savedIds = const {} });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final l10n = context.l10n;

        return BlocBuilder<CitiesCubit, CitiesState>(
            builder: (context, state) {
                if (!state.isSearching) {
                    return CityList(onSelected: onSelected, quick: quick, savedIds: savedIds);
                }

                if (state.query.trim().length < CitiesCubit.minQueryLength) {
                    return _Message(icon: Icons.keyboard_outlined, text: l10n.keepTyping, color: colors.onSurfaceVariant);
                }

                if (state.status.isFailure) {
                    return _Message(
                        icon: Icons.cloud_off_outlined,
                        text: l10n.searchFailed,
                        color: colors.error,
                        action: FilledButton.tonalIcon(
                            onPressed: () => context.read<CitiesCubit>().search(state.query),
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retry),
                        ),
                    );
                }

                if (state.status.isSuccess && state.searchResults.isEmpty) {
                    return _Message(icon: Icons.search_off, text: l10n.noPlacesMatch(state.query.trim()), color: colors.onSurfaceVariant);
                }

                // First results still on their way: placeholder rows.
                if (state.searchResults.isEmpty) {
                    return const _LoadingRows();
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    SizedBox(height: 2, child: state.status.isLoading ? const LinearProgressIndicator(minHeight: 2) : null),
                    const SizedBox(height: 8),
                    Expanded(
                        child: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
                            PlaceGroup(children: [
                                for (final city in state.searchResults)
                                    CityTile(
                                        name: city.name,
                                        subtitle: city.subtitle,
                                        saved: savedIds.contains(city.id),
                                        onTap: () => onSelected(city),
                                    ),
                            ]),
                        ]),
                    ),
                ]);
            },
        );
    }
}

class _Message extends StatelessWidget {
    final IconData icon;
    final String text;
    final Color color;
    final Widget? action;

    const _Message({ required this.icon, required this.text, required this.color, this.action });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        return Center(
            child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHigh, shape: BoxShape.circle),
                        child: Icon(icon, size: 34, color: color),
                    ),
                    const SizedBox(height: 16),
                    Text(text, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge?.copyWith(color: color)),
                    if (action != null) ...[const SizedBox(height: 16), action!],
                ]),
            ),
        );
    }
}

/// Grey rows shown while the first search results load.
class _LoadingRows extends StatelessWidget {
    const _LoadingRows();

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        Widget bar(double width, double height) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: colors.surfaceContainerHighest, borderRadius: BorderRadius.circular(6)),
        );

        return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
                alignment: Alignment.topCenter,
                child: PlaceGroup(children: [
                    for (int i = 0; i < 4; i++)
                        Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(children: [
                                Container(width: 40, height: 40, decoration: BoxDecoration(color: colors.surfaceContainerHighest, shape: BoxShape.circle)),
                                const SizedBox(width: 14),
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    bar(140.0 - i * 12, 14),
                                    const SizedBox(height: 8),
                                    bar(90, 10),
                                ]),
                            ]),
                        ),
                ]),
            ),
        );
    }
}

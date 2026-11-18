import 'package:bweather/components/location.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Saved places as slivers: the user's location pinned on top, then saved
/// cities. Cities can be reordered (long-press and drag), swiped away, or
/// removed from their menu; removing shows an "Undo" snackbar.
///
/// [headerSlivers] go above the list (app bar, search field). Rebuilds only
/// when places are added, removed or moved; each card listens to its own place.
class LocationList extends StatelessWidget {
    final List<Widget> headerSlivers;
    final ScrollController? scrollController;

    /// Narrow cards for the desktop side panel.
    final bool compact;

    /// Cards never get wider than this; extra room becomes side margins.
    static const maxCardWidth = 720.0;

    const LocationList({ super.key, this.headerSlivers = const [], this.scrollController, this.compact = false });

    static void remove(BuildContext context, String key) {
        final cubit = context.read<WeatherCubit>();
        final index = cubit.state.cities.indexWhere((city) => city.key == key);
        if (index == -1) return;
        final place = cubit.state.cities[index];
        final l10n = context.l10n;
        final messenger = ScaffoldMessenger.of(context);

        cubit.removeCity(key);
        messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(l10n.cityRemoved(place.city.name)),
                action: SnackBarAction(label: l10n.undo, onPressed: () => cubit.restoreCity(place, index)),
            ));
    }

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);

        return BlocSelector<WeatherCubit, WeatherState, String>(
            // "<location key>#<city key>|<city key>|..."
            selector: (state) => "${state.location?.key ?? ""}#${state.cities.map((city) => city.key).join("|")}",
            builder: (context, encoded) {
                final parts = encoded.split("#");
                final locationKey = parts.first;
                final cityKeys = parts.last.isEmpty ? const <String>[] : parts.last.split("|");
                final gap = compact ? 10.0 : 14.0;

                return LayoutBuilder(builder: (context, constraints) {
                    final side = compact ? 12.0 : ((constraints.maxWidth - maxCardWidth) / 2).clamp(16.0, double.infinity).toDouble();

                    return CustomScrollView(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                            ...headerSlivers,
                            if (locationKey.isEmpty && cityKeys.isEmpty)
                                SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(Icons.travel_explore, size: 56, color: theme.colorScheme.primary),
                                            const SizedBox(height: 12),
                                            Text(l10n.noSavedPlaces, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
                                        ]),
                                    ),
                                ),
                            if (locationKey.isNotEmpty)
                                SliverPadding(
                                    padding: EdgeInsets.fromLTRB(side, 0, side, gap),
                                    sliver: SliverToBoxAdapter(child: LocationItem(placeKey: locationKey, compact: compact)),
                                ),
                            SliverPadding(
                                padding: EdgeInsets.symmetric(horizontal: side),
                                sliver: SliverReorderableList(
                                    itemCount: cityKeys.length,
                                    onReorderItem: context.read<WeatherCubit>().reorderCity,
                                    proxyDecorator: (child, index, animation) => AnimatedBuilder(
                                        animation: animation,
                                        builder: (context, child) => Transform.scale(scale: 1 + 0.03 * animation.value, child: child),
                                        child: Material(type: MaterialType.transparency, child: child),
                                    ),
                                    itemBuilder: (context, index) {
                                        final key = cityKeys[index];
                                        return ReorderableDelayedDragStartListener(
                                            key: ValueKey(key),
                                            index: index,
                                            child: Padding(
                                                padding: EdgeInsets.only(bottom: gap),
                                                child: Dismissible(
                                                    key: ValueKey("dismiss-$key"),
                                                    direction: DismissDirection.endToStart,
                                                    background: const _DeleteBackground(),
                                                    onDismissed: (_) => remove(context, key),
                                                    child: LocationItem(placeKey: key, compact: compact, onRemove: () => remove(context, key)),
                                                ),
                                            ),
                                        );
                                    },
                                ),
                            ),
                            if (cityKeys.length > 1)
                                SliverToBoxAdapter(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                                        child: Text(l10n.reorderHint, textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                                    ),
                                ),
                            const SliverToBoxAdapter(child: SizedBox(height: 24)),
                        ],
                    );
                });
            },
        );
    }
}

class _DeleteBackground extends StatelessWidget {
    const _DeleteBackground();

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        return DecoratedBox(
            decoration: BoxDecoration(color: colors.error, borderRadius: BorderRadius.circular(24)),
            child: Align(
                alignment: Alignment.centerRight,
                child: Padding(padding: const EdgeInsets.only(right: 24), child: Icon(Icons.delete_outline, color: colors.onError)),
            ),
        );
    }
}

/// A tappable field that looks like search and opens the city search.
class AddCityField extends StatelessWidget {
    final VoidCallback onTap;

    const AddCityField({ super.key, required this.onTap });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        return Material(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(28),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
                onTap: onTap,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(children: [
                        Icon(Icons.search, color: colors.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Expanded(child: Text(context.l10n.searchForCity, style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant))),
                        Icon(Icons.add_location_alt_outlined, color: colors.primary),
                    ]),
                ),
            ),
        );
    }
}

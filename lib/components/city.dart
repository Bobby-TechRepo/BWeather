import 'package:bweather/states/cities_cubit.dart';
import 'package:bweather/utils/cities.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnCitySelected = void Function(City city);

/// A shortcut shown above the city list, e.g. "Use my location".
class QuickPlace {
    final IconData icon;
    final String title;
    final String? subtitle;
    final VoidCallback onTap;

    const QuickPlace({ required this.icon, required this.title, this.subtitle, required this.onTap });
}

/// Rows grouped in one rounded card with hairline dividers, like the settings lists.
class PlaceGroup extends StatelessWidget {
    final String? title;
    final List<Widget> children;

    const PlaceGroup({ super.key, this.title, required this.children });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (title != null)
                    Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                        child: Semantics(
                            header: true,
                            child: Text(title!, style: theme.textTheme.titleSmall?.copyWith(color: colors.primary, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
                        ),
                    ),
                Material(
                    color: colors.surfaceContainerLow,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                        for (int i = 0; i < children.length; i++) ...[
                            if (i > 0) Divider(height: 1, indent: 68, color: colors.outlineVariant.withValues(alpha: 0.5)),
                            children[i],
                        ],
                    ]),
                ),
            ]),
        );
    }
}

/// One place in a list: a round badge, the name, "region, country" underneath,
/// and an add (or "already saved") mark.
class CityTile extends StatelessWidget {
    final String name, subtitle;
    final VoidCallback onTap;

    /// Shows a tick instead of the add icon: the place is already in Locations.
    final bool saved;

    /// Replaces the initial in the badge (used for shortcuts).
    final IconData? icon;

    /// The trailing hint; defaults to "add".
    final IconData trailing;

    const CityTile({
        super.key, required this.name, required this.subtitle, required this.onTap,
        this.saved = false, this.icon, this.trailing = Icons.add_circle_outline,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final initial = name.isEmpty ? "?" : name.characters.first.toUpperCase();

        return InkWell(
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Row(children: [
                    Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.12), shape: BoxShape.circle),
                        child: icon != null
                            ? Icon(icon, size: 20, color: colors.primary)
                            : Text(initial, style: theme.textTheme.titleMedium?.copyWith(color: colors.primary, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            if (subtitle.isNotEmpty)
                                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                        ]),
                    ),
                    const SizedBox(width: 8),
                    Icon(saved ? Icons.check_circle : trailing, color: saved ? colors.primary : colors.onSurfaceVariant),
                ]),
            ),
        );
    }
}

/// The built-in capital cities, A–Z in grouped cards, with optional
/// [quick] shortcuts on top.
class CityList extends StatelessWidget {
    final OnCitySelected onSelected;
    final List<QuickPlace> quick;
    final Set<String> savedIds;

    const CityList({ super.key, required this.onSelected, this.quick = const [], this.savedIds = const {} });

    @override
    Widget build(BuildContext context) {
        return BlocBuilder<CitiesCubit, CitiesState>(
            buildWhen: (previous, current) => previous.catalog != current.catalog || previous.letters != current.letters,
            builder: (context, state) {
                // Split the sorted catalog at the letter headers.
                final groups = <(String, List<CityData>)>[];
                for (int index = 0; index < state.catalog.length; index++) {
                    final letter = state.letters[index];
                    if (letter != null || groups.isEmpty) groups.add((letter ?? "", <CityData>[]));
                    groups.last.$2.add(state.catalog[index]);
                }
                final hasQuick = quick.isNotEmpty;

                return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: groups.length + (hasQuick ? 1 : 0),
                    itemBuilder: (context, index) {
                        if (hasQuick && index == 0) {
                            return PlaceGroup(children: [
                                for (final place in quick)
                                    CityTile(name: place.title, subtitle: place.subtitle ?? "", icon: place.icon, trailing: Icons.chevron_right, onTap: place.onTap),
                            ]);
                        }
                        final (letter, cities) = groups[index - (hasQuick ? 1 : 0)];
                        return PlaceGroup(
                            title: letter,
                            children: [
                                for (final city in cities)
                                    Builder(builder: (context) {
                                        // Use the coordinates we already have instead of searching by name,
                                        // which could pick a different place with the same name.
                                        final place = City(name: city.name, country: city.country, latitude: city.latitude, longitude: city.longitude);
                                        return CityTile(
                                            name: city.name,
                                            subtitle: city.country,
                                            saved: savedIds.contains(place.id),
                                            onTap: () => onSelected(place),
                                        );
                                    }),
                            ],
                        );
                    },
                );
            },
        );
    }
}

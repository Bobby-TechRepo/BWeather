import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/components/cities.dart';
import 'package:bweather/components/location_list.dart';
import 'package:bweather/components/search.dart';
import 'package:bweather/states/cities_cubit.dart';
import 'package:bweather/states/main_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Desktop side panel: saved places, or the city search when [showSearch] is on.
/// It lives inside the main screen (it is not a route), so it opens and closes
/// the search through [onOpenSearch] and [onClose] instead of the navigator.
class CitiesTab extends StatelessWidget {
    final bool showSearch;
    final VoidCallback onOpenSearch, onClose;

    const CitiesTab({ super.key, required this.showSearch, required this.onOpenSearch, required this.onClose });

    void _select(BuildContext context, City city) {
        final key = context.read<WeatherCubit>().addCity(city);
        context.read<MainCubit>().showPlace(key);
        context.read<CitiesCubit>().clear();
        onClose();
    }

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);

        if (!showSearch) {
            return LocationList(
                compact: true,
                headerSlivers: [
                    SliverToBoxAdapter(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 24, 8, 12),
                            child: Row(children: [
                                Expanded(child: Text(l10n.navLocations, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600))),
                                IconButton(tooltip: l10n.addCity, icon: const Icon(Icons.add_location_alt_outlined), onPressed: onOpenSearch),
                            ]),
                        ),
                    ),
                    SliverToBoxAdapter(
                        child: Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 16), child: AddCityField(onTap: onOpenSearch)),
                    ),
                ],
            );
        }

        return Padding(
            padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
            child: Column(children: [
                Row(children: [
                    const Expanded(child: Search(autofocus: true)),
                    IconButton(tooltip: l10n.close, onPressed: () { context.read<CitiesCubit>().clear(); onClose(); }, icon: const Icon(Icons.close)),
                ]),
                const SizedBox(height: 16),
                Expanded(
                    child: CitiesView(
                        onSelected: (city) => _select(context, city),
                        savedIds: {for (final place in context.watch<WeatherCubit>().state.cities) place.city.id},
                    ),
                ),
            ]),
        );
    }
}

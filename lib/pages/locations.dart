import 'package:bweather/components/location_list.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/screens/cities.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Locations tab (phones and tablets): a large title, a search field to add
/// cities, then the saved places as sky-tinted cards. Pull down to refresh all.
class Locations extends StatelessWidget {
    const Locations({ super.key });

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        void addCity() => Navigator.of(context).pushNamed(CitiesScreen.routeName);

        return RefreshIndicator(
            // Below the large app bar, so the spinner doesn't cover the title.
            edgeOffset: 112,
            onRefresh: () => context.read<WeatherCubit>().refreshAll(force: true),
            child: LocationList(
                headerSlivers: [
                    SliverAppBar.large(
                        automaticallyImplyLeading: false,
                        title: Text(l10n.navLocations),
                        actions: [
                            IconButton(tooltip: l10n.addCity, icon: const Icon(Icons.add_location_alt_outlined), onPressed: addCity),
                            const SizedBox(width: 8),
                        ],
                    ),
                    SliverToBoxAdapter(
                        child: Center(
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: LocationList.maxCardWidth + 32),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                                    child: AddCityField(onTap: addCity),
                                ),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}

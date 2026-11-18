import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/components/cities.dart';
import 'package:bweather/components/city.dart';
import 'package:bweather/components/search.dart';
import 'package:bweather/states/cities_cubit.dart';
import 'package:bweather/states/forecast/city_state.dart';
import 'package:bweather/states/main_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full-screen city search (mobile/tablet, and the welcome screen): a large
/// title, the search field, then shortcuts and capitals in grouped cards.
class CitiesScreen extends StatefulWidget {
    static const String routeName = "cities";

    const CitiesScreen({ super.key });

    @override
    State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
    @override
    void initState() {
        super.initState();
        // Start from the city list, not the last search.
        context.read<CitiesCubit>().clear();
    }

    void _select(City city) {
        final key = context.read<WeatherCubit>().addCity(city);
        context.read<MainCubit>().showPlace(key);
        Navigator.of(context).maybePop();
    }

    void _useMyLocation() {
        final weather = context.read<WeatherCubit>();
        final main = context.read<MainCubit>();
        Navigator.of(context).maybePop();
        // The location banner shows progress while GPS works.
        weather.useMyLocation().then((_) {
            if (weather.state.location != null) main.showPlace(CityState.currentLocationKey);
        });
    }

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final weather = context.watch<WeatherCubit>().state;
        final location = weather.location;
        final savedIds = {for (final place in weather.cities) place.city.id};

        return SearchScaffold(
            title: l10n.addCity,
            child: CitiesView(
                onSelected: _select,
                savedIds: savedIds,
                quick: [
                    // Offered while there's no precise location yet.
                    if (location == null || location.approximate)
                        QuickPlace(
                            icon: Icons.my_location,
                            title: l10n.useMyLocation,
                            subtitle: location == null ? null : l10n.approximateLocation,
                            onTap: _useMyLocation,
                        ),
                ],
            ),
        );
    }
}

/// Shared layout for the city search screens: back button and large title,
/// the search field, then [child] (kept to a readable width on big screens).
class SearchScaffold extends StatelessWidget {
    final String title;
    final Widget child;

    const SearchScaffold({ super.key, required this.title, required this.child });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        return Scaffold(
            body: SafeArea(
                bottom: false,
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
                                child: Row(children: [
                                    const BackButton(),
                                    const SizedBox(width: 4),
                                    Expanded(
                                        child: Semantics(
                                            header: true,
                                            child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                                        ),
                                    ),
                                ]),
                            ),
                            const Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 16), child: Search(autofocus: true)),
                            Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: child)),
                        ]),
                    ),
                ),
            ),
        );
    }
}

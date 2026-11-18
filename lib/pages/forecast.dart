import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/components/forecast_view.dart';
import 'package:bweather/components/location_banner.dart';
import 'package:bweather/screens/cities.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/main_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Swipeable forecast pages: the user's location first, then saved cities.
class ForecastPage extends StatefulWidget {
    const ForecastPage({ super.key });

    @override
    State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
    // One controller for the lifetime of the page. (It used to be re-created on
    // every rebuild, which reset the pager whenever any forecast updated.)
    final PageController _controller = PageController();

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    /// Pages to [key]. Runs after the next frame so a city that was *just*
    /// added is already part of the PageView.
    void _jumpTo(String? key) {
        if (key == null) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || !_controller.hasClients) return;
            final index = context.read<WeatherCubit>().state.indexOfPlace(key);
            final current = _controller.page?.round();
            if (index == -1 || current == index) return;

            if (current != null && (current - index).abs() == 1) {
                _controller.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
            } else {
                _controller.jumpToPage(index);
            }
        });
    }

    @override
    Widget build(BuildContext context) {
        // Rebuild only when the *list of places* changes, not on every forecast update.
        return BlocSelector<WeatherCubit, WeatherState, String>(
            selector: (state) => state.places.map((place) => place.key).join("|"),
            builder: (context, joinedKeys) {
                final keys = joinedKeys.isEmpty ? const <String>[] : joinedKeys.split("|");

                return BlocListener<MainCubit, MainState>(
                    listenWhen: (previous, current) => previous.selectionRequest != current.selectionRequest,
                    listener: (context, state) => _jumpTo(state.selectedPlace),
                    child: Column(children: [
                        const LocationBanner(),
                        Expanded(
                            child: keys.isEmpty
                                ? const _NoPlaces()
                                : PageView.builder(
                                    controller: _controller,
                                    itemCount: keys.length,
                                    onPageChanged: (index) => context.read<MainCubit>().placeVisible(keys[index]),
                                    itemBuilder: (context, index) => ForecastView(key: ValueKey(keys[index]), placeKey: keys[index]),
                                ),
                        ),
                    ]),
                );
            },
        );
    }
}

class _NoPlaces extends StatelessWidget {
    const _NoPlaces();

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final l10n = context.l10n;
        return Center(
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.travel_explore, size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(l10n.noPlacesTitle, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(l10n.noPlacesBody, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                        onPressed: () => context.read<WeatherCubit>().useMyLocation(),
                        icon: const Icon(Icons.my_location),
                        label: Text(l10n.useMyLocation),
                    ),
                    TextButton(onPressed: () => Navigator.of(context).pushNamed(CitiesScreen.routeName), child: Text(l10n.addCity)),
                ]),
            ),
        );
    }
}

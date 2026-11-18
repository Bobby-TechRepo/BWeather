import 'package:bweather/components/cities.dart';
import 'package:bweather/components/city.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/screens/cities.dart';
import 'package:bweather/states/cities_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Search for a city and return it (`Navigator.pop(city)`) without saving it
/// to Locations. Used by the trip editor.
class CityPickerScreen extends StatefulWidget {
    static const String routeName = "city-picker";

    const CityPickerScreen({ super.key });

    @override
    State<CityPickerScreen> createState() => _CityPickerScreenState();
}

class _CityPickerScreenState extends State<CityPickerScreen> {
    @override
    void initState() {
        super.initState();
        context.read<CitiesCubit>().clear();
    }

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final location = context.read<WeatherCubit>().state.location;

        return SearchScaffold(
            title: l10n.searchForCity,
            child: CitiesView(
                onSelected: (city) => Navigator.of(context).pop(city),
                quick: [
                    // Where the user is now, as a one-tap choice.
                    if (location != null)
                        QuickPlace(
                            icon: Icons.near_me,
                            title: location.city.name,
                            subtitle: location.approximate ? l10n.approximateLocation : l10n.yourLocation,
                            onTap: () => Navigator.of(context).pop(location.city),
                        ),
                ],
            ),
        );
    }
}

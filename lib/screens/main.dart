import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/components/cities_tab.dart';
import 'package:bweather/pages/forecast.dart';
import 'package:bweather/pages/locations.dart';
import 'package:bweather/pages/settings.dart';
import 'package:bweather/pages/trips.dart';
import 'package:bweather/states/main_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';

class _Destination {
    final AppTab tab;
    final IconData? icon, selectedIcon;

    /// Glyphs icons (files/icons/glyphs--nav_*.svg). They carry more detail and
    /// padding than Material icons, so they're drawn a little larger.
    final String? asset, selectedAsset;

    const _Destination(this.tab, IconData this.icon, IconData this.selectedIcon) : asset = null, selectedAsset = null;

    const _Destination.svg(this.tab, String this.asset, String this.selectedAsset) : icon = null, selectedIcon = null;

    static const double svgSize = 28;

    Widget iconWidget({ bool selected = false }) {
        final svg = selected ? selectedAsset : asset;
        if (svg != null) return _NavSvg(asset: svg, size: svgSize);
        return Icon(selected ? selectedIcon : icon);
    }

    String label(AppLocalizations l10n) => switch (tab) {
        AppTab.forecast => l10n.navForecast,
        AppTab.locations => l10n.navLocations,
        AppTab.trips => l10n.navTrips,
        AppTab.settings => l10n.navSettings,
    };
}

/// A single-colour SVG tinted like an Icon (NavigationBar and NavigationRail
/// set the selected/unselected colour through IconTheme).
class _NavSvg extends StatelessWidget {
    final String asset;
    final double size;

    const _NavSvg({ required this.asset, required this.size });

    @override
    Widget build(BuildContext context) {
        final color = IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurfaceVariant;
        return SvgPicture.asset(
            asset,
            width: size,
            height: size,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            excludeFromSemantics: true, // the destination's label is announced instead
        );
    }
}

const _forecast = _Destination(AppTab.forecast, Icons.cloud_outlined, Icons.cloud);
const _locations = _Destination.svg(AppTab.locations, "files/icons/glyphs--nav_locations.svg", "files/icons/glyphs--nav_locations_filled.svg");
const _trips = _Destination.svg(AppTab.trips, "files/icons/glyphs--nav_trips.svg", "files/icons/glyphs--nav_trips_filled.svg");
const _settings = _Destination.svg(AppTab.settings, "files/icons/glyphs--nav_settings.svg", "files/icons/glyphs--nav_settings_filled.svg");

class MainScreen extends StatefulWidget {
    static const String routeName = "main";

    const MainScreen({ super.key });

    @override
    State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
    /// Desktop only: whether the side panel shows the city search.
    bool _showSearch = false;
    late final AppLifecycleListener _lifecycle;

    @override
    void initState() {
        super.initState();
        // Refresh stale forecasts when the user comes back to the app.
        _lifecycle = AppLifecycleListener(onResume: () => context.read<WeatherCubit>().onResume());
    }

    @override
    void dispose() {
        _lifecycle.dispose();
        super.dispose();
    }

    Widget _page(AppTab tab) => switch (tab) {
        AppTab.forecast => const ForecastPage(),
        AppTab.locations => const Locations(),
        AppTab.trips => const TripsPage(),
        AppTab.settings => const Settings(),
    };

    @override
    Widget build(BuildContext context) {
        final breakpoints = ResponsiveBreakpoints.of(context);
        final isDesktop = breakpoints.isDesktop, isMobile = breakpoints.isMobile;
        final width = MediaQuery.sizeOf(context).width;
        // Labels beside rail icons only when there's room to spare.
        final extendedRail = width >= 1440;
        // The places panel grows with the window, within sensible limits.
        final panelWidth = (width * 0.28).clamp(300.0, 380.0).toDouble();
        final colors = Theme.of(context).colorScheme;
        final mainCubit = context.read<MainCubit>();
        final l10n = context.l10n;

        // Desktop always shows saved places in the side panel, so it has no Locations tab.
        final destinations = isDesktop ? const [_forecast, _trips, _settings] : const [_forecast, _locations, _trips, _settings];

        return BlocBuilder<MainCubit, MainState>(
            builder: (context, state) {
                var selected = destinations.indexWhere((destination) => destination.tab == state.tab);
                if (selected == -1) selected = 0; // e.g. "Locations" after resizing to desktop

                final pages = IndexedStack(
                    index: selected,
                    children: [for (final destination in destinations) _page(destination.tab)],
                );

                void select(int index) => mainCubit.tab = destinations[index].tab;

                return Scaffold(
                    body: SafeArea(
                        child: Row(children: [
                            if (!isMobile) ...[
                                NavigationRail(
                                    extended: extendedRail,
                                    selectedIndex: selected,
                                    onDestinationSelected: select,
                                    labelType: extendedRail ? NavigationRailLabelType.none : NavigationRailLabelType.all,
                                    destinations: [
                                        for (final destination in destinations)
                                            NavigationRailDestination(icon: destination.iconWidget(), selectedIcon: destination.iconWidget(selected: true), label: Text(destination.label(l10n))),
                                    ],
                                ),
                                const VerticalDivider(width: 1),
                            ],
                            if (isDesktop) ...[
                                SizedBox(
                                    width: panelWidth,
                                    child: ColoredBox(
                                        color: colors.surfaceContainerLowest,
                                        child: CitiesTab(
                                            showSearch: _showSearch,
                                            onOpenSearch: () => setState(() => _showSearch = true),
                                            onClose: () => setState(() => _showSearch = false),
                                        ),
                                    ),
                                ),
                                const VerticalDivider(width: 1),
                            ],
                            Expanded(child: pages),
                        ]),
                    ),
                    bottomNavigationBar: isMobile
                        ? NavigationBar(
                            selectedIndex: selected,
                            onDestinationSelected: select,
                            destinations: [
                                for (final destination in destinations)
                                    NavigationDestination(icon: destination.iconWidget(), selectedIcon: destination.iconWidget(selected: true), label: destination.label(l10n)),
                            ],
                        )
                        : null,
                );
            },
        );
    }
}

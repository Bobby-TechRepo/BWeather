import 'package:bweather/components/trip_card.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/screens/trips/trip_editor.dart';
import 'package:bweather/states/trips/trips_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Trips tab: planned, current and past trips.
class TripsPage extends StatefulWidget {
    const TripsPage({ super.key });

    @override
    State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
    @override
    void initState() {
        super.initState();
        // Cheap when nothing is stale: each stop is only refetched every few hours.
        context.read<TripsCubit>().refreshAll();
    }

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        void newTrip() => Navigator.of(context).pushNamed(TripEditorScreen.routeName);

        return BlocBuilder<TripsCubit, TripsState>(
            buildWhen: (previous, current) => previous.trips != current.trips,
            builder: (context, state) {
                final trips = state.trips;
                return RefreshIndicator(
                    edgeOffset: 112,
                    onRefresh: () => context.read<TripsCubit>().refreshAll(),
                    child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                            SliverAppBar.large(
                                automaticallyImplyLeading: false,
                                title: Text(l10n.navTrips),
                                actions: [
                                    IconButton(tooltip: l10n.newTrip, icon: const Icon(Icons.add), onPressed: newTrip),
                                    const SizedBox(width: 8),
                                ],
                            ),
                            if (trips.isEmpty)
                                SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(Icons.luggage_outlined, size: 64, color: theme.colorScheme.primary),
                                            const SizedBox(height: 16),
                                            Text(l10n.tripsEmptyTitle, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 8),
                                            Text(l10n.tripsEmptyBody, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                                            const SizedBox(height: 24),
                                            FilledButton.icon(onPressed: newTrip, icon: const Icon(Icons.add), label: Text(l10n.planTrip)),
                                        ]),
                                    ),
                                )
                            else
                                SliverPadding(
                                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                                    sliver: SliverList.separated(
                                        itemCount: trips.length,
                                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                                        itemBuilder: (context, index) => Center(
                                            child: ConstrainedBox(
                                                constraints: const BoxConstraints(maxWidth: 720),
                                                child: TripCard(tripId: trips[index].id),
                                            ),
                                        ),
                                    ),
                                ),
                        ],
                    ),
                );
            },
        );
    }
}

import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/screens/city_picker.dart';
import 'package:bweather/screens/trips/trip_detail.dart';
import 'package:bweather/states/trips/trip.dart';
import 'package:bweather/states/trips/trips_cubit.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Create a trip (no arguments) or edit one (the trip id as the route argument).
class TripEditorScreen extends StatefulWidget {
    static const String routeName = "trip-edit";

    final String? tripId;

    const TripEditorScreen({ super.key, this.tripId });

    @override
    State<TripEditorScreen> createState() => _TripEditorScreenState();
}

class _TripEditorScreenState extends State<TripEditorScreen> {
    late final TextEditingController _name;
    late List<TripStop> _stops;
    Trip? _original;
    TripProblem? _problem;

    TripsCubit get _cubit => context.read<TripsCubit>();

    @override
    void initState() {
        super.initState();
        _original = widget.tripId == null ? null : _cubit.state.trip(widget.tripId!);
        _name = TextEditingController(text: _original?.name ?? "");
        _stops = [...?_original?.stops];
    }

    @override
    void dispose() {
        _name.dispose();
        super.dispose();
    }

    static DateTime get _today => dateOnly(DateTime.now());

    /// Untyped push: routes come from onGenerateRoute as `MaterialPageRoute<dynamic>`,
    /// which can't be cast to `Route<City?>`.
    Future<City?> _pickCity() async {
        final result = await Navigator.of(context).pushNamed(CityPickerScreen.routeName);
        return result is City ? result : null;
    }

    Future<DateTimeRange?> _pickDates(DateTimeRange initial) {
        final first = initial.start.isBefore(_today) ? initial.start : _today;
        return showDateRangePicker(
            context: context,
            firstDate: first,
            lastDate: DateTime(_today.year + 2, _today.month, _today.day),
            initialDateRange: initial,
            helpText: context.l10n.chooseDates,
        );
    }

    Future<void> _addStop() async {
        final city = await _pickCity();
        if (city == null || !mounted) return;
        final start = _stops.isEmpty ? _today.add(const Duration(days: 7)) : _stops.last.depart;
        final range = await _pickDates(DateTimeRange(start: start, end: start.add(const Duration(days: 2))));
        if (range == null || !mounted) return;
        setState(() {
            _stops = [..._stops, TripStop(id: _cubit.newId(), city: city, arrive: range.start, depart: range.end)]
                ..sort((a, b) => a.arrive.compareTo(b.arrive));
            _problem = null;
        });
    }

    Future<void> _changeCity(int index) async {
        final city = await _pickCity();
        if (city == null || !mounted) return;
        setState(() => _stops[index] = _stops[index].copy(city: city));
    }

    Future<void> _changeDates(int index) async {
        final stop = _stops[index];
        final range = await _pickDates(DateTimeRange(start: stop.arrive, end: stop.depart));
        if (range == null || !mounted) return;
        setState(() {
            _stops[index] = stop.copy(arrive: range.start, depart: range.end);
            _stops.sort((a, b) => a.arrive.compareTo(b.arrive));
            _problem = null;
        });
    }

    void _save() {
        final problem = validateStops(_stops);
        if (problem != null) {
            setState(() => _problem = problem);
            return;
        }
        final name = _name.text.trim().isEmpty ? context.l10n.tripDefaultName(_stops.first.city.name) : _name.text.trim();
        final base = _original;
        final trip = base == null
            ? Trip(id: _cubit.newId(), name: name, stops: _stops)
            : base.copy(name: name, stops: _stops);
        _cubit.save(trip);
        if (base == null) {
            Navigator.of(context).pushReplacementNamed(TripDetailScreen.routeName, arguments: trip.id);
        } else {
            Navigator.of(context).pop();
        }
    }

    void _delete() {
        final trip = _original;
        if (trip == null) return;
        final l10n = context.l10n;
        final messenger = ScaffoldMessenger.of(context);
        final cubit = _cubit;
        cubit.delete(trip.id);
        Navigator.of(context).popUntil((route) => route.isFirst);
        messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.tripDeleted), action: SnackBarAction(label: l10n.undo, onPressed: () => cubit.restore(trip))));
    }

    String? _problemText(TripProblem? problem) => switch (problem) {
        null => null,
        TripProblem.noStops => context.l10n.tripProblemNoStops,
        TripProblem.stopEndsBeforeItStarts || TripProblem.stopsOverlap => context.l10n.tripProblemOrder,
        TripProblem.tooLong => context.l10n.tripProblemTooLong(Trip.maxDays),
    };

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final locale = context.localeName;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final problem = _problemText(_problem);

        return Scaffold(
            appBar: AppBar(
                title: Text(_original == null ? l10n.newTrip : l10n.editTrip),
                actions: [
                    Padding(padding: const EdgeInsets.only(right: 8), child: FilledButton(onPressed: _save, child: Text(l10n.save))),
                ],
            ),
            body: SafeArea(
                top: false,
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 32), children: [
                            TextField(
                                controller: _name,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                    labelText: l10n.tripName,
                                    hintText: l10n.tripNameHint,
                                    border: const OutlineInputBorder(),
                                ),
                            ),
                            const SizedBox(height: 24),
                            Text(l10n.tripStops.toUpperCase(), style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                            const SizedBox(height: 8),
                            for (int i = 0; i < _stops.length; i++)
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Card(
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                ListTile(
                                                    leading: CircleAvatar(
                                                        backgroundColor: colors.primary,
                                                        foregroundColor: colors.onPrimary,
                                                        child: Text("${i + 1}"),
                                                    ),
                                                    title: Text(_stops[i].city.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                                    subtitle: _stops[i].city.subtitle.isEmpty ? null : Text(_stops[i].city.subtitle),
                                                    onTap: () => _changeCity(i),
                                                    trailing: IconButton(
                                                        tooltip: l10n.removeStop,
                                                        icon: const Icon(Icons.close),
                                                        onPressed: () => setState(() {
                                                            _stops = [..._stops]..removeAt(i);
                                                            _problem = null;
                                                        }),
                                                    ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(left: 72),
                                                    child: OutlinedButton.icon(
                                                        onPressed: () => _changeDates(i),
                                                        icon: const Icon(Icons.date_range, size: 18),
                                                        label: Text("${formatDateRange(_stops[i].arrive, _stops[i].depart, locale)} · ${l10n.tripDayCount(_stops[i].nights + 1)}"),
                                                    ),
                                                ),
                                            ]),
                                        ),
                                    ),
                                ),
                            OutlinedButton.icon(
                                onPressed: _addStop,
                                icon: const Icon(Icons.add_location_alt_outlined),
                                label: Text(l10n.addStop),
                                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                            ),
                            if (problem != null)
                                Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(problem, style: theme.textTheme.bodyMedium?.copyWith(color: colors.error)),
                                ),
                            if (_original != null) ...[
                                const SizedBox(height: 32),
                                TextButton.icon(
                                    onPressed: _delete,
                                    style: TextButton.styleFrom(foregroundColor: colors.error),
                                    icon: const Icon(Icons.delete_outline),
                                    label: Text(l10n.deleteTrip),
                                ),
                            ],
                        ]),
                    ),
                ),
            ),
        );
    }
}

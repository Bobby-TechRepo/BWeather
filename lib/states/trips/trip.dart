import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';

/// Calendar date with no time of day (local midnight).
DateTime dateOnly(DateTime time) => DateTime(time.year, time.month, time.day);

/// One place on a trip, from the day you arrive to the day you leave (both inclusive).
class TripStop extends Equatable {
    final String id;
    final City city;
    final DateTime arrive, depart;

    TripStop({ required this.id, required City city, required DateTime arrive, required DateTime depart })
        // The stop only needs the place, not a cached forecast.
        : city = city.forecast == null ? city : _withoutForecast(city),
          arrive = dateOnly(arrive),
          depart = dateOnly(depart);

    static City _withoutForecast(City city) => City(
        name: city.name, country: city.country, region: city.region, latitude: city.latitude,
        longitude: city.longitude, elevation: city.elevation, timezone: city.timezone,
    );

    int get nights => depart.difference(arrive).inDays;

    bool contains(DateTime day) {
        final date = dateOnly(day);
        return !date.isBefore(arrive) && !date.isAfter(depart);
    }

    TripStop copy({ City? city, DateTime? arrive, DateTime? depart }) =>
        TripStop(id: id, city: city ?? this.city, arrive: arrive ?? this.arrive, depart: depart ?? this.depart);

    factory TripStop.fromJson(dynamic json) => TripStop(
        id: json["id"].toString(),
        city: City.fromJson(json["city"]),
        arrive: DateTime.parse(json["arrive"].toString()),
        depart: DateTime.parse(json["depart"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "id": id, "city": city.toJson(),
        "arrive": _date(arrive), "depart": _date(depart),
    };

    static String _date(DateTime d) => "${d.year.toString().padLeft(4, "0")}-${d.month.toString().padLeft(2, "0")}-${d.day.toString().padLeft(2, "0")}";

    @override
    List<Object?> get props => [id, city, arrive, depart];
}

enum TripTiming { upcoming, ongoing, past }

/// A named trip with one or more stops in date order.
class Trip extends Equatable {
    /// Longest trip the planner accepts, to keep requests and lists sane.
    static const maxDays = 90;

    final String id, name;
    final List<TripStop> stops;

    /// Packing items the user ticked (by [PackingItem] name).
    final Set<String> packed;

    /// Send a notification the evening before departure.
    final bool remind;

    const Trip({ required this.id, required this.name, required this.stops, this.packed = const {}, this.remind = false });

    DateTime get start => stops.first.arrive;
    DateTime get end => stops.last.depart;
    int get dayCount => end.difference(start).inDays + 1;

    TripTiming timing([DateTime? now]) {
        final today = dateOnly(now ?? DateTime.now());
        if (today.isBefore(start)) return TripTiming.upcoming;
        if (today.isAfter(end)) return TripTiming.past;
        return TripTiming.ongoing;
    }

    /// Days until the trip starts (0 on the first day, negative once it has started).
    int daysUntil([DateTime? now]) => start.difference(dateOnly(now ?? DateTime.now())).inDays;

    /// Every date of the trip, in order.
    List<DateTime> get dates => [for (int i = 0; i < dayCount; i++) DateTime(start.year, start.month, start.day + i)];

    /// Where you are on [day]. On a travel day (one stop's departure is the
    /// next one's arrival) this is the stop you arrive at.
    TripStop? stopOn(DateTime day) {
        TripStop? found;
        for (final stop in stops) {
            if (stop.contains(day)) found = stop;
        }
        return found;
    }

    /// The stop you leave on [day] when it is a travel day, else null.
    TripStop? leavingOn(DateTime day) {
        final date = dateOnly(day);
        final arriving = stopOn(date);
        for (final stop in stops) {
            if (stop != arriving && stop.depart == date) return stop;
        }
        return null;
    }

    Trip copy({ String? name, List<TripStop>? stops, Set<String>? packed, bool? remind }) => Trip(
        id: id, name: name ?? this.name, stops: stops ?? this.stops,
        packed: packed ?? this.packed, remind: remind ?? this.remind,
    );

    factory Trip.fromJson(dynamic json) => Trip(
        id: json["id"].toString(),
        name: (json["name"] ?? "").toString(),
        stops: [for (final stop in (json["stops"] as List)) TripStop.fromJson(stop)],
        packed: {for (final item in (json["packed"] as List? ?? const [])) item.toString()},
        remind: json["remind"] == true,
    );

    Map<String, dynamic> toJson() => {
        "id": id, "name": name,
        "stops": stops.map((stop) => stop.toJson()).toList(),
        "packed": packed.toList()..sort(),
        "remind": remind,
    };

    @override
    List<Object?> get props => [id, name, stops, packed, remind];
}

/// Why a set of stops can't be saved as a trip.
enum TripProblem { noStops, stopEndsBeforeItStarts, stopsOverlap, tooLong }

/// Checks stops are in order and the trip isn't too long. Null when valid.
TripProblem? validateStops(List<TripStop> stops) {
    if (stops.isEmpty) return TripProblem.noStops;
    for (int i = 0; i < stops.length; i++) {
        if (stops[i].depart.isBefore(stops[i].arrive)) return TripProblem.stopEndsBeforeItStarts;
        // You may leave one place and arrive at the next on the same day.
        if (i > 0 && stops[i].arrive.isBefore(stops[i - 1].depart)) return TripProblem.stopsOverlap;
    }
    if (stops.last.depart.difference(stops.first.arrive).inDays + 1 > Trip.maxDays) return TripProblem.tooLong;
    return null;
}

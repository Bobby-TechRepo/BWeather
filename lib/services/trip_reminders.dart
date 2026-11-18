import 'package:bweather/states/trips/trip.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';

/// A pre-trip notification for the background job: the evening before
/// [departure], with the forecast for the first stop.
class TripReminder extends Equatable {
    /// Trip id plus departure date, so moving the trip re-arms the reminder.
    final String id;
    final String tripName;
    final City city;
    final DateTime departure;

    const TripReminder({ required this.id, required this.tripName, required this.city, required this.departure });

    /// Reminders go out from 17:00 the day before until 10:00 on the day
    /// (device time). The background job runs about hourly, so this window
    /// makes sure one run falls inside it.
    static const fromHour = 17, untilHour = 10;

    bool isDue(DateTime now) {
        final day = dateOnly(departure);
        final opens = DateTime(day.year, day.month, day.day - 1, fromHour);
        final closes = DateTime(day.year, day.month, day.day, untilHour);
        return !now.isBefore(opens) && now.isBefore(closes);
    }

    /// Reminders for upcoming trips that have them turned on.
    static List<TripReminder> fromTrips(List<Trip> trips, [DateTime? now]) => [
        for (final trip in trips)
            if (trip.remind && trip.timing(now) == TripTiming.upcoming)
                TripReminder(
                    id: "${trip.id}@${trip.start.toIso8601String().substring(0, 10)}",
                    tripName: trip.name,
                    city: trip.stops.first.city,
                    departure: trip.start,
                ),
    ];

    factory TripReminder.fromJson(dynamic json) => TripReminder(
        id: json["id"].toString(),
        tripName: (json["name"] ?? "").toString(),
        city: City.fromJson(json["city"]),
        departure: DateTime.parse(json["departure"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "id": id, "name": tripName,
        "city": City(name: city.name, country: city.country, region: city.region, latitude: city.latitude, longitude: city.longitude).toJson(),
        "departure": departure.toIso8601String(),
    };

    @override
    List<Object?> get props => [id, tripName, city, departure];
}

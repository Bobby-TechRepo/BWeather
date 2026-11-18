import 'package:geolocator/geolocator.dart';

enum LocationFailureReason { serviceDisabled, permissionDenied, permissionDeniedForever, unavailable }

class LocationException implements Exception {
    final LocationFailureReason reason;

    const LocationException(this.reason);

    @override
    String toString() => "LocationException($reason)";
}

typedef Coordinates = ({ double latitude, double longitude });

/// Wraps the device's GPS so the cubit can be unit tested without platform channels.
abstract class LocationService {
    /// Current position. Asks for permission when [requestPermission] is true;
    /// otherwise only uses a permission the user already granted.
    /// Throws [LocationException] when no position can be obtained.
    Future<Coordinates> currentPosition({ bool requestPermission = true });

    /// Opens the OS settings page so the user can grant a permanently denied permission.
    Future<bool> openSettings();
}

class DeviceLocationService implements LocationService {
    /// Oldest cached fix we accept when a fresh one can't be obtained.
    static const maxLastKnownAge = Duration(hours: 1);
    static const fixTimeout = Duration(seconds: 15);

    const DeviceLocationService();

    @override
    Future<Coordinates> currentPosition({ bool requestPermission = true }) async {
        if (!await Geolocator.isLocationServiceEnabled()) {
            throw const LocationException(LocationFailureReason.serviceDisabled);
        }

        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied && requestPermission) {
            permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.deniedForever) {
            throw const LocationException(LocationFailureReason.permissionDeniedForever);
        }
        if (permission == LocationPermission.denied || permission == LocationPermission.unableToDetermine) {
            throw const LocationException(LocationFailureReason.permissionDenied);
        }

        Position? position;
        try {
            position = await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: fixTimeout),
            );
        } catch (_) {
            // Timed out or no fix (e.g. indoors): fall back to a recent cached fix.
            try {
                final lastKnown = await Geolocator.getLastKnownPosition();
                if (lastKnown != null && DateTime.now().difference(lastKnown.timestamp) <= maxLastKnownAge) {
                    position = lastKnown;
                }
            } catch (_) {
                // Not supported on web.
            }
        }

        if (position == null) {
            throw const LocationException(LocationFailureReason.unavailable);
        }
        return (latitude: position.latitude, longitude: position.longitude);
    }

    @override
    Future<bool> openSettings() => Geolocator.openAppSettings();
}

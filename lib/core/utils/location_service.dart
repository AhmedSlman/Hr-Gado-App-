import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service to handle location permissions and get current location
class LocationService {
  LocationService._();

  /// Check and request location permissions
  /// Returns true if permission is granted, false otherwise
  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled
      return false;
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied by user
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permission denied forever, user needs to enable from settings
      return false;
    }

    // Permission is granted
    return true;
  }

  /// Get current location
  /// Returns Position with latitude and longitude
  /// Throws exception if permission denied or location unavailable
  static Future<Position> getCurrentLocation({
    LocationAccuracy desiredAccuracy = LocationAccuracy.high,
    Duration? timeLimit,
  }) async {
    // Check and request permission first
    final hasPermission = await requestLocationPermission();
    if (!hasPermission) {
      throw LocationPermissionException(
        'Location permission is denied. Please enable location permissions in settings.',
      );
    }

    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException(
        'Location services are disabled. Please enable location services.',
      );
    }

    // Get current position
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy,
        timeLimit: timeLimit ?? const Duration(seconds: 10),
      );
      return position;
    } catch (e) {
      if (e is LocationServiceException) {
        rethrow;
      }
      throw LocationException(
        'Failed to get current location: ${e.toString()}',
      );
    }
  }

  /// Get current location coordinates (latitude and longitude)
  /// Returns a Map with 'latitude' and 'longitude' keys
  static Future<Map<String, double>> getCurrentLocationCoordinates() async {
    try {
      final position = await getCurrentLocation();
      return {'latitude': position.latitude, 'longitude': position.longitude};
    } catch (e) {
      rethrow;
    }
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open app settings for location permissions
  static Future<bool> openLocationSettings() async {
    return await openAppSettings();
  }
}

/// Custom exception for location permission errors
class LocationPermissionException implements Exception {
  final String message;
  LocationPermissionException(this.message);

  @override
  String toString() => message;
}

/// Custom exception for location service errors
class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() => message;
}

/// Custom exception for general location errors
class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}

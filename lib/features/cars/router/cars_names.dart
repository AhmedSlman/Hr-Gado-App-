/// Cars feature route paths
class CarsRoutes {
  static const String cars = '/cars';
  static const String myCar = '/cars/my-car';
  static const String addCar = '/cars/add';
  static String carDetails(int carId) => '/cars/$carId';

  /// Extract carId from path
  static int? extractCarId(String path) {
    try {
      final parts = path.split('/');
      if (parts.length >= 3 && parts[1] == 'cars') {
        final idStr = parts[2];
        if (idStr != 'my-car') {
          return int.parse(idStr);
        }
      }
    } catch (e) {
      // ignore
    }
    return null;
  }
}

import 'package:geolocator/geolocator.dart';

String distanceBetweenPoint(
    double lat1, double long1, double lat2, double long2) {
  double distance = Geolocator.distanceBetween(lat1, long1, lat2, long2);
  // convert meter to mile
  distance *= 0.0006213712;

  return distance.toStringAsFixed(2) + ' Mile';
}

import 'package:geolocator/geolocator.dart';
import 'package:mash/main.dart';

Future<Position> getUserLocation() async {
  authController.loading.value = true;
  bool serviceEnabled;
  LocationPermission permission;
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      authController.isLocationEnabled.value = false;
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    authController.isLocationEnabled.value = false;
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position? position = await Geolocator.getLastKnownPosition();
  if (position == null) {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest);
  }
  authController.lat.value = position.latitude;
  authController.lon.value = position.longitude;
  authController.loading.value = false;
  return position;
}

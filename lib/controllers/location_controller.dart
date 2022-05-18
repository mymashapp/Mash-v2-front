import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:get/get.dart';

class LocationController extends GetxController implements GetxService {
  Future<Position> getCurrentPosition() async {
    await _checkLocationPermission();

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getCurrentZipCode(double lat, double lng) async {
    GoogleMapsGeocoding geocoding = GoogleMapsGeocoding(
      apiKey: 'AIzaSyArgtGCvxqhaW-EdFHnSeI4vTANeGvRFTg',
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    GeocodingResponse response =
        await geocoding.searchByLocation(Location(lat: lat, lng: lng));

    for (GeocodingResult result in response.results) {
      AddressComponent component = result.addressComponents
          .firstWhere((element) => element.types.contains('postal_code'));

      return Future.value(component.longName);
    }

    return Future.value('');
  }

  _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      // show error dailog
    } else if (permission == LocationPermission.deniedForever) {
      // show setting dailog to enable location
    } else {}
  }
}

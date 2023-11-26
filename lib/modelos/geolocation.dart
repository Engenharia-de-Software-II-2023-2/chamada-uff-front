import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Geolocation {
    final double latitude;
    final double longitude;

    const Geolocation({
    required this.latitude,
    required this.longitude,
    });

  // request de current position, insert in a list e check the time to send the list
  static Future<Geolocation> getGeolocation() async {
    Position position = await determinePosition();

    final Geolocation geolocation = Geolocation(
      latitude: position.latitude,
      longitude: position.longitude
    );
    return geolocation;
  }

  //check permission e capture the current position
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
          return Future.error('Location Permissions are denied');
      }
    }
    return Geolocator.getCurrentPosition();
  }
}
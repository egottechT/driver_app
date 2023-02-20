import 'package:location/location.dart';

Future<LocationData> getCurrentLocation() async {
  Location currentLocation = Location();
  var location = await currentLocation.getLocation();
  return location;
}
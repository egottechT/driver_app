import 'package:driver_app/service/database.dart';
import 'package:location/location.dart';

Future<LocationData> getCurrentLocation() async {
  Location currentLocation = Location();
  var location = await currentLocation.getLocation();
  return location;
}

Map getDummyData(){
  Map map = {
    "title": "Aryan text",
    "body": "Please Pickup me",
    "phoneNumber": "84492",
    "destination": {
      "lat": 30.2939471,
      "long": 78.0578826,
      "location":
      "Rispana Pull, Dehradun, Uttarakhand, India",
    },
    "pick-up": {
      "location":
      "73JM+573, Nehrugram, Dehradun, Uttarakhand 248005, India",
      "lat":30.2803492,
      "long": 78.0831859,
    },
    "price": 300,
    "driver": false
  };
  uploadDummyData(map);
  return map;
}
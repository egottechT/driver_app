import 'dart:io';

import 'package:driver_app/service/database.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

Future<LocationData> getCurrentLocation() async {
  Location currentLocation = Location();
  var location = await currentLocation.getLocation();
  return location;
}

Map documentsValue = {
  "identityDetail": false,
  "aadharCard": false,
  "addressProof": false,
  "driverLicence": false,
  "vehicleInsurance": false,
  "passbookPhoto": false,
  "panCard": false,
  "pollutionCertificate": false,
  "rcCertificate": false,
  "vehiclePermit": false,
  "fitnessCertificate": false,
  "vehcileAudit": false,
};

Map getDummyData(){
  Map map = {
    "title": "Aryan text",
    "body": "Please Pickup me",
    "phoneNumber": "84492",
    "destination": {
      "lat": 30.2939471,
      "long": 78.0578826,
      "location":
      "Rispana Pull, Dehradun,248001 ,jksdf ajlsdf ajllsadfl fasdfjl, Uttarakhand, India",
    },
    "pick-up": {
      "location":
      "73JM+573, Nehrugram, Dehradun, Uttarakhand 248005, India",
      "lat":30.2803492,
      "long": 78.0831859,
    },
    "price": 300,
    "distance": "10.5",
    "isFinished": true,
    "id": "9Tae9quZkEREdLErYUqUDmhmegk2"
  };
  uploadDummyData(map);
  return map;
}

Future<Uint8List> getImages(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

void correctCameraAngle(LatLng start, LatLng destination, GoogleMapController controller) {
  double startLatitude = start.latitude;
  double startLongitude = start.longitude;
  double destinationLatitude = destination.latitude;
  double destinationLongitude = destination.longitude;

  double miny = (startLatitude <= destinationLatitude)
      ? startLatitude
      : destinationLatitude;
  double minx = (startLongitude <= destinationLongitude)
      ? startLongitude
      : destinationLongitude;
  double maxy = (startLatitude <= destinationLatitude)
      ? destinationLatitude
      : startLatitude;
  double maxx = (startLongitude <= destinationLongitude)
      ? destinationLongitude
      : startLongitude;

  double southWestLatitude = miny;
  double southWestLongitude = minx;
  double northEastLatitude = maxy;
  double northEastLongitude = maxx;
  controller.animateCamera(
    CameraUpdate.newLatLngBounds(
      LatLngBounds(
        northeast: LatLng(northEastLatitude, northEastLongitude),
        southwest: LatLng(southWestLatitude, southWestLongitude),
      ),
      100.0,
    ),
  );
}

final ImagePicker _picker = ImagePicker();
Future<File?> selectImage(context) async{
  try{
    final XFile? selectedImg =
    await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImg == null) {
      return null;
    }
    return File(selectedImg.path);

  } on PlatformException catch(error){
    context.showErrorSnackBar(message: "Can't pick Images !\nError: ${error.message}");
  }
  return null;
}
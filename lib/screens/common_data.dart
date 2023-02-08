import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Uint8List> getImages(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

void correctCameraAngle(LatLng start, LatLng destination, GoogleMapController controller) async {
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
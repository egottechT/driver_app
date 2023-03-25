import 'dart:convert';
import 'dart:typed_data';
import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/pickup_screens/pickup_screen.dart';
import 'package:driver_app/service/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocalNoticeService {
  static bool sendNotification = false;

  final databaseReference = FirebaseDatabase(
          databaseURL:
              "https://book-my-etaxi-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref();

  Future<LatLng> getCurrentLocation() async {
    Location currentLocation = Location();
    var location = await currentLocation.getLocation();
    return LatLng(location.latitude as double, location.longitude as double);
  }

  void showNotificationSystem(Map map, BuildContext context, String key) async {
    bool showing = true;

    var destination = LatLng(
        map["pick-up"]["lat"].toDouble(), map["pick-up"]["long"].toDouble());
    var start = await getCurrentLocation();

    final travelTime = await calculateTravelTime(start, destination);
    String totalTime = formatDuration(travelTime);
    // String totalTime = "5 im";
    await _createPolylines(start.latitude, start.longitude,
        destination.latitude, destination.longitude);
    Set<Marker> makers = {};
    Uint8List markIcons = await getImages('assets/icons/green_pin.png', 150);

    Marker strtMarker = Marker(
      markerId: const MarkerId("Pick-up"),
      position: start,
      infoWindow: const InfoWindow(title: "My Location", snippet: "My car"),
      icon: BitmapDescriptor.fromBytes(markIcons),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("Destination"),
      position: destination,
      infoWindow: const InfoWindow(title: "My Location", snippet: "My car"),
      icon: BitmapDescriptor.fromBytes(markIcons),
    );

    if (context.mounted) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text(
                "New Pickup Request",
                style: TextStyle(color: Colors.black),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 2,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconWithText(
                          Image.asset(
                            "assets/icons/watch.png",
                            scale: 2.5,
                          ),
                          totalTime,
                          "Min. Time"),
                      iconWithText(
                          Image.asset(
                            "assets/icons/rupee_bag.png",
                            scale: 8,
                          ),
                          "${map["price"]} ₹",
                          "Esti. Earn"),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Pick-up :- "),
                    TextSpan(
                      text: map["pick-up"]["location"],
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    )
                  ])),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Destination :- "),
                    TextSpan(
                      text: map["destination"]["location"],
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    )
                  ])),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width - 50,
                    child: GoogleMap(
                      polylines: Set<Polyline>.of(polylines.values),
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(map["pick-up"]["lat"].toDouble(),
                            map["pick-up"]["long"].toDouble()),
                        zoom: 16,
                      ),
                      markers: makers, //MARKERS IN MAP
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, elevation: 0),
                  child: const Text(
                    "REJECT",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    showing = false;
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, elevation: 0),
                  child: const Text(
                    "ACCEPT",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    debugPrint("Accept clicked");
                    showing = false;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PickUpScreen(
                              map: map,
                              isPickUp: true,
                            )));
                  },
                ),
              ],
            );
          });
    }
    makers.add(strtMarker);
    makers.add(destinationMarker);

    FlutterBeep.playSysSound(41);

    for (int i = 1; i <= 30; i++) {
      if (!showing) {
        return;
      }
      await Future.delayed(const Duration(seconds: 1));
      FlutterBeep.playSysSound(24);
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<Duration> calculateTravelTime(
      LatLng origin, LatLng destination) async {
    final apiUrl =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$mapApiKey';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final durationInSeconds =
          data['rows'][0]['elements'][0]['duration']['value'];
      return Duration(seconds: durationInSeconds);
    } else {
      throw Exception('Failed to calculate travel time');
    }
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    final hourString = hours.toString().padLeft(2, '0');
    final minutesString = minutes.toString().padLeft(2, '0');

    if (hourString == "00") {
      return '$minutesString minutes';
    }
    return '$hourString : $minutesString hours';
  }

  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  Future<void> _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapApiKey, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  Future<void> readData(BuildContext context,Function changeToggleValue) async {
    debugPrint("Reading data");
    databaseReference.child('trips').onChildAdded.listen((event) {
      Map map = event.snapshot.value as Map;
      String key = event.snapshot.key.toString();
      // debugPrint(map.toString());
      if (sendNotification) {
        sendNotification = false;
        customerKey = key;
        showNotificationSystem(map, context, key);
      }
    });
  }

  iconWithText(Image icon, String s, String t) {
    TextStyle largeText = const TextStyle(
        color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold);
    TextStyle smallText = const TextStyle(color: Colors.grey, fontSize: 15);
    return Column(
      children: [
        icon,
        const SizedBox(
          height: 5,
        ),
        Text(
          s,
          style: largeText,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          t,
          style: smallText,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/common_data.dart';
import 'package:driver_app/screens/pickup_screens/pickup_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  void showNotificationSystem(
      Map map, BuildContext context, Function function) async {
    bool showing = true;

    var start = LatLng(double.parse(map["lat"]), double.parse(map["long"]));
    var destination = await getCurrentLocation();

    await _createPolylines(start.latitude, start.longitude,
        destination.latitude, destination.longitude);
    Set<Marker> _makers = {};
    Marker strtMarker = Marker(
      markerId: MarkerId("Pick-up"),
      position: start,
      infoWindow: InfoWindow(title: "My Location", snippet: "My car"),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("Destination"),
      position: destination,
      infoWindow: InfoWindow(title: "My Location", snippet: "My car"),
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
                          "5 min",
                          "Min. Time"),
                      iconWithText(
                          Image.asset(
                            "assets/icons/rupee_bag.png",
                            scale: 8,
                          ),
                          "4.49 \₹",
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
                    TextSpan(text: "Pick-up :- "),
                    TextSpan(
                      text: map["pick-up"],
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    )
                  ])),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: "Destination :- "),
                    TextSpan(
                      text: map["destination"],
                      style: TextStyle(overflow: TextOverflow.ellipsis),
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
                      onMapCreated: (controller) async {
                        // correctCameraAngle(start, destination, controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(double.parse(map["lat"]),
                            double.parse(map["long"])),
                        zoom: 17,
                      ),
                      markers: _makers, //MARKERS IN MAP
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
                    showing = false;
                    function(map);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PickUpScreen(map: map)));
                  },
                ),
              ],
            );
          });
    }
    _makers.add(strtMarker);
    _makers.add(destinationMarker);

    FlutterBeep.playSysSound(41);

    for (int i = 1; i <= 10; i++) {
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
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  void readData(BuildContext context, Function function) {
    databaseReference.child('active_driver').onChildAdded.listen((event) {
      Map map = event.snapshot.value as Map;
      if (sendNotification) {
        showNotificationSystem(map, context, function);
      }
    });
  }

  iconWithText(Image icon, String s, String t) {
    TextStyle largeText = const TextStyle(
        color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold);
    TextStyle smallText = TextStyle(color: Colors.grey, fontSize: 15);
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

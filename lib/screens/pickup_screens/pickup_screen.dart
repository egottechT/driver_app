import 'package:bubble_head/bubble.dart';
import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/pickup_screens/bottom_panel.dart';
import 'package:driver_app/service/database.dart';
import 'package:driver_app/service/location_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class PickUpScreen extends StatefulWidget {
  final Map map;
  final bool isPickUp;

  const PickUpScreen({Key? key, required this.map, required this.isPickUp})
      : super(key: key);

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> with WidgetsBindingObserver {
  late GoogleMapController mapController;
  String location = "Pick-up";
  Set<Marker> markers = {};
  Uint8List? markIcons;
  LatLng startLocation = const LatLng(0, 0);
  late LatLng destinationLocation;
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  late SharedPreferences prefs;
  String carType = "mini";

  void readData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      carType = prefs.getString("car_type") ?? "mini";
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    readData();
    if (widget.isPickUp) {
      destinationLocation = LatLng(widget.map["pick-up"]["lat"].toDouble(),
          widget.map["pick-up"]["long"].toDouble());
    } else {
      destinationLocation = LatLng(widget.map["destination"]["lat"].toDouble(),
          widget.map["destination"]["long"].toDouble());
    }
    polylinePoints = PolylinePoints();
    checkDataChanges(context);
    notificationChangeMessages();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    bool inactive = state == AppLifecycleState.inactive;
    bool paused = state == AppLifecycleState.paused;
    bool detached = state == AppLifecycleState.detached;

    if (inactive || detached) return;

    if (paused) {
      startBubbleHead();
    } else {
      debugPrint("Close bubble");
    }
  }

  final Bubble _bubble = Bubble(showCloseButton: false);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> startBubbleHead() async {
    try {
      await _bubble.startBubbleHead(sendAppToBackground: false);
    } catch (exception) {
      debugPrint('Failed to call startBubbleHead ${exception.toString()}');
    }
  }

  void uploadDriverDetails(LocationData currentLocation) async {
    debugPrint("Inside function");
    try {
      getUserInfo(context, FirebaseAuth.instance.currentUser!.uid.toString(),
          currentLocation);
    } catch (e) {
      context.showErrorSnackBar(
          message:
              "Sorry, there is some error. Please check you internet connection and try again");
      Navigator.of(context).pop();
    }
  }

  void updateLocationDriver() {
    Location location = Location();
    location.onLocationChanged.listen((newLocation) {
      if (startLocation.longitude != 0) {
        LatLng value = LatLng(
            newLocation.latitude as double, newLocation.longitude as double);
        double distance = calculateDistance(startLocation, value);
        if (distance > 40.0) {
          debugPrint("Distance is :- $distance");
          updateLatLng(value);
        }
      }
    });
  }

  Future<LocationData> getCurrentLocation() async {
    debugPrint("Fetching data");
    Location currentLocation = Location();
    var location = await currentLocation.getLocation();
    startLocation =
        LatLng(location.latitude as double, location.longitude as double);
    markIcons = await getImages('assets/icons/driver_car.png', 150);

    Marker tmpMarker = Marker(
      markerId: const MarkerId("My location"),
      position: LatLng((location.latitude!), (location.longitude!)),
      infoWindow: const InfoWindow(title: "My Location", snippet: "My car"),
      icon: BitmapDescriptor.fromBytes(markIcons!),
    );

    setState(() {
      markers.add(tmpMarker);
    });
    correctCameraAngle(startLocation, destinationLocation, mapController);
    _createPolylines(startLocation.latitude, startLocation.longitude,
        destinationLocation.latitude, destinationLocation.longitude);
    return location;
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    LocationData currentLocation = await getCurrentLocation();
    uploadDriverDetails(currentLocation);
    updateLocationDriver();
    markIcons = await getImages('assets/icons/green_pin.png', 150);
    Marker strtMarker = Marker(
      markerId: const MarkerId("Pick-up"),
      position: destinationLocation,
      infoWindow: const InfoWindow(title: "My Location", snippet: "My car"),
      icon: BitmapDescriptor.fromBytes(markIcons!),
    );

    setState(() {
      if (widget.isPickUp) {
        location = widget.map["pick-up"]["location"];
      } else {
        location = widget.map["destination"]["location"];
      }
      markers.add(strtMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.35;
    final panelHeightOpened = MediaQuery.of(context).size.height * 0.5;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isPickUp ? "Pick-up Location" : "Destination Location",
                style: TextStyle(color: secondaryColor),
              ),
              backgroundColor: primaryColor,
              iconTheme: IconThemeData(color: secondaryColor),
            ),
            resizeToAvoidBottomInset: true,
            body: SlidingUpPanel(
                panelBuilder: (controller) {
                  return bottomPanelLayout(
                      widget.map, context, widget.isPickUp, carType);
                },
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                minHeight: panelHeightClosed,
                maxHeight: panelHeightOpened,
                body: Stack(children: <Widget>[
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 16,
                    ),
                    markers: markers,
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: secondaryColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "LOCATION",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: secondaryColor),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      location,
                                      style: const TextStyle(
                                          overflow: TextOverflow.clip),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () async {
                                      await openMap(destinationLocation.latitude,
                                          destinationLocation.longitude);
                                      startBubbleHead();
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.assistant_navigation,
                                          color: secondaryColor,
                                          size: 45,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text("Navigate")
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        )),
                  )
                ]))));
  }

  Future<void> openMap(double latitude, double longitude) async {
    String routeUrl =
        "https://www.google.com/maps/dir/${startLocation.latitude},${startLocation.longitude}/${destinationLocation.latitude},${destinationLocation.longitude}";
    // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(routeUrl)) {
      await launch(routeUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<void> _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
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
    setState(() {
      polylines[id] = polyline;
    });
  }
}

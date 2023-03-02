import 'dart:typed_data';

import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/common_data.dart';
import 'package:driver_app/screens/pickup_screens/bottom_panel.dart';
import 'package:driver_app/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class PickUpScreen extends StatefulWidget {
  final Map map;
  final bool isPickUp;
  const PickUpScreen({Key? key, required this.map,required this.isPickUp}) : super(key: key);

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  late GoogleMapController mapController;
  String location = "Pick-up";
  Set<Marker> markers = {};
  Uint8List? markIcons;
  late LatLng startLocation;
  late LatLng destinationLocation;
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    if(widget.isPickUp) {
      destinationLocation = LatLng(widget.map["pick-up"]["lat"].toDouble(), widget.map["pick-up"]["long"].toDouble());
    }
    else{
      destinationLocation = LatLng(widget.map["destination"]["lat"].toDouble(), widget.map["destination"]["long"].toDouble());
    }
    polylinePoints = PolylinePoints();
    uploadDriverDetails();
    updateLocationDriver();
  }

  void uploadDriverDetails() async {
    debugPrint("Inside function");
    LocationData currentLocation = await getCurrentLocation(true);
    debugPrint("Location fetch complete");
    if(context.mounted) {
      debugPrint("Get user info");
      getUserInfo(context,FirebaseAuth.instance.currentUser!.uid.toString(),currentLocation);
    }
  }

  void  updateLocationDriver(){
    Location location = Location();
    location.onLocationChanged.listen((newLocation) {
      LatLng value = LatLng(newLocation.latitude as double, newLocation.longitude as double);
      updateLatLng(value);
    });
  }

  Future<LocationData> getCurrentLocation(bool uploading) async {
    Location currentLocation = Location();
    var location = await currentLocation.getLocation();
    if(uploading) {
      return location;
    }
    startLocation = LatLng(location.latitude as double, location.longitude as double);
    markIcons = await getImages('assets/icons/driver_car.png', 150);

    Marker tmpMarker = Marker(
      markerId: const MarkerId("My location"),
      position: LatLng(
          (location.latitude!), (location.longitude!)),
      infoWindow: const InfoWindow(title: "My Location", snippet: "My car"),
      icon: BitmapDescriptor.fromBytes(markIcons!),
    );

    setState(() {
      markers.add(tmpMarker);
    });
    correctCameraAngle(startLocation,destinationLocation,mapController);
    _createPolylines(startLocation.latitude,startLocation.longitude,destinationLocation.latitude,destinationLocation.longitude);
    return location;
  }

  void _onMapCreated(GoogleMapController controller) async  {
    mapController = controller;
    getCurrentLocation(false);
    markIcons = await getImages('assets/icons/green_pin.png', 150);
    Marker strtMarker = Marker(
      markerId: const MarkerId("Pick-up"),
      position: destinationLocation,
      infoWindow: const InfoWindow(title: "My Location", snippet: "My car"),
      icon: BitmapDescriptor.fromBytes(markIcons!),
    );

    setState(() {
      if(widget.isPickUp) {
        location = widget.map["pick-up"]["location"];
      }
      else{
        location = widget.map["destination"]["location"];
      }
      markers.add(strtMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.25;
    final panelHeightOpened = MediaQuery.of(context).size.height * 0.8;

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
                  return bottomPanelLayout(widget.map,context);
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
                      zoom: 17,
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
                                    onTap: () {
                                      openMap(destinationLocation.latitude,destinationLocation.longitude);
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
      travelMode: TravelMode.transit,
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

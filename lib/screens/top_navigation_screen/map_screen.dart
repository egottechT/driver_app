import 'dart:typed_data';

import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/repository/trip_repo.dart';
import 'package:driver_app/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final LatLng center;

  const MapScreen({super.key, required this.center});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final double zoomLevel = 16;
  late GoogleMapController mapController;
  Set<Marker> makers = {};
  Uint8List? markIcons;
  List<dynamic> list = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() async {
    await UserRepo().getUserInformation(context);
    setState(() {
      isLoading = false;
    });
  }

  void mapSetupWork(LocationData location) async {
    markIcons = await getImages('assets/icons/driver_car.png', 150);

    Marker tmpMarker = Marker(
      markerId: const MarkerId("My location"),
      position: LatLng((location.latitude!), (location.longitude!)),
      infoWindow: const InfoWindow(title: "My Location", snippet: "My car"),
      icon: BitmapDescriptor.fromBytes(markIcons!),
    );

    setState(() {
      makers.add(tmpMarker);
    });

    CameraPosition home = CameraPosition(
        target:
            LatLng(location.latitude as double, location.longitude as double),
        zoom: zoomLevel);

    mapController.animateCamera(CameraUpdate.newCameraPosition(home));
  }

  Widget buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        LocationData location = await getCurrentLocation();
        mapSetupWork(location);
        // Map map = getDummyData();
        TripRepo().updateLocationForMe(
            LatLng(location.latitude as double, location.longitude as double));
        // getDummyData();
      },
      backgroundColor: Colors.white,
      child: const Icon(
        Icons.gps_fixed,
        color: Colors.blue,
      ),
    );
  }

  void setTheMarkers(LatLng location) async {
    Marker marker = Marker(
      markerId: const MarkerId("Pickup"),
      position: location,
      infoWindow: const InfoWindow(title: "Pickup", snippet: "Aryan Bisht"),
    );

    setState(() {
      makers.add(marker);
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    LocationData location = LocationData.fromMap({
      'latitude': widget.center.latitude,
      'longitude': widget.center.longitude,
    });
    mapSetupWork(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(children: <Widget>[
                GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: widget.center,
                    zoom: zoomLevel,
                  ),
                  markers: makers, //MARKERS IN MAP
                ),
                Positioned(bottom: 25, right: 25, child: buildFAB(context))
              ]));
  }
}

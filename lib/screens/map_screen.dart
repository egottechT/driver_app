import 'dart:typed_data';
import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/common_data.dart';
import 'package:driver_app/service/database.dart';
import 'package:driver_app/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final double zoomLevel = 16;
  late GoogleMapController mapController;
  Set<Marker> makers = {};
  Uint8List? markIcons;
  List<dynamic> list = [];

  @override
  void initState() {
    LocalNoticeService().readData(context);
    super.initState();
  }

  void mapSetupWork(LocationData location) async {
    markIcons = await getImages('assets/icons/driver_car.png', 150);

    Marker tmpMarker = Marker(
      markerId: const MarkerId("My location"),
      position: LatLng(
          (location.latitude!), (location.longitude!)),
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

  void _onMapCreated(GoogleMapController controller) async  {
    mapController = controller;
    LocationData location = await getCurrentLocation();
    mapSetupWork(location);
  }

  int currentIndex = 0;
  bool toggleValue = false;

  Widget topNavigationBar() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 75,
        color: secondaryColor,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: searchBarWidget(
                    0,
                    const ImageIcon(
                      AssetImage("assets/icons/home.png"),
                      size: 30,
                      color: Colors.white,
                    ),
                    "Home")),
            Expanded(
                flex: 1,
                child: searchBarWidget(
                    1,
                    const ImageIcon(
                      AssetImage("assets/icons/money.png"),
                      size: 30,
                      color: Colors.white,
                    ),
                    "Earning")),
            Expanded(
                flex: 1,
                child: searchBarWidget(
                    2,
                    const ImageIcon(
                      AssetImage("assets/icons/rating.png"),
                      size: 30,
                      color: Colors.white,
                    ),
                    "Rating")),
            Expanded(
                flex: 1,
                child: searchBarWidget(
                    3,
                    const ImageIcon(
                      AssetImage("assets/icons/account_person.png"),
                      size: 30,
                      color: Colors.white,
                    ),
                    "Account")),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Switch(
                      // thumb color (round icon)
                      activeColor: Colors.white,
                      activeTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.blueGrey.shade600,
                      inactiveTrackColor: Colors.grey.shade400,
                      splashRadius: 50.0,
                      activeThumbImage:
                          Image.asset("assets/icons/active_button.png").image,
                      // boolean variable value
                      value: toggleValue,
                      // changes the state of the switch
                      onChanged: (value) async {
                        setState(() {
                          toggleValue = value;
                        });
                        LocalNoticeService.sendNotification = value;
                      },
                    ),
                    toggleValue
                        ? const Text("Online", style: TextStyle(color: Colors.white))
                        : const Text("offline",
                            style: TextStyle(color: Colors.white)),
                  ],
                )),
          ],
        ));
  }

  Widget searchBarWidget(int index, ImageIcon icon, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              icon,
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          (currentIndex == index)
              ? SizedBox(
                  height: 5,
                  child: Container(
                    color: Colors.white,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as LatLng;

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(children: <Widget>[
              GoogleMap(
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: args,
                  zoom: zoomLevel,
                ),
                markers: makers, //MARKERS IN MAP
              ),
              Positioned(top: 0, child: topNavigationBar()),
              Positioned(bottom: 25, right: 25, child: buildFAB(context))
            ]
            )
        )
    );
  }
}

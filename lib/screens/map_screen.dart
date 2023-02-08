import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final double zoomLevel = 19;
  late GoogleMapController mapController;
  Set<Marker> _makers = {};
  final LatLng _center = const LatLng(20.5937, 78.9629);
  Uint8List? markIcons;
  List<dynamic> list = [];
  final _panelcontroller = PanelController();

  @override
  void initState() {
    LocalNoticeService().readData(context, onAcceptRequest);
    super.initState();
  }

  Future<LocationData> getCurrentLocation() async {
    Location currentLocation = Location();
    var location = await currentLocation.getLocation();
    markIcons = await getImages('assets/icons/driver_car.png', 150);

    Marker tmpMarker = Marker(
      markerId: MarkerId("My location"),
      position: LatLng(
          (location.latitude!) as double, (location.longitude!) as double),
      infoWindow: InfoWindow(title: "My Location", snippet: "My car"),
      icon: BitmapDescriptor.fromBytes(markIcons!),
    );

    setState(() {
      _makers.add(tmpMarker);
    });

    CameraPosition _home = CameraPosition(
        target:
            LatLng(location.latitude as double, location.longitude as double),
        zoom: zoomLevel);

    mapController.animateCamera(CameraUpdate.newCameraPosition(_home));
    return location;
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

  Widget buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // getCurrentLocation();
        Map map = Map();
        map["lat"] = "30.268486";
        map["long"] = "78.0765925";
        map["pick-up"] = "Lower Nehrugram, Dehradun, 248001";
        map["destination"] = "Mohkampur, Dehradun, 248001";
        LocalNoticeService()
            .showNotificationSystem(map, context, onAcceptRequest);
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
      _makers.add(marker);
    });
  }

  void onAcceptRequest(Map map) {
    var location = LatLng(double.parse(map["lat"]), double.parse(map["long"]));
    setTheMarkers(location);

    CameraPosition _cameraPosition =
        CameraPosition(target: location, zoom: zoomLevel);
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    // openMap(double.parse(map["lat"]), double.parse(map["long"]));
  }

  Future<void> openMap(double latitude, double longitude) async {
    var location = await getCurrentLocation();
    String routeUrl =
        "https://www.google.com/maps/dir/${location.latitude},${location.longitude}/$latitude,$longitude";
    // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(routeUrl)) {
      await launch(routeUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getCurrentLocation();
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
              SizedBox(
                height: 10,
              ),
              icon,
              Text(
                text,
                style: TextStyle(color: Colors.white),
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
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(children: <Widget>[
              GoogleMap(
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: zoomLevel,
                ),
                markers: _makers, //MARKERS IN MAP
              ),
              Positioned(top: 0, child: topNavigationBar()),
              Positioned(bottom: 25, right: 25, child: buildFAB(context))
            ]
            )
        )
    );
  }
}

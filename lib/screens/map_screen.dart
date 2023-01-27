import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:driver_app/service/background_service.dart';
import 'package:driver_app/service/notification_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';

// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locate;
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final double zoomLevel = 19;
  late GoogleMapController mapController;
  Set<Marker> _makers = {};
  LatLng _center = const LatLng(20.5937, 78.9629);
  Uint8List? markIcons;
  List<dynamic> list = [];
  final _panelcontroller = PanelController();

  @override
  void initState() {
    LocalNoticeService().readData(context);
    super.initState();
  }

  void getCurrentLocation() async {
    locate.Location currentLocation = locate.Location();
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
        getCurrentLocation();
      },
      backgroundColor: Colors.white,
      child: Icon(
        Icons.gps_fixed,
        color: Colors.blue,
      ),
    );
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
        color: Colors.orange,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: searchBarWidget(
                    0,
                    Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.white,
                    ),
                    "Home")),
            Expanded(
                flex: 1,
                child: searchBarWidget(
                    1,
                    Icon(
                      Icons.money_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    "Home")),
            Expanded(
                flex: 1,
                child: searchBarWidget(
                    2,
                    Icon(
                      Icons.star_half,
                      size: 30,
                      color: Colors.white,
                    ),
                    "Home")),
            Expanded(
                flex: 1,
                child: searchBarWidget(
                    3,
                    Icon(
                      Icons.person_4_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    "Home")),
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
                      // boolean variable value
                      value: toggleValue,
                      // changes the state of the switch
                      onChanged: (value) async {
                        setState(() {
                          toggleValue = value;
                        });
                        LocalNoticeService.sendNotification = value;
                        debugPrint(
                            "Values are:- ${LocalNoticeService.sendNotification} ${value}");
                        // var service = FlutterBackgroundService();
                        // var isRunning = await service.isRunning();
                        // if (toggleValue){
                        //   if(!isRunning){
                        //     await initializeService();
                        //     service.startService();
                        //     service.invoke("setAsBackground");
                        //   }
                        // }
                        // else {
                        //   if (isRunning) {
                        //     service.invoke("stopService");
                        //   }
                        // }
                      },
                    ),
                    toggleValue
                        ? Text("Online", style: TextStyle(color: Colors.white))
                        : Text("offline",
                            style: TextStyle(color: Colors.white)),
                  ],
                )),
          ],
        ));
  }

  Widget searchBarWidget(int index, Icon icon, String text) {
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
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.2;
    final panelHeightOpened = MediaQuery.of(context).size.height * 0.8;
    double fabHeightBottom = 350;

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SlidingUpPanel(
                controller: _panelcontroller,
                panelBuilder: (controller) {
                  //TODO Change this return statement
                  return Container(
                    color: Colors.grey[350],
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TODAY'S TRIP",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: Image.asset("assets/images/car.png"),
                              title: Text("8 Trips"),
                              subtitle: Row(
                                children: [
                                  Icon(Icons.lock_clock),
                                  Text("8 hours online")
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    "\$ 28.55",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500]),
                                  ),
                                  Text("Earned")
                                ],
                              ),
                            ))
                      ],
                    ),
                  );
                },
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                minHeight: panelHeightClosed,
                maxHeight: panelHeightOpened,
                onPanelSlide: (position) {
                  setState(() {
                    final panelMaxPos = panelHeightOpened - panelHeightClosed;
                    fabHeightBottom = position * panelMaxPos + 300;
                  });
                },
                body: Stack(children: <Widget>[
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: zoomLevel,
                    ),
                    markers: _makers, //MARKERS IN MAP
                  ),
                  Positioned(top: 0, child: topNavigationBar()),
                  Positioned(bottom: 250, right: 10, child: buildFAB(context))
                ]
                )
            )
        )
    );
  }
}

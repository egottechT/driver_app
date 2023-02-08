import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({Key? key}) : super(key: key);

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {

  final _panelcontroller = PanelController();
  late GoogleMapController mapController;

  Future<LocationData> getCurrentLocation() async {
    Location currentLocation = Location();
    var location = await currentLocation.getLocation();
    CameraPosition _home = CameraPosition(
        target:
        LatLng(location.latitude as double, location.longitude as double),
        zoom: 17);

    mapController.animateCamera(CameraUpdate.newCameraPosition(_home));
    return location;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getCurrentLocation();
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
                      target: LatLng(0,0),
                      zoom: 17,
                    ),
                  ),
                ]))));
  }
}

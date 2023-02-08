import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/pickup_screens/bottom_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PickUpScreen extends StatefulWidget {
  final Map map;

  const PickUpScreen({Key? key, required this.map}) : super(key: key);

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  final _panelcontroller = PanelController();
  late GoogleMapController mapController;
  String location = "Pick-up";

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
    setState(() {
      location = widget.map["pick-up"];
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
                "Pick-up Location",
                style: TextStyle(color: secondaryColor),
              ),
              backgroundColor: primaryColor,
              iconTheme: IconThemeData(color: secondaryColor),
            ),
            resizeToAvoidBottomInset: true,
            body: SlidingUpPanel(
                controller: _panelcontroller,
                panelBuilder: (controller) {
                  return bottomPanelLayout();
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
                                      debugPrint("Go to maps");
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.assistant_navigation,
                                          color: secondaryColor,
                                          size: 45,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Navigate")
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        )),
                  )
                ]
                )
            )
        )
    );
  }
}

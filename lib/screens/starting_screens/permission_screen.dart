import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/setting_screens/car_details_screens/select_vehicle_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  late bool location, phone;

  @override
  void initState() {
    super.initState();
    location = phone = false;
    readPermissions();
  }

  void readPermissions() async {
    location = await Permission.location.isGranted;
    phone = await Permission.contacts.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Allow Storage/Location/Phone Permission Required",
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              flex: 3, child: Image.asset("assets/images/splash_screen.png")),
          const Expanded(
              flex: 2,
              child: Center(
                  child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Text(
                  "For us to download/Location/Phone and training content on your device's by giving us permission",
                  style: TextStyle(fontSize: 18),
                ),
              ))),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () async {
                var contactRequest = await Permission.contacts.request();
                var locationRequest = await Permission.location.request();
                if(context.mounted){
                  if (locationRequest.isGranted) {
                    context.showSnackBar(
                        message: "Location Permission is Granted");
                    location = true;
                  }
                  if (contactRequest.isGranted) {
                    context.showSnackBar(
                        message: "Contact Permission is Granted");
                    phone = true;
                  }

                  if (location && phone && context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SelectVehicleScreen(isFromStart: true,)));
                  }
                }

              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text("CONTINUE"),
            ),
          ),
        ],
      ),
    ));
  }
}

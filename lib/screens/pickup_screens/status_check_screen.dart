import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/repository/driver_repo.dart';
import 'package:driver_app/screens/pickup_screens/pickup_screen.dart';
import 'package:flutter/material.dart';

class StatusCheckScreen extends StatefulWidget {
  final Map map;
  final bool isPickUp;

  const StatusCheckScreen({Key? key, required this.map, required this.isPickUp})
      : super(key: key);

  // const StatusCheckScreen({Key? key, })
  //     : super(key: key);
  @override
  State<StatusCheckScreen> createState() => _StatusCheckScreenState();
}

class _StatusCheckScreenState extends State<StatusCheckScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  void readData() async {
    bool status = await DriverRepo().checkAlreadyDriver();
    if (status) {
      context.showErrorSnackBar(
          message: "This ride is already taken by some other driver.");
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PickUpScreen(
              map: widget.map,
              isPickUp: widget.isPickUp,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

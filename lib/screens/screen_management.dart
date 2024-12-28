import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/pickup_screens/pickup_screen.dart';
import 'package:driver_app/screens/setting_screens/account_screen.dart';
import 'package:driver_app/screens/top_navigation_screen/earning_screen.dart';
import 'package:driver_app/screens/top_navigation_screen/map_screen.dart';
import 'package:driver_app/screens/top_navigation_screen/rating_screen.dart';
import 'package:driver_app/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:driver_app/widgets/elevated_button_style.dart';
import '../service/database.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({Key? key}) : super(key: key);

  @override
  State<ManagementScreen> createState() => _ManagementScreen();
}

class _ManagementScreen extends State<ManagementScreen> {
  int currentIndex = 0;
  bool toggleValue = LocalNoticeService.sendNotification;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    askPermissions();
    LocalNoticeService().readData(context);
  }

  void askPermissions() async {
    if (await Permission.systemAlertWindow.isDenied) {
      await Permission.systemAlertWindow.request();
    }
    prefs = await SharedPreferences.getInstance();
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
                      onChanged: changeToggleValue,
                    ),
                    toggleValue
                        ? const Text("Online",
                            style: TextStyle(color: Colors.white))
                        : const Text("offline",
                            style: TextStyle(color: Colors.white)),
                  ],
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    LatLng args = ModalRoute.of(context)!.settings.arguments as LatLng;

    return SafeArea(
        child: Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          if (prefs.containsKey("tripId")) {
            Map data = await DatabaseUtils()
                .findTripUsingId(prefs.getString("tripId") ?? "");
            bool isPickUp = prefs.getBool("isPickUp") ?? true;
            if (mounted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PickUpScreen(map: data, isPickUp: isPickUp)));
            }
          } else {
            context.showErrorSnackBar(
                message: "Currently there is no going booking");
          }
        },
        style: elevatedButtonStyle(backgroundColor: Colors.black),
        child: const Text("Current Booking"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          topNavigationBar(),
          [
            Expanded(
                child: MapScreen(
              center: args,
            )),
            const Expanded(child: EarningScreen()),
            const Expanded(child: RatingScreen()),
            const Expanded(child: AccountScreen()),
          ][currentIndex]
        ],
      ),
    ));
  }

  void changeToggleValue(value) async {
    setState(() {
      toggleValue = value;
    });
    LocalNoticeService.sendNotification = value;
  }
}

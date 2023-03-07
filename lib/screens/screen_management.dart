import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/account_screen.dart';
import 'package:driver_app/screens/map_screen.dart';
import 'package:driver_app/service/notification_service.dart';
import 'package:driver_app/tmp_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({Key? key}) : super(key: key);

  @override
  State<ManagementScreen> createState() => _ManagementScreen();
}

class _ManagementScreen extends State<ManagementScreen> {
  int currentIndex = 0;
  bool toggleValue = false;

  @override
  void initState() {
    super.initState();
    LocalNoticeService().readData(context, changeToggleValue);
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
                        ? const Text("Online", style: TextStyle(color: Colors.white))
                        : const Text("offline",
                        style: TextStyle(color: Colors.white)),
                  ],
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as LatLng;

    return SafeArea(child: Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          topNavigationBar(),
          [
            Expanded(child: MapScreen(center: args,)),
            const Expanded(child: TmpScreen()),
            const Expanded(child: TmpScreen()),
            const Expanded(child:AccountScreen()),
          ][currentIndex]
        ],
      ),
    ));
  }

  void changeToggleValue(value)async {
    setState(() {
      toggleValue = value;
    });
    LocalNoticeService.sendNotification = value;
  }
}

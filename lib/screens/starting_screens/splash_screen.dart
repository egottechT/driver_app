import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/service/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    User? user = FirebaseAuth.instance.currentUser;
    if(context.mounted){
      if (user != null) {
        LocationData location = await getCurrentLocation();
        if(context.mounted) {
          Navigator.of(context).pushReplacementNamed('/managementScreen',
            arguments: LatLng(
                location.latitude as double, location.longitude as double));
        }
      } else {
      signOut();
      Navigator.of(context).pushReplacementNamed('/loginScreen');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: primaryColor,
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/images/app_logo.png',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/images/splash_screen.png',
                      ),
                    ),
                  )
                ],
              ))),
    );
  }
}

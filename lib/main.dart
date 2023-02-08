import 'package:driver_app/provider/otp_listener.dart';
import 'package:driver_app/screens/pickup_screens/pickup_screen.dart';
import 'package:driver_app/screens/starting_screens/login_screen.dart';
import 'package:driver_app/screens/starting_screens/permission_screen.dart';
import 'package:driver_app/screens/starting_screens/select_vehicle_screen.dart';
import 'package:driver_app/screens/home_screen.dart';
import 'package:driver_app/screens/map_screen.dart';
import 'package:driver_app/screens/phone_verification_screens/phone_number_setup.dart';
import 'package:driver_app/screens/profile_screen.dart';
import 'package:driver_app/screens/registration_screen.dart';
import 'package:driver_app/screens/starting_screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await LocalNoticeService().setup();
  Map map = Map();
  map["pick-up"] = "Lower Nehrugram,Dehradun 248001";
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> OtpProvider())
      ],
      child: MaterialApp(
        title: 'Book My taxi Driver',
        routes: appPageRoutes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.grey[800]),
        ),
        home: PickUpScreen(map: map,),
      ),
    ),
  );
}

final Map<String, Widget Function(BuildContext)> appPageRoutes = {
  'splash': (_) => const SplashScreen(),
  '/loginScreen': (_) => const LoginScreen(),
  '/phoneNumberSetup': (_) => const PhoneNumberSetup(),
  '/registrationScreen': (_) => const RegistrationScreen(),
  '/homeScreen': (_) => const HomeScreen(),
  '/profileScreen': (_) => const ProfileScreen(),
  '/selectVehicleScreen': (_) => const SelectVehicleScreen(),
  '/permissionScreen': (_) => const PermissionScreen(),
  '/mapScreen': (_) => const MapScreen(),
};

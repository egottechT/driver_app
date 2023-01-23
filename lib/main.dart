import 'package:driver_app/screens/home_screen.dart';
import 'package:driver_app/screens/login_screen.dart';
import 'package:driver_app/screens/map_screen.dart';
import 'package:driver_app/screens/permission_screen.dart';
import 'package:driver_app/screens/phone_verification_screens/phone_number_setup.dart';
import 'package:driver_app/screens/profile_screen.dart';
import 'package:driver_app/screens/registration_screen.dart';
import 'package:driver_app/screens/select_vehicle_screen.dart';
import 'package:driver_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'Book My taxi Driver',
      routes: appPageRoutes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.grey[800]),
      ),
      home: PermissionScreen(),
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

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
      home: SplashScreen(),
    ),
  );
}

final Map<String, Widget Function(BuildContext)> appPageRoutes = {
  'splash': (_) => const SplashScreen(),
  // '/loginScreen': (_) => const LoginScreen(),
  // '/phoneNumberSetup': (_) => const PhoneNumberSetup(),
  // '/registrationScreen': (_) => const RegistrationScreen(),
  // '/homeScreen': (_) => const HomeScreen(),
  // '/mapScreen': (_) => MapsScreen(),
  // '/permissionScreen': (_) => const PermissionScreen(),
};

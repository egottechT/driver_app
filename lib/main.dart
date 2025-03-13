import 'dart:isolate';

import 'package:driver_app/firebase_options.dart';
import 'package:driver_app/provider/otp_listener.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/screens/phone_verification_screens/phone_number_setup.dart';
import 'package:driver_app/screens/screen_management.dart';
import 'package:driver_app/screens/setting_screens/account_screen.dart';
import 'package:driver_app/screens/starting_screens/login_screen.dart';
import 'package:driver_app/screens/starting_screens/permission_screen.dart';
import 'package:driver_app/screens/starting_screens/registration_screen.dart';
import 'package:driver_app/screens/starting_screens/splash_screen.dart';
import 'package:driver_app/screens/unused_screen/home_screen.dart';
import 'package:driver_app/screens/unused_screen/profile_screen.dart';
import 'package:driver_app/service/push_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().init();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
    return true;
  };
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
      fatal: false,
    );
  }).sendPort);
  // setDummyPreferences();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => UserModelProvider()),
      ],
      child: MaterialApp(
        title: 'Book My taxi Driver',
        routes: appPageRoutes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // Text color for ElevatedButton
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        initialRoute: "splash",
      ),
    ),
  );
}

void setDummyPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isPickUp", false);
  prefs.setString("tripId", "-NbFD2IzNa_I6yKtVdF8");
}

final Map<String, Widget Function(BuildContext)> appPageRoutes = {
  'splash': (_) => const SplashScreen(),
  '/loginScreen': (_) => const LoginScreen(),
  '/managementScreen': (_) => const ManagementScreen(),
  '/phoneNumberSetup': (_) => const PhoneNumberSetup(),
  '/registrationScreen': (_) => const RegistrationScreen(),
  '/homeScreen': (_) => const HomeScreen(),
  '/profileScreen': (_) => const ProfileScreen(),
  '/permissionScreen': (_) => const PermissionScreen(),
  '/account': (_) => const AccountScreen(),
};

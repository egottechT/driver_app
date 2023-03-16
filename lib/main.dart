import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/provider/otp_listener.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/screens/review_trip_screen.dart';
import 'package:driver_app/screens/screen_management.dart';
import 'package:driver_app/screens/setting_screens/account_screen.dart';
import 'package:driver_app/screens/setting_screens/car_details_screens/document_detail_screen.dart';
import 'package:driver_app/screens/setting_screens/car_details_screens/select_vehicle_screen.dart';
import 'package:driver_app/screens/setting_screens/payment_screen.dart';
import 'package:driver_app/screens/starting_screens/login_screen.dart';
import 'package:driver_app/screens/starting_screens/permission_screen.dart';
import 'package:driver_app/screens/top_navigation_screen/earning_screen.dart';
import 'package:driver_app/screens/top_navigation_screen/rating_screen.dart';
import 'package:driver_app/screens/unused_screen/home_screen.dart';
import 'package:driver_app/screens/phone_verification_screens/phone_number_setup.dart';
import 'package:driver_app/screens/starting_screens/registration_screen.dart';
import 'package:driver_app/screens/starting_screens/splash_screen.dart';
import 'package:driver_app/screens/unused_screen/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await LocalNoticeService().setup();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> OtpProvider()),
        ChangeNotifierProvider(create: (_) => UserModelProvider()),
      ],
      child: MaterialApp(
        title: 'Book My taxi Driver',
        routes: appPageRoutes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: primaryColor),
        ),
        initialRoute: "splash",
        // home: ReviewTripScreen(),
      ),
    ),
  );
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

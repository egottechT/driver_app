import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/otp_listener.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/screens/phone_verification_screens/otp_verify_screen.dart';
import 'package:driver_app/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> doGmailLogin() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await _auth.signInWithCredential(authCredential);
    User? user = result.user;
    return user;
  }
  return null;
}

Future<void> signOut(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Provider.of<UserModelProvider>(context,listen: false).setData(UserModel());
  try {
    if (!kIsWeb) {
      await googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    debugPrint("There is some error");
  }
}

String verificationCode = "";
String phoneNumber = "";
Future<void> signInWithPhoneNumber(String number, BuildContext context) async {
  phoneNumber = number;

  await _auth.verifyPhoneNumber(
    phoneNumber: number,
    verificationCompleted: (PhoneAuthCredential credential) async {
      Provider.of<OtpProvider>(context,listen: false).setString(credential.smsCode.toString());
    },
    verificationFailed: (FirebaseAuthException e) {
      debugPrint("verification failed ${e.code}");
    },
    codeSent: (String verificationId, int? resendToken) async {
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=> OTPVerifyScreen(phoneNumber: number)));
      verificationCode = verificationId;
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      debugPrint("Auto reterival time out");
    },
  );
}

Future<void> checkOTP(String smsCode,BuildContext context) async {
  try{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationCode, smsCode: smsCode);
    await _auth.signInWithCredential(credential).then((dynamic result) async {
      bool isExist = await checkDatabaseForUser(result.user.uid.toString());
      if (context.mounted) {
        if (isExist) {
          Navigator.of(context).pushNamed("/permissionScreen");
        }
        else {
          Navigator.of(context).pushReplacementNamed("/registrationScreen");
        }
      }
    });
  }catch(e){
    debugPrint("Error is:- $e");
    context.showErrorSnackBar(message: "Please enter correct OTP");
  }
}

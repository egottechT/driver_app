import 'dart:io';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/Utils/name_and_function.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/service/database.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late List<Pair<String, dynamic>> values;
  File? imgFile;
  String versionNumber = "";

  Future<void> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;

    print('App Version: $version');
    setState(() {
      versionNumber = version;
    });
  }

  @override
  void initState() {
    super.initState();
    values = nameAndFunctionList(context);
    getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserModelProvider>(context).data;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            firstCardView(model, "Manage profile", context),
            Divider(
              height: 0,
              thickness: 3,
              color: secondaryColor,
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              primary: false,
              itemBuilder: (context, index) {
                return cardViewWithText(
                    values[index].first, values[index].last);
              },
              itemCount: values.length,
              shrinkWrap: true,
            ),
            SizedBox(height: 25),
            Text('Version: $versionNumber')
          ],
        ),
      ),
    );
  }

  Widget firstCardView(
      UserModel userModel, String title, BuildContext context) {
    return Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Column(children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  File? img = await selectImage(context);
                  if (img != null) {
                    setState(() {
                      imgFile = img;
                    });
                    DatabaseUtils().uploadPhotoToStorage(img, "profile_pic");
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  backgroundImage: showProfileImage(userModel),
                  radius: 40.0,
                ),
              ),
            ]),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.name,
                  style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            )
          ],
        ));
  }

  Widget cardViewWithText(String title, dynamic onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Icon(Icons.play_arrow_rounded, color: secondaryColor),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: secondaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  showProfileImage(UserModel userModel) {
    if (imgFile != null) {
      return Image(image: FileImage(File(imgFile!.path))).image;
    }
    if (userModel.profilePic.isEmpty) {
      return Image.asset(
        "assets/images/profile.png",
      ).image;
    }
    return NetworkImage(userModel.profilePic);
  }
}

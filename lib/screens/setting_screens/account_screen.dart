import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/Utils/name_and_function.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/screens/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late List<Pair<String, dynamic>> values;

  @override
  void initState() {
    super.initState();
    values = nameAndFunctionList(context);
  }

  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserModelProvider>(context).data;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            firstCardView(model.name, "Manage profile"),
            Divider(
              height: 0,
              thickness: 3,
              color: secondaryColor,
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              primary: false,
              itemBuilder: (context, index) {
                return cardViewWithText(values[index].first,values[index].last);
              },
              itemCount: values.length,
              shrinkWrap: true,
            )
          ],
        ),
      ),
    );
  }

  Widget cardViewWithText(String title,dynamic onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Icon(Icons.play_arrow_rounded,color: secondaryColor),
              Text(title,style: TextStyle(fontWeight: FontWeight.bold,color: secondaryColor),)],
          ),
        ),
      ),
    );
  }
}

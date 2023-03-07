import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/Utils/name_and_function.dart';
import 'package:driver_app/screens/common_widget.dart';
import 'package:flutter/material.dart';

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
    values = nameFunctions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          firstCardView("Name", "Manage profile"),
          Divider(
            height: 0,
            thickness: 3,
            color: secondaryColor,
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return cardViewWithText(values[index].first,index);
            },
            itemCount: values.length,
            shrinkWrap: true,
          )
        ],
      ),
    );
  }

  cardViewWithText(String title,int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
      child: GestureDetector(
        onTap: values[index].last,
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
      ),
    );
  }
}

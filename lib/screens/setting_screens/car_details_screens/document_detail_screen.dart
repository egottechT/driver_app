import 'dart:io';

import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/common_widget.dart';
import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatelessWidget {
  DocumentDetailScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  TextEditingController documentNumber = TextEditingController();

  // TextEditingController vechileType = TextEditingController();
  // TextEditingController yearText = TextEditingController();
  // TextEditingController issueDate = TextEditingController();
  // TextEditingController expiryDate = TextEditingController();

  sizeBetweenField({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Document"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              color: Colors.grey[300],
              child: InkWell(
                onTap: () async {
                  //TODO Upload Photo
                  File? img = await selectImage(context);

                },
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/login_screen.png",
                      scale: 3.0,
                    ),
                    sizeBetweenField(height: 20),
                    Text(
                      "Upload a photo",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sizeBetweenField(height: 20),
                  detailTextFormField("Document Number",
                      textEditingController: documentNumber,
                      icon: Icon(
                        Icons.search,
                        color: secondaryColor,
                      )),
                  sizeBetweenField(),
                  // detailTextFormField("MODEL",
                  //     textEditingController: vechileType,
                  //     icon: Icon(
                  //       Icons.search,
                  //       color: secondaryColor,
                  //     )),
                  // sizeBetweenField(),
                  // detailTextFormField("YEAR",
                  //     textEditingController: yearText,
                  //     icon: const Icon(null),
                  //     keyboardType: TextInputType.phone),
                  // sizeBetweenField(),
                  // detailTextFormField("COLOR",
                  //     textEditingController: issueDate, icon: const Icon(null)),
                  // sizeBetweenField(),
                  // detailTextFormField("INTERIOR COLOR",
                  //     textEditingController: expiryDate,
                  //     icon: const Icon(null)),
                  sizeBetweenField(height: 50),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {}
                      },
                      child: const Text("Continue")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentDetailScreen extends StatefulWidget {
  final String documentName;

  const DocumentDetailScreen({Key? key, required this.documentName})
      : super(key: key);

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  File? file;
  bool isLoading = false;
  String imgUrl = "";

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() async {
    DatabaseUtils().databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("urls")
        .onValue
        .listen((event) {
      Map map = event.snapshot.value as Map;
      setState(() {
        imgUrl = map[widget.documentName] ?? "";
      });

    });
  }

  sizeBetweenField({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Document"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              color: Colors.grey[300],
              child: file == null
                  ? InkWell(
                      onTap: () async {
                        File? img = await selectImage(context);
                        setState(() {
                          file = img;
                        });
                      },
                      child: Column(
                        children: [
                          imgUrl.isNotEmpty
                              ? SizedBox(
                                  height: 125,
                                  child: Image.network(imgUrl),
                                )
                              : Image.asset(
                                  "assets/images/login_screen.png",
                                  scale: 3.0,
                                ),
                          sizeBetweenField(height: 20),
                          const Text(
                            "Upload a photo",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 100,
                      child: Image.file(file!),
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: secondaryColor,
                    ),
                  )
                : ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () async {
                      if (file != null) {
                        setState(() {
                          isLoading = true;
                        });
                        await DatabaseUtils().uploadDocumentPhoto(widget.documentName);
                        await DatabaseUtils().uploadPhotoToStorage(file!, widget.documentName);
                        if (context.mounted) {
                          UserModel model = Provider.of<UserModelProvider>(
                                  context,
                                  listen: false)
                              .data;
                          model.documents[widget.documentName] = true;
                          Provider.of<UserModelProvider>(context, listen: false)
                              .setData(model);
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text("Continue")),
          ],
        ),
      ),
    );
  }
}

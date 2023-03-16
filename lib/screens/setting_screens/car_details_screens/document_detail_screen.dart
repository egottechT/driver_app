import 'dart:io';

import 'package:driver_app/Utils/commonData.dart';
import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatefulWidget {
  DocumentDetailScreen({Key? key}) : super(key: key);

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  File? file;

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
              child: file == null
                  ? InkWell(
                      onTap: () async {
                        //TODO Upload Photo
                        File? img = await selectImage(context);
                        setState(() {
                          file = img;
                        });
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
                    )
                  : SizedBox(
                      height: 100,
                      child: Image.file(file!),
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Continue")),
          ],
        ),
      ),
    );
  }
}

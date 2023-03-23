import 'dart:io';

import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/service/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentDetailScreen extends StatefulWidget {
  String documentName;
  DocumentDetailScreen({Key? key,required this.documentName}) : super(key: key);

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
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () async {
                  if(file!=null) {
                    await uploadDocumentPhoto(widget.documentName);
                    UserModel model = Provider.of<UserModelProvider>(context,listen: false).data;
                    model.documents[widget.documentName] = true;
                    Provider.of<UserModelProvider>(context,listen: false).setData(model);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("Continue")),
          ],
        ),
      ),
    );
  }
}

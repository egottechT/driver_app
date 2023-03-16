import 'package:driver_app/Utils/commonData.dart';
import 'package:flutter/material.dart';

class UserModel {
  String name = "";
  String phoneNumber = "";
  String email = "";
  Map documents = documentsValue;
  UserModel();

  Map<String, dynamic> toMap(UserModel model) {
    return {
      "name": model.name,
      "phoneNumber": model.phoneNumber,
      "email": model.email,
      "documents": model.documents
    };
  }

  UserModel getDataFromMap(Map map) {
    debugPrint("Data is done");
    UserModel model = UserModel();
    model.phoneNumber = map["phoneNumber"] ?? "";
    model.email = map["email"] ?? "";
    model.name = map["name"] ?? "";
    documentsValue.forEach((key, value) {
      documents[key] = map["documents"][key];
    });
    return model;
  }
}

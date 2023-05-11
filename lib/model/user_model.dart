import 'package:driver_app/Utils/commonData.dart';

class UserModel {
  String name = "";
  String phoneNumber = "";
  String email = "";
  String profilePic = "";
  String key = "";
  String state = "";
  String franchise = "";

  bool referred = false;
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
    UserModel model = UserModel();
    model.phoneNumber = map["phoneNumber"] ?? "";
    model.email = map["email"] ?? "";
    model.name = map["name"] ?? "";
    model.state = map["state"] ?? "";
    model.franchise = map["franchise"] ?? "";
    documentsValue.forEach((key, value) {
      documents[key] = map["documents"][key] ?? false;
    });
    model.referred = map["referred"] ?? false;
    model.profilePic = map["urls"]?["profile_pic"] ?? "";
    return model;
  }
}

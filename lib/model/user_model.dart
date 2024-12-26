import 'package:driver_app/Utils/commonData.dart';

class UserModel {
  String name = "";
  String phoneNumber = "";
  String email = "";
  String profilePic = "";
  String key = "";
  String state = "";
  String franchise = "";
  String carBrand = "";
  String carModel = "";
  String carYear = "";
  String carColor = "";
  String carInteriorColor = "";
  String vehicleNumber = "";
  String carType = "";
  int amount = 0;

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
    model.carBrand = map["car_details"]?["card_brand"] ?? "";
    model.carColor = map["car_details"]?["car_color"] ?? "";
    model.carInteriorColor = map["car_details"]?["car_interior_color"] ?? "";
    model.carModel = map["car_details"]?["car_model"] ?? "";
    model.carYear = map["car_details"]?["car_year"] ?? "";
    model.vehicleNumber = map["car_details"]?["vehicle_number"] ?? "";
    model.carType = map["car_details"]?["car_type"] ?? "";
    model.carType = map["car_details"]?["car_type"] ?? "";
    model.amount = map["amount"] ?? 0;
    return model;
  }
}

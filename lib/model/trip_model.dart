class TripModel {
  String pickUpLocation = "";
  String destinationLocation = "";
  String customerName = "";
  String price = "₹0";
  double distance = 0;
  String dateTime = "";

  Map toMap(TripModel model) {
    Map map = {
      "pickUpLocation": model.pickUpLocation,
      "destinationLocation": model.destinationLocation,
      "customerName": model.customerName,
      "price": model.price,
      "distance": model.distance,
      "dateTime": model.dateTime,
    };
    return map;
  }

  TripModel fromMap(Map map) {
    TripModel model = TripModel();
    model.pickUpLocation = map["pickUpLocation"] ?? "";
    model.destinationLocation = map["destinationLocation"] ?? "";
    model.customerName = map["customerName"] ?? "";
    model.price = map["price"].toString() ?? "";
    try {
      model.distance = double.parse(map["distance"] ?? "0.0");
    } catch (e) {
      model.distance = map["distance"] ?? 0.0;
    }
    model.dateTime = map["dateTime"] ?? DateTime.now().toString();
    return model;
  }

  TripModel convertFromTrip(Map map) {
    TripModel model = TripModel();
    model.pickUpLocation = map["pick-up"]["location"];
    model.destinationLocation = map["destination"]["location"];
    model.customerName = map["title"];
    model.price = map["price"].toString();
    model.distance = double.parse(map["distance"]);
    model.dateTime = DateTime.now().toString();
    return model;
  }
}

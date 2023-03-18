class TripModel{
    String pickUpLocation = "";
    String destinationLocation = "";
    String customerName = "";
    int price = 0;
    int distance = 0;
    String dateTime = "";

    TripModel fromMap(Map map){
      TripModel model = TripModel();
      model.pickUpLocation = map["pickUpLocation"];
      model.destinationLocation = map["destinationLocation"];
      model.customerName = map["customerName"];
      model.price = map["price"];
      model.distance = map["distance"];
      model.dateTime = map["dateTime"];
      return model;
    }
}
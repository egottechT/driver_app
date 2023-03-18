class RatingModel {
  int rating = 0;
  String description = "";
  String customerName = "";

  RatingModel fromMap(Map map) {
    RatingModel model = RatingModel();
    model.rating = map["rating"];
    model.description = map["description"];
    model.customerName = map["customerName"];
    return model;
  }

  Map ratingModelToMap(RatingModel model) {
    Map map = {
      "rating": model.rating,
      "description": model.description,
      "customerName": model.customerName
    };
    return map;
  }
}

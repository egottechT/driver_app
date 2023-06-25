class RatingModel {
  int rating = 0;
  String description = "";
  String customerName = "";
  String date = "";

  RatingModel fromMap(Map map) {
    RatingModel model = RatingModel();
    model.rating = map["rating"] ?? 0;
    model.description = map["description"] ?? "";
    model.customerName = map["customerName"] ?? "";
    model.date = map["date"] ?? DateTime.now().toString();
    return model;
  }

  Map ratingModelToMap(RatingModel model) {
    Map map = {
      "rating": model.rating,
      "description": model.description,
      "customerName": model.customerName,
      "date": model.date,
    };
    return map;
  }
}

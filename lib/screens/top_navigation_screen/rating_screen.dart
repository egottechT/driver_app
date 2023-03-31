import 'package:driver_app/model/raitng_model.dart';
import 'package:driver_app/screens/common_widget.dart';
import 'package:driver_app/service/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  List<RatingModel> ratingList = [];

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() async {
    List<RatingModel> list = await fetchRatingData();
    // RatingModel model = RatingModel();
    // model.date = DateTime.now().toString();
    // model.customerName = "Aryan";
    // model.description = "sajfalsdjf lasdf";
    // model.rating = 2;
    //
    // list.add(model);
    // list.add(model);
    // list.add(model);
    setState(() {
      ratingList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ratingOverView(),
          const Divider(
            height: 5,
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(ratingList[index].customerName),
                            subtitle: Row(
                              children: List.generate(
                                5,
                                (starIndex) => Icon(
                                  starIndex < ratingList[index].rating ? Icons.star : Icons.star_border,
                                  color: Colors.orange,
                                  size: 15,
                                ),
                              ),
                            ),
                            trailing: Text(formatDate(ratingList[index].date)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                                ratingList[index].description),
                          )
                        ],
                      ),
                    );
                  },
                  shrinkWrap: true,
                  itemCount: ratingList.length))
        ],
      ),
    );
  }

  ratingOverView() {
    int averageRating = 0;
    int sumRating = 0;
    List<double> ratingValue = List.generate(6, (index) => 0.0);
    for(var values in ratingList){
        ratingValue[values.rating]++;
        sumRating+=values.rating;
    }
    for(int i=0;i<ratingValue.length&&sumRating!=0;i++){
        ratingValue[i] = ratingValue[i]/sumRating;
    }
    if(sumRating!=0) {
      averageRating = (sumRating/ratingList.length).round();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 30),
          child: Column(
            children: [
              Text(averageRating.toString()),
              showRatingBar(averageRating),
              Row(
                children: [
                  Icon(Icons.person),
                  Text(ratingList.length.toString()),
                ],
              )
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ratingProcessBar("5", ratingValue[1].toDouble()),
            ratingProcessBar("4", ratingValue[2].toDouble()),
            ratingProcessBar("3", ratingValue[3].toDouble()),
            ratingProcessBar("2", ratingValue[4].toDouble()),
            ratingProcessBar("1", ratingValue[5].toDouble()),
          ],
        )
      ],
    );
  }

  ratingProcessBar(String rating, double numbers) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star,
          size: 12,
        ),
        Text(rating),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey,
            color: Colors.orange,
            value: numbers,
          ),
        )
      ],
    );
  }

  formatDate(String date) {
    DateTime time = DateTime.parse(date);
    return DateFormat.yMMMMd().format(time);
  }
}

import 'package:driver_app/screens/common_widget.dart';
import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
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
                            title: const Text("Aryan Bisht"),
                            subtitle: Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < 3 ? Icons.star : Icons.star_border,
                                  color: Colors.orange,
                                  size: 15,
                                ),
                              ),
                            ),
                            trailing: const Text("30 Jan 2023"),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                                "Hello thjkasdfa faskdfaksf asfkas fasjkd faskjdfha skdfa sjfsdkj fhsdfh kasf"),
                          )
                        ],
                      ),
                    );
                  },
                  shrinkWrap: true,
                  itemCount: 3))
        ],
      ),
    );
  }

  ratingOverView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 30),
          child: Column(
            children: [
              const Text("4.0"),
              showRatingBar(4),
              const Row(
                children: [
                  Icon(Icons.person),
                  Text("5238 Total"),
                ],
              )
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ratingProcessBar("5", 0.5),
            ratingProcessBar("4", 0.12),
            ratingProcessBar("3", 0.75),
            ratingProcessBar("2", 0.5),
            ratingProcessBar("1", 0.25),
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
}

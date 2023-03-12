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
                    return const Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text("Aryan Bisht"),
                            subtitle: Text("Stars"),
                            trailing: Text("30 Jan 2023"),
                          ),
                          Padding(
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
      children: [
        Text("Total Rating"),
        Text("Rating OverViews"),
      ],
    );
  }
}

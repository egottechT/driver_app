import 'package:flutter/material.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({Key? key}) : super(key: key);

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            firstRowCardsView(),
            const SizedBox(height: 10),
            const Text("TODAY'S TRIP"),
            Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return const Card(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Jessica Fox"),
                        subtitle: Text("05:35 PM"),
                        trailing: Column(
                          children: [
                            Text("Rs. 85"),
                            Text("Cash"),
                          ],
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  itemCount: 3,
            )),
          ],
        ),
      ),
    );
  }

  firstRowCardsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cardItemView("Rs. 240", "My earning", Colors.green),
        cardItemView("4Hr 32m", "Spend Time", Colors.blueAccent),
        cardItemView("06", "Completed Trip", Colors.orange),
      ],
    );
  }

  cardItemView(String value, String title, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }
}

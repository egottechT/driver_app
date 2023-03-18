import 'package:driver_app/model/trip_model.dart';
import 'package:driver_app/service/database.dart';
import 'package:flutter/material.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({Key? key}) : super(key: key);

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  List<TripModel> tripValue = [];

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() async {
    List<TripModel> list = await fetchHistoryTrip();
    setState(() {
      tripValue = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            firstRowCardsView(),
            const SizedBox(height: 10),
            const Text("TODAY'S TRIP"),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                DateTime dateTime = DateTime.parse(tripValue[index].dateTime);
                String time =
                    "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(tripValue[index].customerName),
                    subtitle: Text(time),
                    trailing: Column(
                      children: [
                        Text(tripValue[index].price.toString()),
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
    int money = 0;
    for (var data in tripValue) {
      money = money + data.price;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cardItemView("Rs. $money", "My earning", Colors.green),
        // cardItemView("4Hr 32m", "Spend Time", Colors.blueAccent),
        cardItemView(tripValue.length.toString(), "Completed Trip", Colors.orange),
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
                  color: color, fontWeight: FontWeight.bold, fontSize: 16),
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

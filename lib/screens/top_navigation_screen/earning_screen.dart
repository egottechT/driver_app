import 'package:driver_app/model/trip_model.dart';
import 'package:driver_app/repository/history_repo.dart';
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
    List<TripModel> list = await HistoryRepo().fetchHistoryTrip();
    // TripModel model = TripModel();
    // model.dateTime = DateTime.now().toString();
    // model.price = "200";
    // model.customerName = "Aryan";
    // list.add(model);
    // list.add(model);
    // list.add(model);
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
                String time = "";
                if (tripValue[index].dateTime.isNotEmpty) {
                  DateTime dateTime = DateTime.parse(tripValue[index].dateTime);
                  "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
                }
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(tripValue[index].customerName),
                    subtitle: Text(time),
                    trailing: Column(
                      children: [
                        Text(tripValue[index].price.toString()),
                        const Text("Cash"),
                      ],
                    ),
                  ),
                );
              },
              shrinkWrap: true,
              itemCount: tripValue.length,
            )),
          ],
        ),
      ),
    );
  }

  firstRowCardsView() {
    int money = 0;
    for (var data in tripValue) {
      money = money + int.parse(data.price.substring(1));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cardItemView("Rs. $money", "My earning", Colors.green),
        // cardItemView("4Hr 32m", "Spend Time", Colors.blueAccent),
        cardItemView(
            tripValue.length.toString(), "Completed Trip", Colors.orange),
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

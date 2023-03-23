import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class DriveHistoryScreen extends StatefulWidget {
  const DriveHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DriveHistoryScreen> createState() => _DriveHistoryScreenState();
}

class _DriveHistoryScreenState extends State<DriveHistoryScreen> {
  int dateIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 75,
            child: dateSelectionBar(),
          ),
          tripAndMoneyRow(),
          const SizedBox(
            height: 10,
          ),
          Expanded(child: tripDetailCard()),
        ],
      ),
    );
  }

  dateSelectionBar() {
    DateTime now = DateTime.now();
    String dateOnly = now.getDateOnly();
    debugPrint(dateOnly.substring(8));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      itemBuilder: (context, index) {
        int value = int.parse(dateOnly.substring(8)) - index;
        String newDate =
            "${dateOnly.substring(0, 8)}${value.toString().padLeft(2, '0')}";
        return DecoratedBox(
          decoration: BoxDecoration(
              color: dateIndex == index ? secondaryColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(5)),
          child: InkWell(
            onTap: () {
              setState(() {
                dateIndex = index;
              });
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      changeToDate(newDate),
                      style: TextStyle(
                        color:
                            dateIndex == index ? secondaryColor : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      shrinkWrap: true,
      itemCount: 20,
      scrollDirection: Axis.horizontal,
    );
  }

  tripAndMoneyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cardView(
            const Icon(
              Icons.local_taxi,
              size: 30,
            ),
            "Total Jobs",
            "10"),
        cardView(
            const Icon(
              Icons.currency_rupee,
              size: 30,
            ),
            "Earned",
            "₹325")
      ],
    );
  }

  cardView(Icon icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              icon,
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  tripDetailCard() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 5),
      itemBuilder: (context, index) {
        return Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileSection(),
                showDivider(),
                const SizedBox(height: 10,),
                locationDetail("PICK UP","pick up location is"),
                showDivider(),
                const SizedBox(height: 10,),
                locationDetail("DROP OFF","Destination location is"),
              ],
            ),
          ),
        );
      },
    );
  }

  profileSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.person,size: 40,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Card(
                  color: primaryColor,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text("UPI",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                  ),
                )
              ],
            ),
          ],
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("₹22",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            Text("7.2 KM",style: TextStyle(color: Colors.grey,fontSize: 12)),
          ],
        )
      ],
    );
  }

  showDivider(){
    return Divider(
      color: Colors.grey[300],
      thickness: 2,
      height: 5,
    );
  }

  locationDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: const TextStyle(color: Colors.grey),),
        Text(value,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
      ],
    );
  }
}

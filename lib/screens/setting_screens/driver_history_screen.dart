import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/trip_model.dart';
import 'package:driver_app/repository/history_repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriveHistoryScreen extends StatefulWidget {
  const DriveHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DriveHistoryScreen> createState() => _DriveHistoryScreenState();
}

class _DriveHistoryScreenState extends State<DriveHistoryScreen> {
  int dateIndex = 0;
  List<TripModel> tripList = [];
  List<TripModel> filterList = [];
  List<String> dateList = [];

  @override
  void initState() {
    super.initState();
    generateDates();
    readData();
  }

  void readData() async {
    tripList = await HistoryRepo().fetchHistoryTrip();
    // tripList = addDummyDate();
    changeInDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "History",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 90,
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
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      itemBuilder: (context, index) {
        return DecoratedBox(
          decoration: BoxDecoration(
              color: dateIndex == index ? secondaryColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(5)),
          child: InkWell(
            onTap: () {
              setState(() {
                dateIndex = index;
                changeInDate();
              });
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      changeToDate(dateList[index]),
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
      itemCount: dateList.length,
      scrollDirection: Axis.horizontal,
    );
  }

  tripAndMoneyRow() {
    int moneyEarned = 0;
    for (var values in filterList) {
      moneyEarned += int.parse(values.price.substring(1));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cardView(
            const Icon(
              Icons.local_taxi,
              size: 30,
            ),
            "Total Jobs",
            filterList.length.toString()),
        cardView(
            const Icon(
              Icons.currency_rupee,
              size: 30,
            ),
            "Earned",
            "₹$moneyEarned")
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
      itemCount: filterList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileSection(index),
                showDivider(),
                const SizedBox(
                  height: 10,
                ),
                locationDetail("PICK UP", filterList[index].pickUpLocation),
                showDivider(),
                const SizedBox(
                  height: 10,
                ),
                locationDetail(
                    "DROP OFF", filterList[index].destinationLocation),
              ],
            ),
          ),
        );
      },
    );
  }

  profileSection(int index) {
    String time =
        DateFormat.jm().format(DateTime.parse(filterList[index].dateTime));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.person,
              size: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filterList[index].customerName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Card(
                  color: primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(time,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                )
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(filterList[index].price,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("${filterList[index].distance} KM",
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        )
      ],
    );
  }

  showDivider() {
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
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  void changeInDate() async {
    filterList.clear();
    List<TripModel> list = [];
    for (var values in tripList) {
      DateTime dateTime = DateTime.parse(values.dateTime);
      String formattedDate = changeToDate(dateTime.getDateOnly());
      String checkDate = changeToDate(dateList[dateIndex]);
      if (formattedDate.contains(checkDate)) {
        list.add(values);
      }
    }
    setState(() {
      filterList = list;
    });
  }

  List<TripModel> addDummyDate() {
    List<TripModel> list = [];
    TripModel model1 = TripModel();
    model1.dateTime = DateTime.now().toString();
    model1.price = "₹200";
    model1.destinationLocation = "Lower Nehrugram";
    model1.pickUpLocation = "Clock tower";
    model1.customerName = "Aryan";
    model1.distance = 2.2;
    DateTime currentDate = DateTime.now();
    model1.dateTime = currentDate.toString();
    list.add(model1);

    TripModel model2 = TripModel();
    model2.dateTime = DateTime.now().toString();
    model2.price = "₹400";
    model2.destinationLocation = "Lower Nehrugram";
    model2.pickUpLocation = "Clock tower";
    model2.customerName = "Shivansh";
    model2.distance = 2.5;
    currentDate = currentDate.subtract(const Duration(days: 1));
    model2.dateTime = currentDate.toString();
    list.add(model2);

    TripModel model3 = TripModel();
    model3.dateTime = DateTime.now().toString();
    model3.price = "₹1500";
    model3.destinationLocation = "Lower Nehrugram";
    model3.pickUpLocation = "Clock tower";
    model3.customerName = "Abhay";
    model3.distance = 5.2;
    currentDate = currentDate.subtract(const Duration(days: 1));
    model3.dateTime = currentDate.toString();
    list.add(model3);

    return list;
  }

  void generateDates() {
    DateTime currentDate = DateTime.now();
    for (int i = 0; i < 30; i++) {
      dateList.add(currentDate.getDateOnly());
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
  }
}

import 'package:driver_app/screens/common_widget.dart';
import 'package:driver_app/screens/setting_screens/car_details_screens/upload_document_screen.dart';
import 'package:flutter/material.dart';

class CarDetailScreen extends StatefulWidget {
  final bool isFromStart;

  const CarDetailScreen({Key? key, required this.isFromStart})
      : super(key: key);

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController brandText = TextEditingController();
  TextEditingController modelText = TextEditingController();
  TextEditingController yearText = TextEditingController();
  TextEditingController colorText = TextEditingController();
  TextEditingController interiorColorText = TextEditingController();
  TextEditingController vehicleNumber = TextEditingController();

  sizeBetweenField({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add your Vehicle Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20,),
                Image.asset("assets/images/login_screen.png"),
                sizeBetweenField(height: 20),
                detailTextFormField("BRAND",
                    textEditingController: brandText, icon: const Icon(null)),
                sizeBetweenField(),
                detailTextFormField("MODEL",
                    textEditingController: modelText, icon: const Icon(null)),
                sizeBetweenField(),
                detailTextFormField("YEAR",
                    textEditingController: yearText,
                    icon: const Icon(null),
                    keyboardType: TextInputType.phone),
                sizeBetweenField(),
                detailTextFormField("COLOR",
                    textEditingController: colorText, icon: const Icon(null)),
                sizeBetweenField(),
                detailTextFormField("INTERIOR COLOR",
                    textEditingController: interiorColorText,
                    icon: const Icon(null)),
                sizeBetweenField(),
                detailTextFormField("Vehicle Number",
                    textEditingController: vehicleNumber,
                    icon: const Icon(null)),
                sizeBetweenField(height: 20),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UploadDocumentScreen(
                                  isFromStart: widget.isFromStart,
                                )));
                      }
                    },
                    child: const Text("Continue")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

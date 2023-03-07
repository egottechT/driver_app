import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/Utils/name_and_function.dart';
import 'package:driver_app/screens/upload_document_screen.dart';
import 'package:flutter/material.dart';

class CarDetailScreen extends StatefulWidget {
  const CarDetailScreen({Key? key}) : super(key: key);

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

  sizeBetweenField({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your Vehicle Details",style: TextStyle(color: Colors.black),),
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
                Image.asset("assets/images/login_screen.png"),
                sizeBetweenField(height: 20),
                detailTextFormField("BRAND",
                    textEditingController: brandText,
                    icon: Icon(
                      Icons.search,
                      color: secondaryColor,
                    )),
                sizeBetweenField(),
                detailTextFormField("MODEL",
                    textEditingController: modelText,
                    icon: Icon(
                      Icons.search,
                      color: secondaryColor,
                    )),
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
                sizeBetweenField(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black),
                    onPressed: () {
                      // if (formKey.currentState!.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UploadDocumentScreen()));
                      // }
                    },
                    child: const Text("Continue")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailTextFormField(String labelText,
      {Icon? icon,
      TextInputType keyboardType = TextInputType.text,
      required TextEditingController textEditingController}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
          filled: true,
          focusColor: secondaryColor,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: secondaryColor),
          ),
          fillColor: Colors.white,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          isDense: true,
          suffixIcon: icon,
        ),
        keyboardType: keyboardType,
        controller: textEditingController,
        validator: nullValidator,
        textInputAction: TextInputAction.next,
        // onTap: onTap,
        // onFieldSubmitted: onSumbit,
      ),
    );
  }
}

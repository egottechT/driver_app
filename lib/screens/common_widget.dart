import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/Utils/name_and_function.dart';
import 'package:driver_app/service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

Widget editableRatingBar(onStarChange) {
  return RatingBar(
      initialRating: 4,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.orange),
          half: const Icon(
            Icons.star_half,
            color: Colors.orange,
          ),
          empty: const Icon(
            Icons.star_outline,
            color: Colors.orange,
          )),
      onRatingUpdate: onStarChange);
}

Widget showRatingBar(int rating) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(
      5,
      (index) => Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: Colors.orange,
        size: 25,
      ),
    ),
  );
}

void showReferAndBox(context, bool isReferAlready) async {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter changeState) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          } else {
            return AlertDialog(
              title: const Text('Refer and Earn'),
              content: isReferAlready
                  ? const Text("You are already referred by some-one else")
                  : TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: "Enter the referral code"),
                    ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    changeState(() {
                      isLoading = true;
                    });
                    await addReferAndEarn(controller.text);
                    changeState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Next'),
                ),
              ],
            );
          }
        });
      });
}

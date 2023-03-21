import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/Utils/name_and_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget firstCardView(String name, String title) {
  return Card(
      elevation: 0,
      color: Colors.grey[300],
      child: Row(
        children: [
          Column(children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset("assets/images/profile.png")
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                title,
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          )
        ],
      ));
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

Widget editableRatingBar(onStarChange){
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

Widget showRatingBar(int rating){
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

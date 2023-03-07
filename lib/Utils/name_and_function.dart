import 'package:analyzer_plugin/utilities/pair.dart';

List<Pair<String,dynamic>> nameFunctions = [
  Pair("Performance",(){

  }),
  Pair("Vehicle Information",(){}),
  Pair("Digital KYC Customer Verification",(){}),
  Pair("Deposit Cash",(){}),
  Pair("Book My Etaxi Money",(){

  }),
  Pair("Refer and Earn",(){}),
  Pair("Setting",(){}),
  Pair("Help and Support",(){}),
  Pair("EXIT Book My Etaxi Cab",(){}),
  Pair("Call for Emergency",(){}),
];

String? nullValidator(dynamic value) {
  if(value==null || value!.isEmpty){
    return "Some value is required";
  }
  return null;
}
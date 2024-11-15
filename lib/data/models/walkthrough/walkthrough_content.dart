
import 'package:flutter/material.dart';
import 'package:naijamart/data/models/walkthrough/custom_story_view.dart';

import '../../../util/constants/images_uri.dart';


List<CustomStoryItem> getWalkThroughItems(BuildContext context){
  return [
    CustomStoryItem(
      context: context,
      subCaption: "A seamless method of transferring funds within local, continental or global context",
      imageUrl: NaijaMartImageUris.walkThroughFirstImage,
      caption: "Unlock a world of virtual banking",
      onButton1Pressed: (){
        // Navigator.of(context).pushReplacementNamed(GetStarted.routeName);
      },
      onButton2Pressed: (){},
      button1Text: "forward",
    ),

    CustomStoryItem(
      context: context,
      subCaption: "Get medical help right from your home with our easy-to-use telemedicine service! No more wait in rooms, long lines, or taking time off work to visit the doctor.",
      imageUrl: NaijaMartImageUris.walkThroughSecondImage,
      caption: "Telemedicine",
      onButton1Pressed: (){},
      onButton2Pressed: (){},
      button1Text: "forward",
    ),

    CustomStoryItem(
      context: context,
      subCaption: "Take care of your health and your finances with our convenient insurance plans! Get coverage for your medical needs and feel secure knowing you're protected.",
      imageUrl: NaijaMartImageUris.walkThroughThirdImage,
      caption: "Insurance",
      onButton1Pressed: (){},
      onButton2Pressed: (){},
      button1Text: "forward",
    ),

    CustomStoryItem(
      context: context,
      subCaption: "With our e-pharmacy service, you can order your medications online and have them delivered right to your door. No more waiting in line at the pharmacy or worrying about running out of your medication.",
      imageUrl: NaijaMartImageUris.pharmacyImage,
      caption: "E-Pharmacy",
      onButton1Pressed: (){},
      onButton2Pressed: (){},
      button1Text: "forward",
    ),

    CustomStoryItem(
      context: context,
      subCaption: "Effortlessly manage your educational expenses with our convenient 'Pay School Fees' service. Streamline the payment process, ensuring a smooth and secure transaction experience for both students and parents.",
      imageUrl: NaijaMartImageUris.billSchoolFeesImage,
      caption: "Pay School Fees",
      onButton1Pressed: (){},
      onButton2Pressed: (){},
      button1Text: "forward",
    ),

    CustomStoryItem(
      context: context,
      subCaption: "Explore boundless opportunities in the dynamic world of finance with our Investment Market platform. Whether you're a seasoned investor or just starting your financial journey, our comprehensive marketplace provides a gateway to a diverse range of investment options.",
      imageUrl: NaijaMartImageUris.walkThroughFifthImage,
      caption: "Investment Market",
      onButton1Pressed: (){},
      onButton2Pressed: (){},
      button1Text: "forward",
    ),

    CustomStoryItem(
      context: context,
      subCaption: "Suitable for everyday payments like bill payments, salary deposits, or sending money to friends and family within the country.",
      imageUrl: NaijaMartImageUris.paymentImage,
      caption: "Intl. and Local Transactions",
      onButton1Pressed: (){},
      onButton2Pressed: (){},
      button1Text: "forward",
    ),
  ];
}

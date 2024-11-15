import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../util/constants/naijamart_app_colors.dart';

void showToastMessage({required String message }) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.SNACKBAR,
    backgroundColor: NaijaMartAppColors.greyText,
    textColor: Colors.white,
    fontSize: 14.0
);

class VerificationBottomSheet extends StatelessWidget {

  final bool isVerified;

  const VerificationBottomSheet({super.key, required this.isVerified});
  @override
  Widget build(BuildContext context) {
    // Assume isVerified is a boolean variable indicating user verification status
    // Change this according to your logic

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            isVerified ? Icons.verified : Icons.warning,
            size: 30.0,
            color: isVerified ? Color(0xFF1CC00A) : Color(0xFFF60000),
          ),
          SizedBox(height: 10.0),
          Text(
            isVerified ? 'You are verified' : 'You are not verified',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: isVerified ? Color(0xFF1CC00A) : Color(0xFFF60000),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            isVerified
                ? 'Congratulations! You have been verified'
                : 'Please complete the KYC verification process on Moola App',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),

            child: Text('Close', style: TextStyle(color: Colors.white, fontSize: 18),),
          ),
        ],
      ),
    );
  }
}
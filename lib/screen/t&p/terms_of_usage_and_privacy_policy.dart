import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/widgets/button_gradient.dart';

class TermsOfUsageAndPrivacyPolicyScreen extends StatefulWidget {
  static const routeName = '/terms-of-usage-privacy-policy';

  const TermsOfUsageAndPrivacyPolicyScreen({super.key});

  @override
  State<TermsOfUsageAndPrivacyPolicyScreen> createState() =>
      _TermsOfUsageAndPrivacyPolicyScreenState();
}

class _TermsOfUsageAndPrivacyPolicyScreenState
    extends State<TermsOfUsageAndPrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final w = MediaQuery.of(context).size.width, h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(
                    height: 50,
                    width: w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                            left: 0,
                            top: 10,
                            child: BlackSquareButton(
                              icon: Icons.chevron_left,
                              borderColor: Colors.black,
                              onPressed: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.pop(context);
                                }
                              },
                            )
                        ),
                        Positioned(
                            top: 20,
                            child: Text(
                              "Terms & Privacy Policy",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text(
                        'WOW Terms and Conditions',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      const Text(
                        'Last Updated: January 1, 2024',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      const Text(
                        'Welcome to WOW Payment App',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  Text(
                    'These Terms and Conditions ("Terms") govern your use of the Wow mobile application ("App"). By downloading, installing, or using the App, you agree to be bound by these Terms. If you do not agree to all the terms and conditions of this agreement, you may not use the App.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    '1. Introduction',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "Wow is a mobile application designed to simplify and streamline your global financial transactions. Unlike Moola, which focused primarily on Nigerian domestic banking, Wow empowers you to manage your finances internationally. Whether you're sending money internationally, paying for education abroad, or accessing essential services, Wow provides a convenient and secure platform for all your global financial needs.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    '2. Eligibility',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "To use the App, you must be over the age of 18 and have the capacity to enter into this agreement.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    '3. Accessing the App',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "The App is available for download on Google Play Store and Apple App Store. Not all mobile devices can access or support the App. It is your responsibility to ensure your device is compatible with the App's operating system requirements. Wow is not responsible for any damage or loss to your device resulting from your access or attempted access to the App.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '4. Security',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "You are responsible for maintaining the confidentiality of your login credentials (username and password) and for restricting access to your device. You agree not to disclose your login credentials to any third party. You are solely responsible for all activity that occurs under your account. If you suspect that your login credentials have been compromised, you must notify Wow immediately.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),

                ],
              ),
          ),
        ),
      ),
    );
  }
}




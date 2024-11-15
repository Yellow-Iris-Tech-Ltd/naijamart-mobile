import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:naijamart/common/widgets/alert_utility.dart';

import '../../../common/mixins/automatic_logout_mixin.dart';
import '../../../common/widgets/button_gradient.dart';
import '../../../util/constants/naijamart_app_colors.dart';
import '../bottom_navigation.dart';


class ContactUsScreen extends StatefulWidget {
  static const routeName = '/contact-us-screen';
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> with AutomaticLogoutMixin {


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
          backgroundColor: const Color(0xFFF1F1F1),
          body: SingleChildScrollView(
            child: SizedBox(
              width: w,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: w,
                      height: h * .1,
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
                                  onUserInteraction();

                                    // Navigator.pop(context);
                                    Navigator.of(context).pushNamed(
                                        DashboardNavigationScreen.routeName,
                                        arguments: {'initialSelectedIndex': 4},
                                    );

                                },
                              )
                          ),
                          const Positioned(
                            top: 15,
                            child: Text("Connect with Us", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                          ),

                        ],
                      ),
                    ),
                    Text("For any inquiries or assistance, please feel free to contact us", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                    SizedBox(height: 30,),
                    Container(
                      height: 170,
                      width: w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email:',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () => launchUrl('mailto:wow@davenportmfb.com'),
                              child: Text(
                                'wow@davenportmfb.com',
                                style: TextStyle(fontSize: 16.0, color: NaijaMartAppColors.BlueSwitchColor),
                              ),
                            ),
                            SizedBox(height: 12.0),

                            Text(
                              'Phone:',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),

                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                   Text(
                                    '+234(0)7000811478',
                                    style: TextStyle(fontSize: 16.0, color: NaijaMartAppColors.BlueSwitchColor),),
                                   // SizedBox(
                                   //   width: 80,
                                   //   height: 30,
                                   //   child: ElevatedButton(
                                   //     onPressed: () async {
                                   //       onUserInteraction();
                                   //       final Uri url = Uri(
                                   //         scheme: 'tel',
                                   //         path: "+2347000811478"
                                   //       );
                                   //       if(await canLaunchUrl(url)){
                                   //         await launchUrl(url.toString());
                                   //       } else {
                                   //         showToastMessage(message: "Failed to call number");
                                   //       }
                                   //       // EmailScreenSignUp
                                   //     },
                                   //     style: ButtonStyle(
                                   //       backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                   //       shape: MaterialStateProperty.all<OutlinedBorder>(
                                   //           RoundedRectangleBorder(
                                   //             borderRadius: BorderRadius.circular(10.0),
                                   //             // side: BorderSide(color: Colors.white, width: 1.0),
                                   //           )
                                   //       ),
                                   //     ),
                                   //     child: Row(
                                   //       mainAxisAlignment: MainAxisAlignment.center,
                                   //       children: <Widget>[
                                   //         Text("Call", style: TextStyle(color: Colors.white, fontSize: 14),)
                                   //       ],
                                   //     ),
                                   //   ),
                                   // ),
                                 ],
                               ),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Future<void> launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}



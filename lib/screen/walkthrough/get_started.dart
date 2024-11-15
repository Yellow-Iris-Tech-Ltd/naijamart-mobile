import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/widgets/button_gradient.dart';
import '../../util/constants/images_uri.dart';
import '../../util/constants/naijamart_app_colors.dart';
import '../dashboard/me_screen.dart';
import '../t&p/terms_of_usage_and_privacy_policy.dart';


class GetStarted extends StatefulWidget {
  static const routeName = '/get-started';
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {


  @override
  Widget build(BuildContext context) {

    final message = ModalRoute.of(context)!.settings.arguments;

    // debugPrint('${message.notification?.title}');
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop)  {
          if(didPop){
            // showToastMessage(message: "Back key pressed");
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
              child: Column(
                children: <Widget>[
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlackSquareButton(
                        icon: Icons.chevron_left,
                        onPressed: () {
                          if(Navigator.of(context).canPop()){
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                   const SizedBox(height: 50,),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(NaijaMartImageUris.getStartedImage, height: 200,)
                  ),
                  const SizedBox(height: 50,),

                  const Text("SEND & RECEIVE MONEY", textAlign: TextAlign.center, style: TextStyle(height:1.2, fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600),),
                  const SizedBox(height: 10,),
                  const Text("Local & International Transaction", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),),
                  const SizedBox(height: 50,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pushNamed(MeDashboardScreen.routeName);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(NaijaMartAppColors.YelloGrad1),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // side: BorderSide(color: Colors.white, width: 1.0),
                                )
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 18),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,  // Set the border color
                        width: 2.0,           // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed(MeDashboardScreen.routeName);
                        // WowLoginScreen
                      },
                      child: const Text("Log In", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 110,),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(TermsOfUsageAndPrivacyPolicyScreen.routeName);
                    },
                    child: const Text("Terms of Use & Privacy Policy", style: TextStyle(color: Colors.white),),
                  )
                ],

              ),
            ),

          )
        ),
      ),
    );
  }
}




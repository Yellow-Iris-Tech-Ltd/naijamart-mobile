import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/mixins/automatic_logout_mixin.dart';
import '../../../common/widgets/button_gradient.dart';
import '../../../util/constants/naijamart_app_colors.dart';
import '../bottom_navigation.dart';


class AllNotificationsScreen extends StatefulWidget {
  static const routeName = '/all-notifications';

  const AllNotificationsScreen({super.key});

  @override
  State<AllNotificationsScreen> createState() => _AllNotificationsScreenState();
}

class _AllNotificationsScreenState extends State<AllNotificationsScreen> with AutomaticLogoutMixin{
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
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              width: w,

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // const SizedBox(height: 20),
                    SizedBox(
                      width: w,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                              left: 15,
                              top:5,
                              child: BlackSquareButton(
                                icon: Icons.chevron_left,
                                borderColor: Colors.black,
                                onPressed: () {
                                  onUserInteraction();
                                  // Navigator.pop(context);
                                  // Navigator.popUntil(context, (route) => route.isFirst);
                                  Navigator.of(context).pushNamed(DashboardNavigationScreen.routeName);

                                },
                              )
                          ),
                          const Positioned(
                            top: 5,
                            child: Text("Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),

                    ),
                    const SizedBox(height: 30,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        "All Notifications",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: Ink(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: NaijaMartAppColors.DarkGrey,
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                      onUserInteraction();
                                      HapticFeedback.lightImpact();
                                    },
                                    child: IconButton(
                                      highlightColor: Colors.white,
                                      color: Colors.white,
                                      icon: const Icon(FontAwesomeIcons.clock, color: Colors.black54, size: 25,),
                                      onPressed: () {  },),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            const Text("You don't have any notifications yet", style: TextStyle(fontSize: 16, color: Colors.black54),)
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

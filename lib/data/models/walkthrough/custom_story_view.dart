

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/button_gradient.dart';
import '../../../screen/walkthrough/get_started.dart';
import '../../../util/constants/naijamart_app_colors.dart';


class CustomStoryItem extends StoryItem {
  final BuildContext context;
  final String imageUrl;
  final String caption;
  final String subCaption;
  final VoidCallback onButton1Pressed;
  final VoidCallback onButton2Pressed;
  final String button1Text;
  // final String button2Text;

  CustomStoryItem({
    required this.context,
    required this.subCaption,
    required this.imageUrl,
    required this.caption,
    required this.onButton1Pressed,
    required this.onButton2Pressed,
    required this.button1Text,
    // required this.button2Text,
    Duration? duration, // Optional duration parameter
  }
      ) :
        super(
          SizedBox(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  caption.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 10,),
                Text(subCaption, style: const TextStyle(fontSize: 16.0),),
                SizedBox(
                  height: 30,
                ),

                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          imageUrl,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                       GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushReplacementNamed(GetStarted.routeName);
                                },
                              child: Container(
                                width: 100,
                                  height: 50,
                                  // color: Colors.blue,
                                  child: const Center(child: Text("Swipe up to skip", style: TextStyle(fontSize: 14, color: Colors.black),))),
                            ),
                        Container(
                          width: 100,
                          height: 47,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                NaijaMartAppColors.YelloGrad1,
                                NaijaMartAppColors.YellowGrad2,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          ),
                          child: Center(
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                                IconButton(
                                  icon: Icon(Icons.chevron_right, color: Colors.white, size: 30),
                                  onPressed: (){

                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // GradientCircularButton(
                        //   icon: Icons.chevron_right,
                        //   onPressed: () {  },
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
          duration: duration ?? const Duration(seconds: 3),

      );

}


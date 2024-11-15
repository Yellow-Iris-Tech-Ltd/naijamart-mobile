import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/cache/local.dart';
import '../../util/constants/images_uri.dart';
import '../../util/constants/naijamart_app_colors.dart';
import '../walkthrough/get_started.dart';
import '../walkthrough/naijamart_walkthrough.dart';


class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double imageHeight = 80.0;
  double imageWidth = 80.0;
  double textOpacity = 0.0;
  double textFontSize = 0.0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
          imageHeight = 100.0;
          imageWidth = 100.0;
          textOpacity = 1.0;
          textFontSize = 28.0;
        });

    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushReplacementNamed(GetStarted.routeName);

   
  }

  @override
  void setState(fn){
    if(mounted) super.setState(fn);
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  NaijaMartAppColors.YelloGrad1,
                  NaijaMartAppColors.YellowGrad2,
                ]
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [

                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: imageHeight,
                  width: imageWidth,
                  child: Image.asset(
                    NaijaMartImageUris.logoPath,
                    width: 380,
                    height: 380,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

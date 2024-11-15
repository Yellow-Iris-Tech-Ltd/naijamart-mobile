import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

import '../../data/cubit/onboarding/walkthrough_cubit.dart';
import '../../data/models/walkthrough/custom_story_view.dart';
import '../../util/cache/encrypted_storage.dart';
import '../../util/constants/naijamart_app_colors.dart';
import 'get_started.dart';


class WalkthroughScreen extends StatefulWidget {
  static const routeName = '/walkthrough';

  final StoryController controller;
  final List<CustomStoryItem> storyItems;
  final WalkThroughCubit walkThroughCubit;

  const WalkthroughScreen({
    super.key,
    required this.controller,
    required this.storyItems,
    required this.walkThroughCubit
  });

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  late final EncryptedStorage storage;

  bool isDeviceTrusted = false;


  @override
  void initState(){
    super.initState();
    storage = EncryptedStorage();
    _checkIfDeviceIsTrusted();
  }

  Future<void> _checkIfDeviceIsTrusted() async {
    bool? iT = await storage.readBool("trust_device_biometric");

    if(iT != null && iT){
      setState(() {
        isDeviceTrusted = iT;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: StoryView(
        controller: widget.controller,
        storyItems: widget.storyItems,
        indicatorForegroundColor: NaijaMartAppColors.YelloGrad1,

        onStoryShow: (s, i){
          debugPrint("Show is done");
        },

        onComplete: () async {
          debugPrint("Completed");

          widget.walkThroughCubit.onBoardingDone();
          await Future.delayed(const Duration(seconds: 1));
           Navigator.of(context).pushReplacementNamed(GetStarted.routeName);
        },

        onVerticalSwipeComplete: (direction) async {
          Navigator.of(context).pushReplacementNamed(GetStarted.routeName);
        },
      ),
    );
  }
}

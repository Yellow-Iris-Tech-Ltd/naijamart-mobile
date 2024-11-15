
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:naijamart/screen/walkthrough/naijamart_walkthrough.dart';

import '../../data/cubit/onboarding/walkthrough_cubit.dart';
import '../../data/models/walkthrough/custom_story_view.dart';
import '../../data/models/walkthrough/walkthrough_content.dart';

import '../../util/cache/local.dart';
import '../../util/constants/naijamart_app_colors.dart';
import '../splash/naijamart_splash.dart';

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({super.key});

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  LocalCache localCache = LocalCache();
  final controller = StoryController();
  List<CustomStoryItem> _walkThroughItems = [];
  late WalkThroughCubit _walkThroughCubit;

  @override
  void initState(){
    super.initState();
    _walkThroughItems = getWalkThroughItems(context);
    _walkThroughCubit = BlocProvider.of<WalkThroughCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkWalkThroughStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: NaijaMartAppColors.YelloGrad1,),);
          }else{
            return const SplashScreen();
          }
        }
    );
  }

  Future<bool> _checkWalkThroughStatus() async {
    return localCache.getValue<bool>('isWalkthroughDone')  ?? false;
  }
}

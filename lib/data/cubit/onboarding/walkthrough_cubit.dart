


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naijamart/data/cubit/onboarding/walkthrough_state.dart';

import '../../../util/cache/local.dart';

class WalkThroughCubit extends Cubit<WalkthroughState>{
  WalkThroughCubit(): super(WalkThroughInitialState());
  LocalCache localCache = LocalCache();

  void onPageChanged(int index) {
    switch (index) {
      case 0:
        emit(WalkThroughPageChanged(0));
        break;
      case 1:
        emit(WalkThroughPageChanged(1));
        break;
      case 2:
        emit(WalkThroughPageChanged(2));
        break;
    }
  }

  void onBoardingDone() async {
    //  Store a flag indicating that walkthrough is finished

    localCache.saveValue<bool>("isWalkthroughDone", false);
    emit(WalkThroughFinished());
    // await Future.delayed(const Duration(seconds: 2));
    // Navigator.of(context).pushReplacementNamed(GetStarted.routeName);
  }
}
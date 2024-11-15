

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/cache/local.dart';
import 'app_mode_state.dart';

class AppModeCubit extends Cubit<AppModeState> {
  LocalCache localCache = LocalCache();
  AppModeCubit() : super(AppModeInitialState());

  void toggleToDarkMode() async {
    //  Store a flag indicating that dark mode is activated
    localCache.saveValue<bool>("isDarkMode", true);
    emit(AppDarkMode());
  }

}
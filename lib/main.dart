import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naijamart/api/firebase_api.dart';

import 'package:naijamart/screen/dashboard/bottom_navigation.dart';
import 'package:naijamart/screen/dashboard/home/all_notifications_screen.dart';
import 'package:naijamart/screen/dashboard/me_screen.dart';

import 'package:naijamart/screen/walkthrough/story_view_screen.dart';

import 'package:naijamart/screen/notification/firebase_notification_ui.dart';
import 'package:naijamart/screen/splash/naijamart_splash.dart';
import 'package:naijamart/screen/t&p/terms_of_usage_and_privacy_policy.dart';
import 'package:naijamart/screen/walkthrough/get_started.dart';

import 'package:naijamart/util/cache/local.dart';
import 'package:naijamart/util/constants/naijamart_app_colors.dart';



import 'data/cubit/lightdark/app_mode_cubit.dart';
import 'data/cubit/notification/notification_cubit.dart';
import 'data/cubit/onboarding/walkthrough_cubit.dart';
import 'data/repository/notification_repository.dart';
import 'data/repository/utilities_repository.dart';

import 'dart:io' show Platform;





void main() async {
  WidgetsFlutterBinding.ensureInitialized();


    if (Platform.isAndroid) {
      await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAEHJ2kIeSdLoXWd3aNDUJFmju8uEvEDho",
        appId: "1:538896768620:android:b3d9f4a8a0e2f67e0f0249",
        messagingSenderId: "538896768620",
        projectId: "naijamart-e16de"
      ),
    );
    } else if (Platform.isIOS) {
      await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDauRilbL4oXJT3cr_Tb6dxVcn8SpTchgc",
        appId: "1:538896768620:ios:5a999aa25bc939b90f0249",
        messagingSenderId: "538896768620",
        projectId: "naijamart-e16de"
      ),
    );
    }
  
  await FirebaseApi().initNotifications();
  LocalCache().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppModeCubit>(create: (context) => AppModeCubit()),
        BlocProvider<WalkThroughCubit>(create: (context) => WalkThroughCubit()),
         BlocProvider<NotificationCubit>(create: (context) => NotificationCubit(InAppNotificationRepository()),)
      ],
      child: MaterialApp(
        title: 'Naijamart',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: NaijaMartAppColors.greyText),
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          useMaterial3: true,
        ),
        home:   const MeDashboardScreen(), //const UniqueUserIdScreen(),  // const EmailScreenSignUp(), // const SetPasswordSignUpScreen(), //
        routes: {
          GetStarted.routeName: (context) => const GetStarted(),
          SplashScreen.routeName: (context) => const SplashScreen(),
          MeDashboardScreen.routeName: (context) => const MeDashboardScreen(),
          AllNotificationsScreen.routeName: (context) => const AllNotificationsScreen(),
          NotificationUI.routeName: (context) => const NotificationUI()
        },
      ),
    );
  }
}



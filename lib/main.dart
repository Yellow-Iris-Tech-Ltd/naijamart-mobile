import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naijamart/screen/auth/native_login_screen.dart';
import 'package:naijamart/screen/dashboard/bottom_navigation.dart';
import 'package:naijamart/screen/dashboard/home/all_notifications_screen.dart';
import 'package:naijamart/screen/dashboard/me_screen.dart';
import 'package:naijamart/screen/notification/firebase_notification_ui.dart';
import 'package:naijamart/screen/splash/naijamart_splash.dart';
import 'package:naijamart/screen/t&p/terms_of_usage_and_privacy_policy.dart';
import 'package:naijamart/screen/walkthrough/get_started.dart';
import 'package:naijamart/util/cache/local.dart';
import 'package:naijamart/util/constants/naijamart_app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'data/cubit/lightdark/app_mode_cubit.dart';
import 'data/cubit/notification/notification_cubit.dart';
import 'data/cubit/onboarding/walkthrough_cubit.dart';
import 'data/repository/notification_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAEHJ2kIeSdLoXWd3aNDUJFmju8uEvEDho",
        appId: "1:538896768620:android:b3d9f4a8a0e2f67e0f0249",
        messagingSenderId: "538896768620",
        projectId: "naijamart-e16de",
      ),
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDauRilbL4oXJT3cr_Tb6dxVcn8SpTchgc",
        appId: "1:538896768620:ios:5a999aa25bc939b90f0249",
        messagingSenderId: "538896768620",
        projectId: "naijamart-e16de",
      ),
    );
  }
  LocalCache().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppModeCubit>(create: (context) => AppModeCubit()),
        BlocProvider<WalkThroughCubit>(create: (context) => WalkThroughCubit()),
        BlocProvider<NotificationCubit>(
          create: (context) => NotificationCubit(InAppNotificationRepository()),
        ),
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
        home: const AppStartScreen(),
        routes: {
          GetStarted.routeName: (context) => const GetStarted(),
          SplashScreen.routeName: (context) => const SplashScreen(),
          NativeLoginScreen.routeName: (context) => const NativeLoginScreen(),
          MeDashboardScreen.routeName: (context) => const MeDashboardScreen(),
          AllNotificationsScreen.routeName: (context) => const AllNotificationsScreen(),
          NotificationUI.routeName: (context) => const NotificationUI(),
        },
      ),
    );
  }
}

class AppStartScreen extends StatefulWidget {
  const AppStartScreen({super.key});
  @override
  State<AppStartScreen> createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }
  Future<void> _route() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('naijamart_token');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => (token != null && token.isNotEmpty)
            ? const MeDashboardScreen()
            : const NativeLoginScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

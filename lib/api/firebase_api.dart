import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screen/notification/firebase_notification_ui.dart';
import '../screen/walkthrough/get_started.dart';
import '../util/cache/encrypted_storage.dart';


Future<void> handleBackgroundMessaging(RemoteMessage message) async {
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Payload: ${message.data}');
}

class FirebaseApi {

  final storage = EncryptedStorage();

  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      "high_importance_channel",
      "High Importance Notification",
    description: "This channel is used for important notification",
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if(message == null) return;

  /*
    navigatorKey.currentState?.pushNamed(
        BiometricLoginScreen.routeName,
       arguments: message
    );
    */
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings("@drawable/ic_launcher");
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
        onDidReceiveNotificationResponse: (payload){
        // final message = RemoteMessage.fromMap(jsonDecode(payload!));
        /*
          navigatorKey.currentState?.pushNamed(
            BiometricLoginScreen.routeName,);
             */
        }
       

    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }
Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage((handleBackgroundMessaging));
    FirebaseMessaging.onMessage.listen((message){
      final notification = message.notification;
      if(notification == null) return;
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
        payload: jsonEncode(message.toMap())
      );
    });
}

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();

    debugPrint('Token: $fCMToken');
    await storage.saveData('firebase_fcm_token', fCMToken!);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
    initPushNotifications();
    initLocalNotifications();
  }
}
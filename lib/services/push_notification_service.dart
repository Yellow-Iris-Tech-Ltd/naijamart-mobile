import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message: ${message.messageId}');
}

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  String? _fcmToken;
  Function(Map<String, dynamic>)? onNotificationTap;
  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true, badge: true, sound: true, provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      
      _fcmToken = await _fcm.getToken();
      debugPrint('FCM Token: $_fcmToken');

      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);
      }

      _fcm.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _registerTokenWithServer(newToken);
      });

      await _initializeLocalNotifications();
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          onNotificationTap?.call(jsonDecode(response.payload!));
        }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'naijamart_crm', 'NaijaMart CRM',
      description: 'CRM notifications', importance: Importance.high,
    );
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _localNotifications.show(
        notification.hashCode, notification.title, notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails('naijamart_crm', 'NaijaMart CRM', importance: Importance.high),
          iOS: DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    onNotificationTap?.call(message.data);
  }

  Future<bool> registerToken({required String authToken}) async {
    if (_fcmToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/fcm/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token': _fcmToken,
          'device_type': defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _registerTokenWithServer(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');
    if (authToken != null) await registerToken(authToken: authToken);
  }

  Future<bool> unregisterToken({required String authToken}) async {
    if (_fcmToken == null) return true;
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/fcm/unregister'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'token': _fcmToken}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
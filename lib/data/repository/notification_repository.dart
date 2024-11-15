

import 'dart:convert';

import '../../util/cache/local.dart';
import '../../util/constants/endpoints_uri.dart';
import '../models/notification/in_app_notification_model.dart';
import 'package:http/http.dart' as http;

class InAppNotificationRepository{
  LocalCache localCache = LocalCache();

  Future<bool> triggerNotification(Notification payload) async {
    final Uri uri = Uri.parse(NaijaMartEndpoints.triggerNotificationUrl);

    final response = await http.post(
      uri,
      body: jsonEncode(payload.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${localCache.getValue<String>('auth_token')
        }',
        // Include the bearer token in the headers
      },
    );

    if(response.statusCode == 200){
      return true;
    } else {
      throw Exception("Triggering notification failed: ${response.statusCode}");
    }

  }
}
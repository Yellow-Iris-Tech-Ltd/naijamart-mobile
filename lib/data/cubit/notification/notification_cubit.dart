

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart' hide Notification;
import '../../../util/cache/encrypted_storage.dart';
import '../../../util/cache/local.dart';
import '../../models/notification/in_app_notification_model.dart';
import '../../repository/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState>{

  final storage = EncryptedStorage();
  LocalCache localCache = LocalCache();
  final InAppNotificationRepository inAppNotificationRepository;

  NotificationCubit(this.inAppNotificationRepository) : super(NotificationIdle());

  Future<void> sendNotification(String? title, String? content) async {

    emit(NotificationProgress());
    String? fcmToken = await storage.readData("firebase_fcm_token");

    if(title == null || content == null || fcmToken == null){
      return;
    }

    Notification notification = Notification(
        deviceToken: fcmToken,
        title: title,
        body: content
    );

    try{
      final response = await inAppNotificationRepository.triggerNotification(notification);
      if(response){
        emit(NotificationSuccess(true));
      }
    } catch (e){
      debugPrint(e.toString());
      emit(NotificationFailure(e.toString()));
    }
    return;
  }


}

abstract class NotificationState {}

class InitialNotificationState extends NotificationState{}

class NotificationIdle extends NotificationState{}

class NotificationProgress extends NotificationState{}

class NotificationSuccess extends NotificationState{
  final bool status;
  NotificationSuccess(this.status);
}

class NotificationFailure extends NotificationState{
  final String errorMessage;
  NotificationFailure(this.errorMessage);
}
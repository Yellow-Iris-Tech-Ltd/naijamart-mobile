import 'dart:async';

import 'package:flutter/material.dart';

import '../../util/cache/encrypted_storage.dart';
import '../../util/cache/local.dart';
import '../widgets/alert_utility.dart';

mixin AutomaticLogoutMixin<T extends StatefulWidget> on State<T> { // Apply mixin to State
  final LocalCache _localCache = LocalCache();
  final storage = EncryptedStorage();

  late Timer _timer;
  final int _inactiveDuration = (60 * 5); // 60 seconds (1 minute)

  /// Track last user interaction time
  DateTime _lastInteractionTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: _inactiveDuration), _logout);
    _resetTimer();
  }

  void _resetTimer() {
    _timer.cancel();
    final now = DateTime.now();
    final isInactive = Duration(seconds: _inactiveDuration) < now.difference(_lastInteractionTime);
    if (isInactive) {
      _logout();
    } else {
      _timer = Timer(Duration(seconds: _inactiveDuration), _logout);
    }
  }

  void _logout() async {
    try {
      await _localCache.clearAll();
      Navigator.of(context).popUntil((route) => route.isFirst);

      String? email = await storage.readData("email_biometric");


    } catch (e) {
      // showToastMessage(message: '');
      debugPrint("Failed to logout due to error ${e.toString()}");
    }
  }



  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    // super.didUpdateWidget(oldWidget);
    _resetTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer when disposing the widget
    super.dispose();
  }

  /// Call this method on user interactions
  void onUserInteraction() {
    _lastInteractionTime = DateTime.now();
    _resetTimer();
  }
}

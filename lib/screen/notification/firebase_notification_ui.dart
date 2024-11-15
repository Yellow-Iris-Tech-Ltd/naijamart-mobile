import 'package:flutter/material.dart';

class NotificationUI extends StatelessWidget {
  static const routeName = '/notification-ui';

  const NotificationUI({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Naijamart Notification"),),
      body:  Center(
        child: SizedBox(
          width: size.width,
          height: size.height,
        ),
      ),
    );
  }
}

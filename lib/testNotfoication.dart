import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TestNotification extends StatefulWidget {
  const TestNotification({super.key});

  @override
  State<TestNotification> createState() => _TestNotificationState();
}

class _TestNotificationState extends State<TestNotification> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    if (!Platform.isIOS) {
      // استمع لتغير APNs token
      _firebaseMessaging.onTokenRefresh.listen((token) {
        print("APNs token updated: $token");
      });

      _firebaseMessaging.getAPNSToken().then((token) {
        if (token != null) {
          print("Initial APNs token: $token");
        }
      });
    } else {
      // على أندرويد
      _firebaseMessaging.getToken().then((token) {
        print("FCM token: $token");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (Platform.isIOS) {
              String? token = await _firebaseMessaging.getAPNSToken();
              print("Button APNs token: $token");
            } else {
              String? token = await _firebaseMessaging.getToken();
              print("Button FCM token: $token");
            }
          },
          child: Text("Check token"),
        ),
      ),
    );
  }
}

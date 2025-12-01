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


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {

            String? token = await _firebaseMessaging.getAPNSToken();

            if (token == null) {
             token = await _firebaseMessaging.getToken();
              print("Button FCM token: $token");
            } else if (token == null){
              print("Button APNS 2 token: $token");

            }else{
              token = await FirebaseMessaging.instance.getAPNSToken();
              print("Button APNS 2 token: $token");

            }

          },
          child: Text("Check token"),
        ),
      ),
    );
  }
}

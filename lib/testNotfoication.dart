import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestNotification extends StatelessWidget {
  TestNotification({super.key});
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Source - https://stackoverflow.com/a
            // Posted by MSARKrish
            // Retrieved 2025-12-01, License - CC BY-SA 4.0

            if (Platform.isIOS) {
              await Future.delayed(Duration(seconds: 1));

              String? apnsToken = await _firebaseMessaging.getAPNSToken();
             
                await Future<void>.delayed(const Duration(seconds: 3));
                apnsToken = await _firebaseMessaging.getAPNSToken();
              
                print("token : $apnsToken");

                  await Future.delayed(Duration(seconds: 1));

                _firebaseMessaging.getToken().then((t){
                  print("token of t : $t");
                });

              await Future.delayed(Duration(seconds: 2));

            } else {
            }
          },
          child: Text("check"),
        ),
      ),
    );
  }
}

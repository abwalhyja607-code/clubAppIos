import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../main.dart';
import 'notificationScreen.dart';


class FirebaseNotification {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> initNotifications() async {
    // طلب إذن الإشعارات
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );


    if(Platform.isIOS ){
      if(settings.authorizationStatus == AuthorizationStatus.authorized){
     // الحصول على Token الجهاز (استخدمه لإرسال إشعارات اختبارية)
      String? token = await _messaging.getToken();
      print("FCM Token: $token");

      // معالجة الإشعارات عندما يكون التطبيق مفتوحًا
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received message: ${message.notification?.title}');
        // يمكنك عرض إشعار محلي هنا باستخدام حزمة مثل flutter_local_notifications
      });

      return token ;
      }else{
        return "Permission denied not AuthorizationStatus";
      }
    }




    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      debugPrint("User declined notifications");
      return null;
    }

    // الحصول على FCM Token
    try {
      String? token = await _messaging.getToken();
      debugPrint("FCM Token: $token");
      return token;
    } catch (e) {
      debugPrint("Error getting FCM Token: $e");
      return null;
    }
  }

  void listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint("FCM Token refreshed: $newToken");
    });
  }

  void handleBackgroundMessages() {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    _messaging.getInitialMessage().then(_handleMessage);
  }

  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(NotificationScreen.routeName);
  }
}

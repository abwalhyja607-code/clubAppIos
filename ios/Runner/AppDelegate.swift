import Flutter
import UIKit
import FirebaseCore  // أضف هذا لـ Firebase
import FirebaseMessaging  // أضف هذا للإشعارات

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {  // أضف MessagingDelegate
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // تهيئة Firebase
   // FirebaseApp.configure()
    
    // تعيين المندوب للرسائل
    Messaging.messaging().delegate = self
    
    // طلب إذن الإشعارات
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("خطأ في طلب الإذن: \(error)")
      } else {
        print("تم منح الإذن: \(granted)")
      }
    }
    
    // تسجيل الجهاز للإشعارات
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// امتداد للتعامل مع التوكنات والإشعارات
extension AppDelegate: UNUserNotificationCenterDelegate {
  // عند تلقي إشعار في الخلفية
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound, .badge])
  }
  
  // عند النقر على الإشعار
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // يمكنك إضافة منطق هنا للتعامل مع النقر
    completionHandler()
  }
}

// امتداد للتعامل مع Firebase Messaging
extension AppDelegate: MessagingDelegate {
  // عند تحديث التوكن
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    if let token = fcmToken {
      print("FCM Token: \(token)")
      // أرسل التوكن إلى خادمك أو Firebase (مثل Firestore)
      // مثال: await FirebaseFirestore.instance.collection('tokens').add({'token': token});
    }
  }
}

import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: FlutterAppDelegate, MessagingDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // تهيئة Firebase
    FirebaseApp.configure()

    // تعيين delegate للـ Firebase Messaging
    Messaging.messaging().delegate = self

    // إعداد إشعارات المستخدم
    UNUserNotificationCenter.current().delegate = self

    // تسجيل الجهاز لاستقبال الإشعارات البعيدة
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // إعادة تعريف دالة تسجيل الجهاز لاستقبال إشعارات APNs
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // استلام توكن FCM
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("iOS FCM Token: \(fcmToken ?? "")")
      // يمكن هنا إرسال التوكن للسيرفر إذا أردت
  }
}

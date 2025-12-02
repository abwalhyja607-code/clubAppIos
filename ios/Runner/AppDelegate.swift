import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    // تهيئة Firebase إذا لم يكن مهيأ مسبقاً
    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }

    GeneratedPluginRegistrant.register(with: self)

    // تعيين delegate لإشعارات Push
    UNUserNotificationCenter.current().delegate = self

    // تسجيل الجهاز لدى APNs
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ربط APNs Device Token مع Firebase Messaging
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
  }
}

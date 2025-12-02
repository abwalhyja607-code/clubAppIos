import UIKit
import Flutter
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    // 1️⃣ تهيئة Firebase إذا لم يكن مهيأ مسبقاً
    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }

    // 2️⃣ تسجيل كل Plugins الخاصة بـ Flutter
    GeneratedPluginRegistrant.register(with: self)

    // 3️⃣ تهيئة إشعارات Push
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
        if let error = error {
            print("خطأ أثناء طلب إذن الإشعارات: \(error.localizedDescription)")
        }
    }
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 4️⃣ ربط APNs Device Token مع Firebase Messaging
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
  }

  // 5️⃣ التعامل مع استقبال إشعارات أثناء عمل التطبيق في الخلفية أو الأمام
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert, .badge, .sound])
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
      completionHandler()
  }
}

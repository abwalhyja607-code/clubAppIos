import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: FlutterAppDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure()

    // Delegate for FCM token refresh + background handling
    Messaging.messaging().delegate = self

    // IMPORTANT: iOS notification delegate for foreground notifications
    UNUserNotificationCenter.current().delegate = self

    // Request notification permissions (alert + sound + badge)
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        print("iOS Notification Permission Granted: \(granted)")
    }

    // Register device for APNs
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // -----------------------------
  // Receive APNs Device Token
  // -----------------------------
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
      print("APNs Token: \(deviceToken)")
  }

  // -----------------------------
  // FCM Token Refresh
  // -----------------------------
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("iOS FCM Token: \(fcmToken ?? "")")
      // send token to server if needed
  }

  // -----------------------------
  // Show notification while app is foreground
  // -----------------------------
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

      completionHandler([.banner, .sound, .badge])
  }

  // -----------------------------
  // Handle notification tap
  // -----------------------------
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {

      // هذا الجزء مهم حتى يستجيب Flutter عند الضغط على الإشعار
      Messaging.messaging().appDidReceiveMessage(response.notification.request.content.userInfo)

      completionHandler()
  }
}

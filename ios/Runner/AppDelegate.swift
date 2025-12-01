import UIKit
import Flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {


let channelName: String = "PushNotificationChannel"
var deviceToken: String = ""

override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let pushNotificationChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
    }

    pushNotificationChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
        switch call.method {
        case "requestNotificationPermissions":
            self?.requestNotificationPermissions(result: result)
        case "registerForPushNotifications":
            self?.registerForPushNotifications(application: application, result: result)
        case "retrieveDeviceToken":
            self?.getDeviceToken(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}

private func requestNotificationPermissions(result: @escaping FlutterResult) {
    if #available(iOS 10.0, *) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            result(granted)
        }
    } else {
        result(false)
    }
}

private func registerForPushNotifications(application: UIApplication, result: @escaping FlutterResult) {
    application.registerForRemoteNotifications()
    result(true)
}

private func getDeviceToken(result: @escaping FlutterResult) {
    result(deviceToken)
}

override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    self.deviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
}


}

import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GMSServices.provideAPIKey("AIzaSyAIVJL0nZPQc-N3EZ0YJCH90R4ZYxWMipY")
    GeneratedPluginRegistrant.register(with: self)    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

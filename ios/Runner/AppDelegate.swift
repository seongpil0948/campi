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
    GMSServices.provideAPIKey("AIzaSyDtVadFa64BpO8BxD55xfP3gwQFpXJ9Zeo")
    GeneratedPluginRegistrant.register(with: self)    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

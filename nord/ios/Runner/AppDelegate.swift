import UIKit
import Flutter
import GoogleMaps
import YandexMapsMobile

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyArLAGgB0ve7ZZ3yxdbNyHVGl0HCq16kFQ")
    YMKMapKit.setApiKey("5c7d7c5c-4960-4a49-9664-091d0215e80c")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

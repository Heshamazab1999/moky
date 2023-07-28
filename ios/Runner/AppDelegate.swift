import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import GoogleMaps
import flutter_downloader
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyCcr56ZxhkvdYntPYfiUmPruGo8kt4eqWk")
    GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken : Data){
          Messaging.messaging().apnsToken=deviceToken
          print("Token : \(deviceToken)")
              try! setExcludeFromiCloudBackup(isExcluded: true)
          super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)

      }

       private func setExcludeFromiCloudBackup(isExcluded: Bool) throws {
              var fileOrDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
              var values = URLResourceValues()
              values.isExcludedFromBackup = isExcluded
              try fileOrDirectoryURL.setResourceValues(values)
          }
}




private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}

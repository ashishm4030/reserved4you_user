import UIKit
import Flutter
import Firebase
import FBSDKCoreKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey("AIzaSyA5pxLBa96kQj0qywyovHcBv73gOD5zla8")
        if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handledFB = ApplicationDelegate.shared.application(app, open: url, options: options)
        return handledFB
    }
}

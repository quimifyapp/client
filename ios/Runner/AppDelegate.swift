import UIKit
import Flutter

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller = window.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "airplane_mode_checker", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "isAirplaneModeOn" {
                let isAirplaneModeOn = self?.isAirplaneModeOn()
                result(isAirplaneModeOn)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func isAirplaneModeOn() -> Bool {
        return UIApplication.shared.isAirplaneModeEnabled
    }
}

extension UIApplication {
    var isAirplaneModeEnabled: Bool {
        return !UIApplication.shared.isNetworkActivityIndicatorVisible
    }
}

import Flutter
import UIKit

public class SwiftFunctionalGoogleMobileAdsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "functional_google_mobile_ads", binaryMessenger: registrar.messenger())
    let instance = SwiftFunctionalGoogleMobileAdsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

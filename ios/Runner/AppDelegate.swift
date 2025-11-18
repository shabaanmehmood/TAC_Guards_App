import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Initialize Google Maps if an API key is provided in Info.plist.
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String,
       !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      GMSServices.provideAPIKey(apiKey)
      // Print a masked version of the key so we can confirm injection without leaking full key
      let masked = String(apiKey.prefix(6)) + String(repeating: "*", count: max(0, apiKey.count - 12)) + String(apiKey.suffix(6))
      print("[AppDelegate] Google Maps API key provided from Info.plist: \(masked)")
    } else {
      print("[AppDelegate] WARNING: GOOGLE_MAPS_API_KEY is missing in Info.plist")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
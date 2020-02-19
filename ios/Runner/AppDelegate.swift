import UIKit
import CallKit
import PushKit
import flutter_voip_push_notification
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle updated push credentials
  func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType,
                      completion: @escaping () -> Void){
    // Register VoIP push token (a property of PKPushCredentials) with server
    FlutterVoipPushNotificationPlugin.didReceiveIncomingPush(with: payload, forType: type.rawValue)
    
    // Retrieve information like handle and callerName here
    // NSString *uuid = /* fetch for payload or ... */ [[[NSUUID UUID] UUIDString] lowercaseString];
    // NSString *callerName = @"caller name here";
    // NSString *handle = @"caller number here";
    // FlutterCallKitPlugin.reportNewIncomingCall(uuid: uuid, handle:handle, handleType:@"generic", hasVideo:false, localizedCallerName:callerName, fromPushKit:YES)
    // completion();
  }

  // Handle incoming pushes
  func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
    // Process the received push
    FlutterVoipPushNotificationPlugin.didUpdate(pushCredentials, forType: type.rawValue);
  }
}


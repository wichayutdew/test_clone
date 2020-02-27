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

    
    let payloadDict = payload.dictionaryPayload["aps"] as! Dictionary<String, Any>
    let message = payloadDict["msg_data"] as! String
    print(message)
    let data = try! JSONSerialization.jsonObject(with: message.data(using: .utf8)!, options: []) as! [String:Any]
    let uuid = data["channelName"] as! String
    let handle = data["senderId"] as! Int
    let callerName = data["callerName"] as! String

    FlutterCallKitPlugin.reportNewIncomingCall(uuid: uuid, handle: handle, handleType:"generic", hasVideo:false, localizedCallerName:callerName, fromPushKit:true)
    
    completion();
    
  }

  // Handle incoming pushes
  func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
    // Process the received push
    FlutterVoipPushNotificationPlugin.didUpdate(pushCredentials, forType: type.rawValue);
  }
  
}


import UIKit
import CallKit
import PushKit
// import flutter_voip_push_notification
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate{
  // PKPushRegistryDelegate 
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // if #available(iOS 10.0, *) {
    //   UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    // }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  //  func pushRegistry(_ registry: PKPushRegistry,
  //                      didReceiveIncomingPushWith payload: PKPushPayload,
  //                      for type: PKPushType,
  //                      completion: @escaping () -> Void){
  //    FlutterVoipPushNotificationPlugin.didReceiveIncomingPush(with: payload, forType: type.rawValue)

    
    // let payloadDict = payload.dictionaryPayload["aps"] as! Dictionary<String, Any>
    // let message = payloadDict["msg_data"] as! String
    // print(message)
    // let data = try! JSONSerialization.jsonObject(with: message.data(using: .utf8)!, options: []) as! [String:Any]
    // let uuid = data["channelName"] as! String
    // let handle = data["senderId"] as! Int
    // let callerName = data["callerName"] as! String

    // FlutterCallKitPlugin.reportNewIncomingCall(uuid: uuid, handle: handle, handleType:"generic", hasVideo:false, localizedCallerName:callerName, fromPushKit:true)
    
    // completion();
    
  //  }
  //  func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
  //    FlutterVoipPushNotificationPlugin.didUpdate(pushCredentials, forType: type.rawValue);
  //  }
  
}


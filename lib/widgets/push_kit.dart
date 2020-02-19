import 'package:flutter_voip_push_notification/flutter_voip_push_notification.dart';

class PushKitWidget{
  String _pushToken = '';
  final FlutterVoipPushNotification _voipPush = FlutterVoipPushNotification();

  Future<void> regiseterPushkit() async {
    // request permission (required)
    await _voipPush.requestNotificationPermissions();

    // listen to voip device token changes
    _voipPush.onTokenRefresh.listen(onToken);

    // do configure voip push
    _voipPush.configure(
      onMessage: (bool isLocal, Map<String, dynamic> payload){
      // handle foreground notification
      print("received on foreground payload: $payload, isLocal=$isLocal");
      return null;
      }, onResume: (bool isLocal, Map<String, dynamic> payload){
        // handle background notification
        print("received on background payload: $payload, isLocal=$isLocal");
        showLocalNotification(payload);
        return null;
      }
    );
  }
  void onToken(String token) {
    _pushToken = token;
    
  }

  showLocalNotification(Map<String, dynamic> notification) {
    String alert = notification["aps"]["alert"];
    _voipPush.presentLocalNotification(LocalNotification(
      alertBody: "Hello $alert",
    ));
  }
}
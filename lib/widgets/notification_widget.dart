import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test_clone/locator.dart';
import 'package:test_clone/models/call.dart';
import 'package:test_clone/router.dart';
import 'package:test_clone/widgets/ios_call_screen.dart';



class NotificationWidget{
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  final CallScreenWidget _callScreenWidget = new CallScreenWidget();
  final NavigationService _navigation = locator<NavigationService>();

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    print(message);
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: $data");
      
    }
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: $notification");
    }
  }

  void registerNotification(currentUserId) {

    // startServiceInPlatform();

    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage: $message');
        if(message['notificationType'] == 'call'){
          IncomingCallData _incomingCallData = IncomingCallData(
            senderId: message['senderId'],
            channelName: message['channelName'],
            type: message['type'],
          );
          _navigation.navigateTo("/incoming_call",arguments: _incomingCallData);
        }
        // else if(Platform.isIOS){
        //   _callScreenWidget.displayIncomingCall(message['channelName'], 'dew10170@hotmail.com', message['callerName']);
        // }
        else{
          showNotification(message['notification']);
        }
        return;
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) {
        print('onResume: $message');
        return;
      }, onLaunch: (Map<String, dynamic> message) {
        print('onLaunch: $message');
        return;
    });

    firebaseMessaging.getToken().then((token) {
      Firestore.instance.collection('users').document(currentUserId).updateData({'pushToken': token});
    });
  }

  
  // void startServiceInPlatform() async {
  //   if(Platform.isAndroid){
  //     var methodChannel = MethodChannel("com.example.test_clone");
  //     String data = await methodChannel.invokeMethod("displayIncomingCall");
  //     print(data);
  //   }
  // }
  
  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  
  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }
  
  void showNotification2() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter chat demo', 'your channel description', platformChannelSpecifics,
        payload: 'message');
  }
}
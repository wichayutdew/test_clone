import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class NotificationWidget{
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
    print('notify');
    // Or do other work.
  }

 void registerNotification(currentUserId) {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage: $message');
        showNotification(message['notification']);
        return;
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) {
        print('onResume: $message');
        showNotification(message['notification']);
        return;
      }, onLaunch: (Map<String, dynamic> message) {
        print('onLaunch: $message');
        showNotification(message['notification']);
        return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token = $token');
      Firestore.instance.collection('users').document(currentUserId).updateData({'pushToken': token});
    });
 }
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
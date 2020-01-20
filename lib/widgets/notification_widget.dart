import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:test_clone/models/notification.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Notif> notifs = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
       onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final notification = message['notification'];
        setState(() {
          notifs.add(Notif(
              title: notification['title'], body: notification['body']));
        });
       },
       onLaunch: (Map<String, dynamic> message) async {
         print("onLaunch: $message");

         final notification = message['data'];
        setState(() {
          notifs.add(Notif(
            title:notification['title'],
            body: notification['body'],
          ));
        });
       },
       onResume: (Map<String, dynamic> message) async {
         print("onResume: $message");
       },
     );
     _firebaseMessaging.requestNotificationPermissions(
       const IosNotificationSettings(sound: true, badge: true, alert: true)
     );
  }
  @override
  Widget build(BuildContext context) => ListView(
    children: notifs.map(buildNotification).toList(),
  );

  Widget buildNotification(Notif notif) => ListTile(
    title : Text(notif.title),
    subtitle: Text(notif.body),
  );
}
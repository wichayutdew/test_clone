import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_clone/Screen/search_screen.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/widgets/notification_widget.dart';

import 'Screen/home_screen.dart';
import 'Screen/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  FirebaseRepository _repository = FirebaseRepository();
  
  NotificationWidget _notificationWidget = NotificationWidget();
  
  var _currentUserId;

  @override
  void initState() {
    _repository.getCurrentUser().then((user){_currentUserId = user.uid;});
    super.initState();
    
    _notificationWidget.registerNotification(_currentUserId);
    _notificationWidget.configLocalNotification();
  }
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title : "Skype Clone",
      debugShowCheckedModeBanner: false,
      initialRoute : "/",
      routes : {
        '/search_screen' : (context) => SearchScreen(),

      },
      theme : ThemeData(
        brightness : Brightness.dark,
      ),
      home : FutureBuilder(
        future : _repository.getCurrentUser(),
        builder : (context, AsyncSnapshot<FirebaseUser> snapshot){
          if(snapshot.hasData){
            return HomeScreen();
          }else{
            return LoginScreen();
          }
        },
      ),
    );
  }
}
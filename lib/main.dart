import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_clone/global_navigator/locator.dart';
import 'package:test_clone/global_navigator/router.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/widgets/notification_widget.dart';
import 'Screen/home_screen.dart';
import 'Screen/login_screen.dart';


void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  FirebaseRepository _repository = FirebaseRepository();
  NotificationWidget _notificationWidget = NotificationWidget();

  @override
  void initState() {
    super.initState();
    _notificationWidget.configLocalNotification();
  }
  
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap : (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title : "Skype Clone",
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: generateRoute,
        initialRoute : "/",
        theme : ThemeData(
          brightness : Brightness.light,
        ),
        home : FutureBuilder(
          future : _repository.getCurrentUser(),
          builder : (context, AsyncSnapshot<FirebaseUser> snapshot){
            if(snapshot.hasData){
              _notificationWidget.registerNotification(snapshot.data.uid);
              return HomeScreen();
            }else{
              return LoginScreen();
            }
          },
        ),
      )
    );
  }
}
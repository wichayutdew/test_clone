import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_clone/locator.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/router.dart';
import 'Screen/home_screen.dart';
import 'Screen/login_screen.dart';
import 'router.dart' as router;


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
        onGenerateRoute: router.generateRoute,
        initialRoute : "/",
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
      )
    );
  }
}
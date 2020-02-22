import 'package:flutter/material.dart';
import 'package:test_clone/Screen/home_screen.dart';
import 'package:test_clone/utils/universal_variables.dart';

class FailCallScreen extends StatefulWidget {
  @override
  FailCallScreenState createState() => new FailCallScreenState();
}

class FailCallScreenState extends State<FailCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar : new AppBar(
        leading : IconButton(
        icon : Icon(Icons.arrow_back, color : Colors.white,),
        onPressed : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen()
                            ),
                          )
      ),
      ),
      body : Stack(
        children : [
          Center(
            child : Text(
              "FAIL",
              style: TextStyle(fontSize : 35, fontWeight : FontWeight.w900, letterSpacing : 1.2),
            ),
          )
        ], 
      ),
    );
  }
}
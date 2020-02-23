import 'package:flutter/material.dart';
import 'package:test_clone/Screen/home_screen.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/utils/universal_variables.dart';

class FailCallScreen extends StatefulWidget {
  final String channelName;
  /// Creates a call page with given channel name.
  const FailCallScreen({Key key, @required this.channelName}) : super(key: key);
  @override
  FailCallScreenState createState() => new FailCallScreenState();
}

class FailCallScreenState extends State<FailCallScreen> {

  FirebaseRepository _repository = FirebaseRepository();

  void dispose(){
    super.dispose();
    _repository.endCall(widget.channelName);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar : new AppBar(
        leading : IconButton(
        icon : Icon(Icons.arrow_back, color : Colors.white,),
        onPressed : () => {_repository.endCall(widget.channelName),
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen()
                              ),
                            )
                          }
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
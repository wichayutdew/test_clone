import 'package:flutter/material.dart';
import 'package:test_clone/Screen/home_screen.dart';
import 'package:test_clone/models/call.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/utils/universal_variables.dart';

class FinishCallScreen extends StatefulWidget {
  final CallData callData;
  const FinishCallScreen({Key key, @required this.callData}) : super(key: key);
  @override
  FinishCallScreenState createState() => new FinishCallScreenState();
}

class FinishCallScreenState extends State<FinishCallScreen> {

  FirebaseRepository _repository = FirebaseRepository();
  
  CallData callData;

  void dispose(){
    super.dispose();
    _repository.endCall(widget.callData.channelName);
  }

  void endHandler() async{
    if(widget.callData.status == 'finished'){
      await _repository.pendingEndCall(widget.callData.channelName);
    }else if (widget.callData.status == 'pendingterminated'){
      await _repository.endCall(widget.callData.channelName);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen()
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar : new AppBar(
        leading : IconButton(
        icon : Icon(Icons.arrow_back, color : Colors.white,),
        onPressed : () => {endHandler()}
      ),
      ),
      body : Stack(
        children : [
          Center(
            child : Text(
              "SUMMARY",
              style: TextStyle(fontSize : 35, fontWeight : FontWeight.w900, letterSpacing : 1.2),
            ),
          )
        ], 
      ),
    );
  }
}
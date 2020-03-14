import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_clone/Screen/callscreens/video_call_page.dart';
import 'package:test_clone/Screen/callscreens/voice_call_page.dart';
import 'package:test_clone/Screen/home_screen.dart';
import 'package:test_clone/Screen/summaryscreens/failed_call.dart';
import 'package:test_clone/Screen/summaryscreens/finished_call.dart';
import 'package:test_clone/models/call.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/utils/call_status.dart';

class PendingCallPage extends StatefulWidget {

  final CallData callData;
  
  const PendingCallPage({Key key, @required this.callData}) : super(key: key);

  @override
  _PendingCallPageState createState() => _PendingCallPageState();
}

class _PendingCallPageState extends State<PendingCallPage> {

  FirebaseRepository _repository = FirebaseRepository();

    Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              _repository.cancelCall(widget.callData.channelName);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen()
                ),
              );
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.red,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  Widget _calling(){
    return FutureBuilder(
      future : _repository.getUser(widget.callData.receiverId),
      builder : (context, snapshot){
        if(snapshot.hasData){
          return Container(
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Text(
                  snapshot.data.username,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20),
                ),
                CircleAvatar(
                  maxRadius : 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(snapshot.data.profilePhoto),
                )
              ],
              ),
            );
        }else{
          return Container();
        }
      }
    );
  }
  
  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  Future<void> _handleMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.microphone],
    );
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("calls").where("channelName", isEqualTo : widget.callData.channelName).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData && snapshot.data.documents.length != 0){
          CallData callData = CallData.fromMap(snapshot.data.documents[0].data);
          String callStatus = callData.status;
          if(callStatus == CallStatus.incall && callData.type == 'voice'){
            _handleMic();
            return VoiceCallPage(channelName: callData.channelName);
          }else if(callStatus == CallStatus.incall && callData.type == 'video'){
            _handleCameraAndMic();
            return VideoCallPage(channelName: callData.channelName);
          }else if(callStatus == CallStatus.rejected){
            return FailCallScreen(channelName: callData.channelName);
          }
          else if(callStatus == CallStatus.finished || callStatus == CallStatus.pendingterminated){
            return FinishCallScreen(callData:callData);
          }
          else if(callStatus == CallStatus.terminated){
            return HomeScreen();
          }
          else if(callStatus == CallStatus.initiated){
            return WillPopScope(
              onWillPop: ()async {
                if (Navigator.of(context).userGestureInProgress)
                  return false;
                else
                  return true;
              },
              child: Stack(
                children: <Widget>[
                  _calling(),
                  _toolbar(),
                ],
              )
            );
          }
        }
        return Scaffold(
          body : Stack(
            children : [
              Center(
                child : CircularProgressIndicator()
              )
            ]
          )
        );
      }
    );
  }
}

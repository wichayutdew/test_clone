import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_clone/Screen/callscreens/video_call_page.dart';
import 'package:test_clone/Screen/callscreens/voice_call_page.dart';
import 'package:test_clone/Screen/home_screen.dart';
import 'package:test_clone/Screen/summaryscreens/failed_call.dart';
import 'package:test_clone/models/call.dart';
import 'package:test_clone/models/user.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/widgets/ios_call_screen.dart';


class IncomingCallPage extends StatefulWidget {

  final IncomingCallData data;

  const IncomingCallPage({Key key, @required this.data}) : super(key: key);

  @override
  _IncomingCallPageState createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {

  FirebaseRepository _repository = FirebaseRepository();
  CallScreenWidget _callScreenWidget = CallScreenWidget();

  User caller = User();

  String currentUserid;

  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUserid = user.uid;
      });
    });
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


  Widget _caller(){
    return FutureBuilder(
      future : _repository.getUser(widget.data.senderId),
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

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              _callScreenWidget.rejectCall(widget.data.channelName);
              _repository.rejectCall(widget.data.channelName);
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
          RawMaterialButton(
            onPressed: () {
              if(widget.data.type == 'video'){
                _handleCameraAndMic();
                _repository.answerCall(widget.data.channelName);
                Navigator.push(
                context,
                  MaterialPageRoute(
                    builder: (context) => VideoCallPage(
                      channelName: widget.data.channelName,
                    ),
                  ),
                );
              }else if (widget.data.type == 'voice'){
                _handleMic();
                _repository.answerCall(widget.data.channelName);
                Navigator.push(
                context,
                  MaterialPageRoute(
                    builder: (context) => VoiceCallPage(
                      channelName: widget.data.channelName,
                    ),
                  ),
                );
              }
            },
            child: Icon(
              Icons.call,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.green,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("calls").where("channelName", isEqualTo : widget.data.channelName).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData && snapshot.data.documents.length != 0){
          var snapData = snapshot.data.documents[0];
          var callStatus = snapData['status'];
          if(callStatus == 'cancelled'){
            return Scaffold(
              body : FailCallScreen(channelName: widget.data.channelName)
            );
          }else{
            return WillPopScope(
              onWillPop: ()async {
                if (Navigator.of(context).userGestureInProgress)
                  return false;
                else
                  return true;
              },
              child: Stack(
                children: <Widget>[
                  _caller(),
                  _toolbar()
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
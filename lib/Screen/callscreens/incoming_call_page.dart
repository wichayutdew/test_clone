import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_clone/Screen/callscreens/video_call_page.dart';
import 'package:test_clone/Screen/callscreens/voice_call_page.dart';
import 'package:test_clone/Screen/home_screen.dart';
import 'package:test_clone/models/user.dart';
import 'package:test_clone/resources/firebase_repository.dart';

class IncomingCallPage extends StatefulWidget {

  final String channelName;
  final String type;

  final String senderId;

  const IncomingCallPage({Key key, @required this.channelName, @required this.type, @required this.senderId}) : super(key: key);

  @override
  _IncomingCallPageState createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {

  FirebaseRepository _repository = FirebaseRepository();
  User caller = User();

  void dispose(){
    _repository.deleteChannelName(widget.channelName);
    super.dispose();
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
      future : _repository.getUser(widget.senderId),
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
      },
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
              _repository.deleteChannelName(widget.channelName);
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
              if(widget.type == 'video'){
                _handleCameraAndMic();
                Navigator.push(
                context,
                  MaterialPageRoute(
                    builder: (context) => VideoCallPage(
                      channelName: widget.channelName,
                    ),
                  ),
                );
              }else if (widget.type == 'voice'){
                _handleMic();
                Navigator.push(
                context,
                  MaterialPageRoute(
                    builder: (context) => VoiceCallPage(
                      channelName: widget.channelName,
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


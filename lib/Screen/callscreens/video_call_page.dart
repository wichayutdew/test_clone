import 'dart:async';
// import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_clone/Screen/home_screen.dart';
import 'package:test_clone/Screen/summaryscreens/failed_call.dart';
import 'package:test_clone/Screen/summaryscreens/finished_call.dart';
import 'package:test_clone/models/call.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/utils/call_status.dart';
// import 'package:test_clone/widgets/ios_call_screen.dart';

class VideoCallPage extends StatefulWidget {

  final String channelName;
  
  const VideoCallPage({Key key, @required this.channelName}) : super(key: key);

  @override
  _VideoCallPageState createState() => new _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {

  FirebaseRepository _repository = FirebaseRepository();
  // CallScreenWidget _callScreenWidget = CallScreenWidget();


  static const APP_ID = '9826de69c0a14497b203f63fbc0aa7cb';
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;

  String currentUserid;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
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
    // initialize agora sdk
    _initialize(widget.channelName);
  }


  Future<void> _initialize(channelName) async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    AgoraRtcEngine.setParameters('{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}');
    AgoraRtcEngine.setParameters("{\"rtc.log_filter\": 65535}");
    await AgoraRtcEngine.joinChannel(null,channelName,null,0);
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  Future<void> _onToggleMute() async {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  Future<void> _onSwitchCamera() async {
    AgoraRtcEngine.switchCamera();
  }

  Future<void> _onCallEnd(BuildContext context) async {
    // if(Platform.isIOS){
    //   _callScreenWidget.endCall(widget.channelName);
    // }
    CallData callData = await _repository.getCallData(widget.channelName);
    if(callData.status == 'incall'){
      await _repository.finishCall(widget.channelName);
    }else{
      await _repository.cancelCall(widget.channelName);
      Navigator.pop(context);
    }
  }



  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[
                _videoView(views[0])
              ]
            )
        );
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ]
            )
        );
      default:
    }
    return Container();
  }


   /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
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
            onPressed: _onToggleMute,
            child: Icon(
              Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("calls").where("channelName", isEqualTo : widget.channelName).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
        
        if(snapshot.hasData && snapshot.data.documents.length != 0){
          CallData callData = CallData.fromMap(snapshot.data.documents[0].data);
          String callStatus = callData.status;
          
          if(callStatus == CallStatus.rejected){
            AgoraRtcEngine.leaveChannel();
            AgoraRtcEngine.destroy();
            return FailCallScreen(channelName:widget.channelName);
          }
          else if(callStatus == CallStatus.finished || callStatus == CallStatus.pendingterminated){
            AgoraRtcEngine.leaveChannel();
            AgoraRtcEngine.destroy();
            return FinishCallScreen(callData:callData);
          }
          else if(callStatus == CallStatus.terminated){
            return HomeScreen();
          }
          else if (callStatus == CallStatus.initiated  || callStatus == CallStatus.incall){
            return WillPopScope(
            onWillPop: ()async {
              if (Navigator.of(context).userGestureInProgress)
                return false;
              else
                return true;
            },
            child: Scaffold(
              body: Center(
                child: Stack(
                  children: <Widget>[
                    _viewRows(),
                    _panel(),
                    _toolbar(),
                  ],
                ),
              ),
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
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_clone/Screen/callscreens/call_page.dart';

class IncomingCallPage extends StatefulWidget {

  final String channelName;

  const IncomingCallPage({Key key, @required this.channelName}) : super(key: key);

  @override
  _IncomingCallPageState createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

    /// Toolbar layout
  Widget _toolbar() {
    print(widget.channelName);
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              Navigator.pop(context);
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
              _handleCameraAndMic();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallPage(
                    channelName: widget.channelName,
                  ),
                ),
              );
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: _toolbar(),
    );
  }
}


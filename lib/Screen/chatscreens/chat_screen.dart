import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_clone/Screen/callscreens/video_call_page.dart';
import 'package:test_clone/Screen/callscreens/voice_call_page.dart';
import 'package:test_clone/widgets/ios_call_screen.dart';
import 'package:uuid/uuid.dart';

import 'package:test_clone/models/call.dart';
import 'package:test_clone/Screen/chatscreens/full_picture.dart';
import 'package:test_clone/models/message.dart';
import 'package:test_clone/models/user.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/utils/universal_variables.dart';
import 'package:test_clone/widgets/appbar.dart';
import 'package:test_clone/widgets/custom_tile.dart';


class ChatScreen extends StatefulWidget {
  final User receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  FirebaseRepository _repository = FirebaseRepository();
  ScrollController _controller = ScrollController();
  CallScreenWidget _callScreenWidget = CallScreenWidget();
  Uuid uuid = Uuid();

  User sender;
  String _currentUserId;

  File image;
  String imageUrl = '';
  
  bool isLoading = false;

  bool isWriting = false;

  void dispose() {
    Firestore.instance.collection('users').document(_currentUserId).updateData({'chatWith': ''});
    super.dispose();
  }

  void initState(){
    super.initState();
    imageUrl = '';
    isLoading = false;
    _repository.getCurrentUser().then((user){
      _currentUserId = user.uid;
      setState(() {
        sender = User(
          uid : user.uid,
          name : user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
      Firestore.instance.collection('users').document(user.uid).updateData({'chatWith': widget.receiver.uid});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance.collection("messages").document(_currentUserId).collection(widget.receiver.uid).orderBy("timestamp", descending : true).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data == null){
          return Center(child: CircularProgressIndicator(),);
        }
        return ListView.builder(
          controller: _controller,
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.documents[index]);
          },
          reverse: true,
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId ? Alignment.centerRight : Alignment.centerLeft,
        child: _message.senderId == _currentUserId ? senderLayout(_message) : receiverLayout(_message),
      ),
    );
  }

  getMessage(Message message){
    return Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);
    Container _container = new Container();
    if(message.type =='text'){
      _container = Container(
        margin: EdgeInsets.only(top: 12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: BoxDecoration(
          color: UniversalVariables.senderColor,
          borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: getMessage(message),
        ),
      );
    }else if(message.type == 'image'){
      _container = Container(
        child: FlatButton(
          child: Material(
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
                width: 200.0,
                height: 200.0,
                padding: EdgeInsets.all(70.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Material(
                child: Image.asset(
                  'images/img_not_available.jpeg',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: message.message,
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            clipBehavior: Clip.hardEdge,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FullPhoto(url: message.message)));
          },
          padding: EdgeInsets.all(0),
        )
      );
    }
    return _container;
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);
    Container _container = new Container();
    if(message.type == 'text'){
      _container = Container(
        margin: EdgeInsets.only(top: 12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: BoxDecoration(
          color: UniversalVariables.receiverColor,
          borderRadius: BorderRadius.only(
            bottomRight: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: getMessage(message),
        ),
      );
    }else if(message.type == 'image'){
      _container = Container(
        child: FlatButton(
          child: Material(
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
                width: 200.0,
                height: 200.0,
                padding: EdgeInsets.all(70.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Material(
                child: Image.asset(
                  'images/img_not_available.jpeg',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: message.message,
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            clipBehavior: Clip.hardEdge,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FullPhoto(url: message.message)));
          },
          padding: EdgeInsets.all(0),
        )
      );
    }
    return _container;
  }

  Widget chatControls(){

    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    // addMediaModal(context) {
    //   showModalBottomSheet(
    //     context: context,
    //     elevation: 0,
    //     backgroundColor: UniversalVariables.blackColor,
    //     builder: (context) {
    //       return Column(
    //         children: <Widget>[
    //           Container(
    //             padding: EdgeInsets.symmetric(vertical: 15),
    //             child: Row(
    //               children: <Widget>[
    //                 FlatButton(
    //                   child: Icon(
    //                     Icons.close,
    //                   ),
    //                   onPressed: () {
    //                     Navigator.maybePop(context);
    //                   },
    //                 ),
    //                 Expanded(
    //                   child: Align(
    //                     alignment: Alignment.centerLeft,
    //                     child: Text(
    //                       "Content and tools",
    //                       style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 20,
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Flexible(
    //             child: ListView(
    //               children: <Widget>[
    //                 ModalTile(
    //                   title: "Media",
    //                   subtitle: "Share Photos and Video",
    //                   icon: Icons.image,
                      
    //                 ),
    //                 ModalTile(
    //                   title: "File",
    //                   subtitle: "Share files",
    //                   icon: Icons.tab
    //                 ),
    //                 ModalTile(
    //                   title: "Contact",
    //                   subtitle: "Share contacts",
    //                   icon: Icons.contacts
    //                 ),
    //                 ModalTile(
    //                   title: "Location",
    //                   subtitle: "Share a location",
    //                   icon: Icons.add_location
    //                 ),
    //                 ModalTile(
    //                   title: "Schedule Call",
    //                   subtitle: "Arrange a skype call and get reminders",
    //                   icon: Icons.schedule
    //                 ),
    //                 ModalTile(
    //                   title: "Create Poll",
    //                   subtitle: "Share polls",
    //                   icon: Icons.poll
    //                 )
    //               ],
    //             ),
    //           ),
    //         ],
    //       );
    //     }
    //   );
    // }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          // GestureDetector(
          //   onTap: () => addMediaModal(context),
          //   child: Container(
          //     padding : EdgeInsets.all(5),
          //     decoration : BoxDecoration(
          //       gradient: UniversalVariables.fabGradient,
          //       shape: BoxShape.circle,
          //     ),
          //     child: Icon(Icons.add),
          //   ),
          // ),
          SizedBox(width: 5,),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style : TextStyle(
                color: Colors.white,
              ),
              onChanged: (val){
                (val.length > 0 && val.trim() != "") ?setWritingTo(true) : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: UniversalVariables.greyColor,
                ),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: UniversalVariables.separatorColor,
                suffixIcon: GestureDetector(
                  child: Icon(Icons.face),
                  onTap: () {},
                ),
              ),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting ? Container() : IconButton(icon:Icon(Icons.camera_alt), onPressed: () => {getImage()},),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(textFieldController.text,'text'),
                  ))
              : Container()
        ],
      ),
    );
  }

  sendMessage(String content, String type) {
    Message _message = new Message();
    if(type == 'text'){
      _message = Message(
        receiverId : widget.receiver.uid,
        senderId : sender.uid,
        message: content,
        timestamp: Timestamp.now(),
        type:'text',
      );
      textFieldController.clear();
    }else if(type == 'image'){
      _message = Message(
        receiverId : widget.receiver.uid,
        senderId : sender.uid,
        message: content,
        timestamp: Timestamp.now(),
        type:'image',
      );
    }
    setState(() {
        isWriting = false;
    });
    _controller.jumpTo(_controller.position.minScrollExtent);
    _repository.addMessageToDb(_message);
    
  }

  getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }
  
  uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        sendMessage(imageUrl,'image');
      });
    }, onError: (err) {
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

  uploadCallData(String channelName, String type){
    CallData _callData = CallData(
      receiverId : widget.receiver.uid,
      senderId : sender.uid,
      channelName: channelName,
      type: type,
      status: 'initiated',
      timestamp: Timestamp.now(),
    );
    _repository.addChannelName(_callData);
    _callScreenWidget.startCall(channelName, 'dew10170@hotmail.com', _currentUserId);
  }


  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () {

            _handleCameraAndMic();
            String channelName = uuid.v1();
            uploadCallData(channelName, "video");
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoCallPage(
                  channelName: channelName,
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () {

            _handleMic();
            String channelName = uuid.v1();
            uploadCallData(channelName, "voice");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoiceCallPage(
                  channelName: channelName,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_clone/Screen/login_screen.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/utils/universal_variables.dart';
import 'package:test_clone/utils/utilities.dart';
import 'package:test_clone/widgets/appbar.dart';
import 'package:test_clone/widgets/custom_tile.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

//global
final FirebaseRepository _repository =  FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  
  String currentUserid;
  String initials = "";
  
  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUserid = user.uid;
        initials =  Utils.getInitials(user.displayName);
      });
      Firestore.instance.collection(UniversalVariables.users).document(user.uid).updateData({UniversalVariables.chatWith: ''});
    });
  }


  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
      leading : IconButton(
        icon : Icon(
          Icons.notifications,
          color : Colors.white,
        ),
        onPressed : () {},
      ),
      title : UserCircle(initials),
      centerTitle : true,
      actions: <Widget>[
        IconButton(
          icon : Icon(
            Icons.search,
            color : Colors.white,
          ),
          onPressed : () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),

        IconButton(
          icon : Icon(
            Icons.more_vert,
            color : Colors.white,
          ),
          onPressed : () {
            Firestore.instance.collection(UniversalVariables.users).document(currentUserid).updateData({UniversalVariables.pushToken:""});
            _repository.signOut();
            Navigator.pop(context); 
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
          },
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : UniversalVariables.blackColor,
      appBar : customAppBar(context),
      floatingActionButton: NewChatButton(),
      body : ChatListContainer(currentUserid),
    );
  }
}

class UserCircle extends StatelessWidget {
  final String text;

  UserCircle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height : 40,
      width : 40,
      decoration : BoxDecoration(
        borderRadius : BorderRadius.circular(50),
        color: UniversalVariables.separatorColor,
      ),
      child : Stack(
        children : <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style : TextStyle(
                fontWeight : FontWeight.bold,
                color : UniversalVariables.lightBlueColor,
                fontSize : 13,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child : Container(
              height : 12,
              width : 12,
              decoration: BoxDecoration(
                shape : BoxShape.circle,
                border : Border.all(
                  color: UniversalVariables.blackColor,
                  width : 2, 
                  ),
                color : UniversalVariables.onlineDotColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration : BoxDecoration(
        gradient : UniversalVariables.fabGradient,
        borderRadius : BorderRadius.circular(50), 
      ),
      child : Icon(
          Icons.edit,
          color : Colors.white,
          size : 25,
      ),
      padding : EdgeInsets.all(15),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;

  ChatListContainer(this.currentUserId);
  
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child : ListView.builder(
        padding : EdgeInsets.all(10),
        itemCount : 2,
        itemBuilder : (context, index) {
          return CustomTile(
            mini : false,
            onTap: () {},
            title : Text(
              "Dew",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Arial",
                fontSize: 19,
              ),
            ),
            subtitle : Text(
              "Hello",
              style : TextStyle(
                color : UniversalVariables.greyColor,
                fontSize: 14,
              ),
            ),
            leading : Container(
              constraints : BoxConstraints(maxHeight : 60, maxWidth : 60),
              child : Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius : 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage("https://yt3.ggpht.com/a/AGF-l7_zT8BuWwHTymaQaBptCy7WrsOD72gYGp-puw=s900-c-k-c0xffffffff-no-rj-mo"),
                  ),
                  Align(
                    alignment : Alignment.bottomRight,
                    child : Container(
                      height : 30,
                      width : 30,
                      decoration : BoxDecoration(
                        shape : BoxShape.circle,
                        color : UniversalVariables.onlineDotColor,
                        border : Border.all(
                          color : UniversalVariables.blackColor,
                          width : 2
                        ) 
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_clone/Screen/callscreens/incoming_call_page.dart';
import 'package:test_clone/Screen/pageviews/chat_list_screen.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/utils/universal_variables.dart';
import 'package:test_clone/widgets/notification_widget.dart';

class HomeScreen extends StatefulWidget {


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseRepository _repository = FirebaseRepository();
  NotificationWidget _notificationWidget = NotificationWidget();

  PageController pageController;
  int _page = 0;
  String _currentUserId;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _repository.getCurrentUser().then((user){
      _currentUserId = user.uid;
      _notificationWidget.registerNotification(user.uid);
      _notificationWidget.configLocalNotification();
    });
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {

    double _labelFontSize = 10;

    return StreamBuilder(
      stream: Firestore.instance.collection("calls").where("receiverId", isEqualTo : _currentUserId).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data != null){
          if (snapshot.data.documents.length != 0){
            DocumentSnapshot snapData = snapshot.data.documents[0];
            return Scaffold(
              body : IncomingCallPage(channelName: snapData['channelName'],type : snapData['type'], senderId: snapData['senderId'],),
            );
          }
        }
        return Scaffold(
      
          backgroundColor :  UniversalVariables.blackColor,
          
          body : PageView(
            children : <Widget>[
              Container(child:ChatListScreen(),),
              Center(child : Text("Call Logs", style : TextStyle(color: Colors.white))),
              Center(child : Text("Contact Screen", style : TextStyle(color: Colors.white))),
            ],
            controller : pageController,
            onPageChanged : onPageChanged,
            physics : NeverScrollableScrollPhysics(),
          ),

          bottomNavigationBar : Container(
            child : Padding(
              padding : EdgeInsets.symmetric(vertical : 10),
              child : CupertinoTabBar(
                backgroundColor : UniversalVariables.blackColor,
                items : <BottomNavigationBarItem>[
                  
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat,
                      color : (_page == 0) ? UniversalVariables.lightBlueColor: UniversalVariables.greyColor
                    ),
                    title : Text(
                      "Chats",
                      style: TextStyle(
                        fontSize: _labelFontSize,
                        color : (_page == 0) ? UniversalVariables.lightBlueColor : Colors.grey
                      ),
                    ),
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.call,
                      color : (_page == 1) ? UniversalVariables.lightBlueColor: UniversalVariables.greyColor
                    ),
                    title : Text(
                      "Calls",
                      style: TextStyle(
                        fontSize: _labelFontSize,
                        color : (_page == 1) ? UniversalVariables.lightBlueColor : Colors.grey
                      ),
                    ),
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.contact_phone,
                      color : (_page == 2) ? UniversalVariables.lightBlueColor: UniversalVariables.greyColor
                    ),
                    title : Text(
                      "Contacts",
                      style: TextStyle(
                        fontSize: _labelFontSize,
                        color : (_page == 2) ? UniversalVariables.lightBlueColor : Colors.grey
                      ),
                    ),
                  ),

                ],
                onTap : navigationTapped,
                currentIndex : _page,
              ),
            ),
          ),
        
        );
        },
    );
    
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_clone/Screen/pageviews/chat_list_screen.dart';
import 'package:test_clone/resources/firebase_repository.dart';
import 'package:test_clone/utils/universal_variables.dart';
import 'package:test_clone/widgets/ios_call_screen.dart';
import 'package:test_clone/widgets/notification_widget.dart';
import 'package:test_clone/widgets/push_kit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseRepository _repository = FirebaseRepository();
  NotificationWidget _notificationWidget = NotificationWidget();
  CallScreenWidget _callScreenWidget = CallScreenWidget();
  PushKitWidget _pushKitWidget = PushKitWidget();

  PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _repository.getCurrentUser().then((user){
      _notificationWidget.registerNotification(user.uid);
    });
    _notificationWidget.configLocalNotification();
    _pushKitWidget.regiseterPushkit();
    _callScreenWidget.callKitConfigure();
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
            currentIndex : _page
          )
        )
      )        
    );  
  }
}
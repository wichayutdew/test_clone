import 'package:flutter/material.dart';
import 'package:test_clone/Screen/callscreens/incoming_call_page.dart';
import 'package:test_clone/Screen/callscreens/video_call_page.dart';
import 'package:test_clone/Screen/callscreens/voice_call_page.dart';
import 'package:test_clone/Screen/chatscreens/chat_screen.dart';
import 'package:test_clone/Screen/home_screen.dart';
import 'package:test_clone/Screen/search_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  
  final args = settings.arguments;

  switch (settings.name){
    case '/' :
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case '/search_screen' :
      return MaterialPageRoute(builder: (context) => SearchScreen());
    case '/incoming_call' :
      return MaterialPageRoute(builder: (context) => IncomingCallPage(data :args));
    case '/voice_call' :
      return MaterialPageRoute(builder: (context) => VoiceCallPage(channelName :args));
    case '/video_call' :
      return MaterialPageRoute(builder: (context) => VideoCallPage(channelName :args));
    case '/chat_room' :
      return MaterialPageRoute(builder: (context) => ChatScreen(receiver :args));
     default :
      return MaterialPageRoute(builder: (context) => HomeScreen());
  }
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  void goBack() {
    navigatorKey.currentState.pop();
  }
  
}
import 'package:cloud_firestore/cloud_firestore.dart';

class CallData {
  String senderId;
  String receiverId;
  String channelName;
  FieldValue timestamp;
  
  CallData({this.senderId, this.receiverId, this.channelName, this.timestamp});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['channelName'] = this.channelName;
    map['timestamp'] = this.timestamp;
    return map;
  }

  CallData.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.channelName = map['channelName'];
    this.timestamp = map['timestamp'];
  }
}
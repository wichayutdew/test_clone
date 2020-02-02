import 'package:cloud_firestore/cloud_firestore.dart';

class CallData {
  String senderId;
  String receiverId;
  String channelName;
  String type;
  Timestamp timestamp;
  
  CallData({this.senderId, this.receiverId, this.channelName, this.type, this.timestamp});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['channelName'] = this.channelName;
    map['type'] = this.type;
    map['timestamp'] = this.timestamp;
    return map;
  }

  CallData.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.channelName = map['channelName'];
    this.type = map['type'];
    this.timestamp = map['timestamp'];
  }
}
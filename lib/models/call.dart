import 'package:cloud_firestore/cloud_firestore.dart';

class CallData {
  String senderId;
  String receiverId;
  String channelName;
  String type;
  String status;
  Timestamp timestamp;
  
  CallData({this.senderId, this.receiverId, this.channelName, this.type, this.status, this.timestamp});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['channelName'] = this.channelName;
    map['type'] = this.type;
    map['status'] = this.status;
    map['timestamp'] = this.timestamp;
    return map;
  }

  CallData.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.channelName = map['channelName'];
    this.type = map['type'];
    this.status = map['status'];
    this.timestamp = map['timestamp'];
  }
}

class IncomingCallData {
  String senderId;
  String callerName;
  String channelName;
  String type;
  
  IncomingCallData({this.senderId, this.channelName, this.type});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['channelName'] = this.channelName;
    map['type'] = this.type;
    return map;
  }

  IncomingCallData.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.channelName = map['channelName'];
    this.type = map['type'];
  }
}
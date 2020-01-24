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

  CallData fromMap(Map<String, dynamic> map) {
    CallData _calldata = CallData();
    _calldata.senderId = map['senderId'];
    _calldata.receiverId = map['receiverId'];
    _calldata.channelName = map['channelName'];
    _calldata.timestamp = map['timestamp'];
    return _calldata;
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_clone/models/call.dart';
import 'package:test_clone/models/message.dart';
import 'package:test_clone/models/user.dart';
import 'package:test_clone/resources/firebase_method.dart';

class FirebaseRepository{
  FirebaseMethod _firebaseMethod = FirebaseMethod();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethod.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethod.signIn();

  Future<bool> authenticateUser(FirebaseUser user) => _firebaseMethod.authenticateUser(user);

  Future<void> addDataToDb(FirebaseUser user) => _firebaseMethod.addDataToDb(user);

  Future<void> signOut() => _firebaseMethod.signOut();

  Future<List<User>> fetchAllUsers(FirebaseUser user) => _firebaseMethod.fetchAllUsers(user);

  Future<void> addMessageToDb(Message message) => _firebaseMethod.addMessageToDb(message);

  Future <void> startCall(CallData callData) => _firebaseMethod.startCall(callData);

  Future <void> answerCall(String channelName) => _firebaseMethod.answerCall(channelName);

  Future <void> endCall(String channelName) => _firebaseMethod.endCall(channelName);

  Future <void> pendingEndCall(String channelName) => _firebaseMethod.pendingEndCall(channelName);

  Future <void> rejectCall(String channelName) => _firebaseMethod.rejectCall(channelName);

  Future <void> cancelCall(String channelName) => _firebaseMethod.cancelCall(channelName);

  Future <void> finishCall(String channelName) => _firebaseMethod.finishCall(channelName);

  Future<CallData> getCallData(String channelName) => _firebaseMethod.getCallData(channelName);

  Future<User> getUser(String uid) => _firebaseMethod.getUser(uid);
}
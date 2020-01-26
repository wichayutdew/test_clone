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

  Future <void> addChannelName(CallData callData) => _firebaseMethod.addChannelName(callData);

  Future <void> deleteChannelName(String channelName) => _firebaseMethod.deleteChannelName(channelName);
}
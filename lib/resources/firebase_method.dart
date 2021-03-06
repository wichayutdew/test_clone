import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_clone/models/call.dart';
import 'package:test_clone/models/message.dart';
import 'package:test_clone/models/user.dart';
import 'package:test_clone/utils/utilities.dart';

class FirebaseMethod{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;

  //User class
  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication = await _signInAccount.authentication;
    
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken : _signInAuthentication.accessToken,
      idToken : _signInAuthentication.idToken 
    );
    
    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    return user;
  } 

  Future<bool> authenticateUser(FirebaseUser user) async{
    QuerySnapshot result = await firestore.collection("users").where("email", isEqualTo : user.email).getDocuments();

    final List<DocumentSnapshot> docs =result.documents;

    //if user registered length > 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async{

    String username = Utils.getUsername(currentUser.email);

    user = User(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoUrl,
      username: username,
      pushToken:'',
      chatWith:null,
    );
    firestore.collection("users").document(currentUser.uid).setData(user.toMap(user));
  }

  Future<void> signOut() async {
    print('Performing Sign Out');
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return  await _auth.signOut();
    
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();
    
    QuerySnapshot querySnapshot = await firestore.collection("users").getDocuments();
    for(var i = 0; i < querySnapshot.documents.length; i++){
      if(querySnapshot.documents[i].documentID != currentUser.uid){
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(Message message) async {
    var map = message.toMap();

    await firestore.collection("messages").document(message.senderId).collection(message.receiverId).add(map);

    return await firestore.collection("messages").document(message.receiverId).collection(message.senderId).add(map);
  }

  Future<void> startCall(CallData callData) async {
    var map = callData.toMap();
    return await firestore.collection("calls").document(callData.channelName).setData(map);
  }

  Future<void> answerCall(String channelName) async {
    return await firestore.collection("calls").document(channelName).updateData({'status':'incall'});
  }

  Future<void> endCall(String channelName) async {
    return await firestore.collection("calls").document(channelName).updateData({'status':'terminated'});
  }

  Future<void> pendingEndCall(String channelName) async {
    return await firestore.collection("calls").document(channelName).updateData({'status':'pendingterminated'});
  }

  Future<void> rejectCall(String channelName) async {
    return await firestore.collection("calls").document(channelName).updateData({'status':'rejected'});
  }

  Future<void> cancelCall(String channelName) async {
    return await firestore.collection("calls").document(channelName).updateData({'status':'terminated'});
  }

  Future<void> finishCall(String channelName) async {
    return await firestore.collection("calls").document(channelName).updateData({'status':'finished'});
  }

  Future<CallData> getCallData(String channelName) async {
    QuerySnapshot querySnapshot = await firestore.collection("calls").where("channelName", isEqualTo : channelName).getDocuments();
    return CallData.fromMap(querySnapshot.documents[0].data);
  }

  Future<User> getUser(uid) async {
    QuerySnapshot querySnapshot = await firestore.collection("users").where("uid", isEqualTo : uid).getDocuments();
    return User.fromMap(querySnapshot.documents[0].data);
  }
}
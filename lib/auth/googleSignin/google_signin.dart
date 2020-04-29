import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigin{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance; 

  Future<FirebaseUser> getCurrentGoogleUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication = await _signInAccount.authentication;
    
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken : _signInAuthentication.accessToken,
      idToken : _signInAuthentication.idToken 
    );
    
    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    return user;
  } 

  Future<bool> authenticateGoogleUser(FirebaseUser googleUser) async{
    QuerySnapshot result = await firestore.collection("customers").where("userinfo.email", isEqualTo : googleUser.email).getDocuments();

    final List<DocumentSnapshot> docs =result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<void> googleSignOut() async {
    print('Performing Google Sign Out');
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return  await _auth.signOut();
  }

}
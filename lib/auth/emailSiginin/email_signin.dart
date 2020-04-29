import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String> signIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    if (user.isEmailVerified) return user.uid;
    return null;
  }

  static Future<String> signUp(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    try {
      await user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }
    return user.uid;
  }

  static Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  static Future<void> signOut() async {
    return _auth.signOut();
  }

  static Future<bool> isEmailVerified() async {
    FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  static Future<void> resetPassword(String email) async {
      await _auth.sendPasswordResetEmail(email: email);
  }
}
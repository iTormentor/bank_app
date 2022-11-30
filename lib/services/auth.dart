import 'package:firebase_auth/firebase_auth.dart';

class User1 {
  final String? uid;

  User1({this.uid});
}

class AuthBase {

  User1? _userFromFirebase(User? user) {
    if (user == null){
      return null;
    }
    return User1(uid: user.uid);
  }

  dynamic registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(authResult.user);
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  dynamic loginWithEmailAndPassword(String email, String password) async {

    try {
      final authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(authResult.user);
    } on FirebaseAuthException catch (e){
        return e;
      }
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }


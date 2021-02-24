import 'package:chatchat/model/person.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_error_manager.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future signIn(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
      //  userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());

      return AuthExceptionHandler.handleException(e);
    }
  }

  Future signUp(String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
      // return userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return AuthExceptionHandler.handleException(e);
    }
  }

  Future reset(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Person userFromFirebaseUser(User user) {
    return user != null ? Person(userId: user.uid) : null;
  }
}

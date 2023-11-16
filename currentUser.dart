import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:the_haircutters/user.dart';
import 'package:the_haircutters/database.dart';

class CurrentUser extends ChangeNotifier {
  late OurUser _currentUser = OurUser();

  OurUser get getCurrentUser => _currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? onStartUp() {
    String? retVal = "error";

    try {
      User? _user = _auth.currentUser;
      if (_user != null) {
        _currentUser.uid = _user.uid;
        _currentUser.email = _user.email!;
        _currentUser.isEmailVerified = _user.emailVerified;
        retVal = "success";
      }
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  String? signOut() {
    String? retVal = "error";

    try {
      _auth.signOut();
      _currentUser = OurUser();
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String?> registerUser(
      String email, String password, String fullName) async {
    String? retVal = "error";
    OurUser _user = OurUser();
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user.uid = _userCredential.user!.uid;
      _user.email = _userCredential.user!.email;
      _user.fullName = fullName;
      _user.isEmailVerified = _userCredential.user!.emailVerified;

      // Send email verification
      await _userCredential.user!.sendEmailVerification();

      String? _returnString = await OurDatabase().createUser(_user);
      if (_returnString == "success") {
        retVal = "success";
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message!;
    }

    return retVal;
  }

  Future<String?> loginUser(String email, String password) async {
    String? retVal = "error";

    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _currentUser.uid = _userCredential.user!.uid;
      _currentUser.email = _userCredential.user!.email!;
      _currentUser.isEmailVerified = _userCredential.user!.emailVerified;
      retVal = "success";
    } on FirebaseAuthException catch (e) {
      retVal = e.message!;
    }

    return retVal;
  }
}

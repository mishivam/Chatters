import 'package:chatters/modal/user.dart';
import 'package:chatters/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatters/services/sharedPreferenceFunction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DataBaseMethods dataBaseMethods = DataBaseMethods();
  QuerySnapshot snapshot;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
    hostedDomain: '',
    clientId: '',
  );

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user).toString();
    } catch (e) {
      print(e.toString());
      if (e.toString().contains('ERROR_WRONG_PASSWORD')) {
        return 'ERROR_WRONG_PASSWORD';
      } else if (e.toString().contains('ERROR_USER_NOT_FOUND')) {
        return 'ERROR_USER_NOT_FOUND';
      } else {
        return null;
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      snapshot = await dataBaseMethods
          .getUserByUserEmail(email);
      if(snapshot== null){
        return true;
      }else{
        AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
        FirebaseUser user = result.user;
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      snapshot = await dataBaseMethods
          .getUserByUserEmail(email);
      if (snapshot != null) {
        return await _auth.sendPasswordResetEmail(email: email);
      } else {
        return true;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future googleSingIn() async {
    // Web client secret : IxuhwJDXo5lwdc7LZSFGyBig
    // Web client ID : 656306457392-jt3cns7jnh66oqb5e1vrlofsgdkh8p7o.apps.googleusercontent.com
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.idToken,
      );
    
      FirebaseUser user =
          (await _auth.signInWithCredential(authCredential)).user;
      String userName = user.displayName;

      Map<String, String> userDataInfo = {
        'name': userName.replaceAll(" ", "_").toLowerCase(),
        'email': user.email,
      };
      if (user != null) {
        await dataBaseMethods.uploadUserInfo(userDataInfo);
        await SharedPreferenceFunction.saveUserEmailInSharedPref(user.email);
        await SharedPreferenceFunction.saveUserLoggedInSharedPref(true);
        await SharedPreferenceFunction.saveUserNameInSharedPref(userName);
      }
      return userName;
    } catch (e) {
      print(e.toString());
    }
  }
}

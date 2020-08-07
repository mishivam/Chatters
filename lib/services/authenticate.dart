import 'package:chatters/view/signIn.dart';
import 'package:chatters/view/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool userSignIn = true;

  void toggleView(){
    setState(() {
      userSignIn= !userSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(userSignIn){
      return SignIn(toggleView);
    }else{
      return SignUp(toggleView);
    }
  }
}
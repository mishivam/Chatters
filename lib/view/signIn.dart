import 'package:chatters/services/database.dart';
import 'package:chatters/services/firebaseAuth.dart';
import 'package:chatters/services/sharedPreferenceFunction.dart';
import 'package:chatters/view/forgetPassword.dart';
import 'package:chatters/view/mainPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isClicked = false;
  bool isLoading = false;
  bool showPassword = true;
  String err = '';
  bool userErr = false;
  bool passErr = false;
  FireBaseAuth firebaseAuth = new FireBaseAuth();
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  TextEditingController userEmail = new TextEditingController();
  TextEditingController userPassword = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Gradient _gradient = LinearGradient(colors: [
    Color(0xffff5f6d),
    Color(0xffff5f6d),
    Color(0xffffc371),
  ]);
  QuerySnapshot snapshotUserInfo;

  signInUser() async {
    setState(() {
      isClicked = !isClicked;
    });
    if (_formkey.currentState.validate()) {
      await firebaseAuth
          .signinWithEmailAndPassword(userEmail.text, userPassword.text)
          .then((val) async {
        if (val != null) {
          print('From singn in function =>' + val);
          if (val == 'ERROR_USER_NOT_FOUND') {
            setState(() {
              userErr = true;
            });
          } else if (val == 'ERROR_WRONG_PASSWORD') {
            setState(() {
              passErr = true;
            });
          } else {
            setState(() {
              isLoading = !isLoading;
            });
            await _dataBaseMethods
                .getUserByUserEmail(userEmail.text)
                .then((val) {
              snapshotUserInfo = val;
              SharedPreferenceFunction.saveUserNameInSharedPref(
                  snapshotUserInfo.documents[0].data['name']);
              print("from signIn signInUser snapshotuserInfo :" +
                  snapshotUserInfo.documents[0].data['name']);
            });
            SharedPreferenceFunction.saveUserLoggedInSharedPref(true);
            SharedPreferenceFunction.saveUserEmailInSharedPref(userEmail.text);

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          }
        } else {
          setState(() {
            err = 'Something went wrong! please try again!';
            isLoading = !isLoading;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        colors: [Colors.purple[600], Colors.purple[900]])),
                child: SafeArea(
                    child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                ),
                                GradientText(
                                  "Chatters..",
                                  gradient: _gradient,
                                  style: TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "Sign in to continue!",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.grey.shade200),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 150,
                            ),
                            Form(
                              key: _formkey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: userEmail,
                                    style: TextStyle(color: Colors.white),
                                    validator: (val) => val.isNotEmpty
                                        ? val.contains('@') ||
                                                val.contains('.co')
                                            ? null
                                            : "Enter a Valid Email"
                                        : 'Email Cant be empty',
                                    decoration: InputDecoration(
                                      labelText: "Email ID",
                                      labelStyle: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                    child: userErr
                                        ? Text('Wrong Email Id entered!',
                                            style: TextStyle(color: Colors.red))
                                        : null,
                                  ),
                                  TextFormField(
                                    controller: userPassword,
                                    style: TextStyle(color: Colors.white),
                                    validator: (val) => val.length >= 8
                                        ? null
                                        : 'password cannot be less than 8 characters ',
                                    obscureText: showPassword,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            size: 25,
                                            color: Colors.orange,
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                    child: passErr
                                        ? Text('Wrong Password entered!',
                                            style: TextStyle(color: Colors.red))
                                        : null,
                                  ),
                                  Text(
                                    err,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  GestureDetector(
                                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword())),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "Forgot Password ?",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    child: FlatButton(
                                      onPressed: () => signInUser(),
                                      padding: EdgeInsets.all(0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          gradient: isClicked
                                              ? LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(0xffff5f6d),
                                                    Color(0xffff5f6d),
                                                    Color(0xffffc371),
                                                  ],
                                                )
                                              : LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(0xffffc371),
                                                    Color(0xffff5f6d),
                                                    Color(0xffff5f6d),
                                                  ],
                                                ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          constraints: BoxConstraints(
                                              maxWidth: double.infinity,
                                              minHeight: 50),
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    child: FlatButton(
                                      onPressed: () async {
                                        String result =
                                            await firebaseAuth.googleSingIn();
                                        if (result != null) {
                                          print(
                                              'from signIn.dart goole sing in button : SignIn successfull.');
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainPage()));
                                        }
                                      },
                                      color: Colors.red.shade50,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/gmail.png",
                                            height: 18,
                                            width: 18,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Connect with Google",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "I'm a new user.",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        widget.toggleView();
                                      },
                                      child: Text(
                                        "Sign up",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  ],
                                ))
                          ])),
                )),
              ));
  }
}

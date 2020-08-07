import 'package:chatters/services/database.dart';
import 'package:chatters/services/firebaseAuth.dart';
import 'package:chatters/services/sharedPreferenceFunction.dart';
// import 'package:chatters/view/chatRoomScreen.dart';
import 'package:chatters/view/mainScreen.dart';
import 'package:chatters/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
// import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userName = new TextEditingController();
  TextEditingController userEmail = new TextEditingController();
  TextEditingController userPassword = new TextEditingController();
  TextEditingController userConfirmPassword = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPassword = true;
  bool userErr = false;

  FireBaseAuth firebaseAuth = new FireBaseAuth();
  DataBaseMethods databaseMethods = DataBaseMethods();
  Gradient _gradient = LinearGradient(colors: [
    Color(0xffff5f6d),
    Color(0xffff5f6d),
    Color(0xffffc371),
  ]);

  final String emailErr='Email Id Already present';
  String error = '';
  bool isClicked = false;

  validateFormAndSignUp() async {
    if (formKey.currentState.validate()) {
      Map<String, String> userDataInfo = {
        'name': userName.text,
        'email': userEmail.text
      };

      setState(() => isLoading = true);
      final result = await firebaseAuth.signUpWithEmailAndPassword(
          userEmail.text, userPassword.text);
      print('validateFormAndSignUp: $result.user');
      if (result == null) {
        setState(() {
          isLoading = false;
          error = "Something wrong ..please try again!";
        });
      } else if (result == true) {
        print('email already exited');
        setState(() {
          isLoading = false;
          userErr = true;
        });
      } else {
        await databaseMethods.uploadUserInfo(userDataInfo);
        SharedPreferenceFunction.saveUserLoggedInSharedPref(true);
        SharedPreferenceFunction.saveUserNameInSharedPref(userName.text);
        SharedPreferenceFunction.saveUserEmailInSharedPref(userEmail.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // String _password = userPassword.text;
    return Scaffold(
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
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "SignUp to continue!",
                              style: TextStyle(
                                  fontSize: 35, color: Colors.grey.shade200),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 120,
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: userName,
                                validator: (val) => val.length <= 5
                                    ? "Username Must be greater than 5 characters"
                                    : null,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  labelStyle: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: userEmail,
                                style: TextStyle(color: Colors.white),
                                validator: (val) => val.isNotEmpty
                                    ? val.contains('@') || val.contains('.co')
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
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      )),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child:userErr? Text(emailErr, style: TextStyle(color:Colors.red),): null
                              ),
                              SizedBox(
                                height: 15,
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
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: FlatButton(
                            onPressed: () {
                              validateFormAndSignUp();
                              setState(() {
                                isClicked = !isClicked;
                              });
                            },
                            padding: EdgeInsets.all(0),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
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
                                    maxWidth: double.infinity, minHeight: 50),
                                child: Text(
                                  "Sign Up to Chatters",
                                  style: TextStyle(
                                      fontSize: 18,
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
                              String result = await firebaseAuth.googleSingIn();
                              if (result != null) {
                                print(
                                    'from signup.dart goole sing in button : SignIn successfull.');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainPage()));
                              }
                            },
                            color: Colors.red.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  "Sign Up with Google",
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
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already have an Account?",
                              style: textFieldStyle()
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggleView();
                                print("Sign up toggle Clicked");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  " Sign In Now",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(error),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

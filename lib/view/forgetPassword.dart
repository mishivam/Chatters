import 'package:chatters/services/authenticate.dart';
import 'package:chatters/services/firebaseAuth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:chatters/view/signIn.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

// ignore: must_be_immutable
class ForgotPassword extends StatefulWidget {
  // bool forgetPassword;
  // ForgotPassword(this.forgetPassword);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController userEmail = new TextEditingController();

  Gradient _gradient = LinearGradient(colors: [
    Color(0xffff5f6d),
    Color(0xffff5f6d),
    Color(0xffffc371),
  ]);

  final _formkey = GlobalKey<FormState>();
  FireBaseAuth _auth = FireBaseAuth();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
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
                              SizedBox(height:40),
                              GestureDetector(
                                onTap:()=>Navigator.of(context).pop(),
                                child: Container(
                                decoration:BoxDecoration(
                                   gradient: _gradient,
                                ),
                                child: Icon(Icons.arrow_back, size:35, color:Colors.purple[800]),),
                              ),
                              SizedBox(height:10),
                              GradientText(
                                "Forgot Password?",
                                gradient: _gradient,
                                style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Let's change it..",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.grey.shade200),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 200,
                          ),
                          Form(
                              key: _formkey,
                              child: Column(children: <Widget>[
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
                                    labelText:
                                        "Enter Your Registered Email Id",
                                    labelStyle: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
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
                                  height: 16,
                                ),
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  child: FlatButton(
                                    onPressed: () async {
                                      if (_formkey.currentState
                                          .validate()) {
                                        dynamic result = await _auth
                                            .resetPassword(userEmail.text);
                                        if (result == false) {
                                          showDialog(
                                            context: context,
                                            
                                            builder:
                                                (BuildContext context) {
                                              print(
                                                  "forgetpassword alertdialog");
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.white,
                                                title: Text('Warning!',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.red)),
                                                elevation: 24.0,
                                                content: RichText(
                                                    text: TextSpan(
                                                        text:
                                                            'Password Changing Email sent to ',
                                                        children: <
                                                            TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  '${userEmail.text}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      17,
                                                                  color: Colors
                                                                      .red)),
                                                        ],
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors
                                                                .black87))),
                                                actions: [
                                                  FlatButton(
                                                    child: Text("ok",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors
                                                                .red)),
                                                    onPressed: () => Navigator
                                                        .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Authenticate())),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext context) {
                                              print(
                                                  "forgetpassword alertdialog else part");
                                              return AlertDialog(
                                                backgroundColor:Colors.white,
                                                title: Text('Warning!',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.red[800])),
                                                elevation: 24.0,
                                                content: Text(
                                                    'No user found! please enter right email.',
                                                    style: TextStyle(
                                                        color: Colors.black87)),
                                                actions: [
                                                  FlatButton(
                                                      child: Text("ok",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .red)),
                                                      onPressed: () =>
                                                          Navigator.of(
                                                                  context)
                                                              .pop()),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        //  Container(
                                        //     child: Text(
                                        //         'Something went wrong! Please try again',
                                        //         style: TextStyle(
                                        //             color: Colors
                                        //                 .red)));
                                      }
                                    },
                                    // color: Colors.red.shade50,
                                    color: Colors.indigo.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Send Password Recovery Email",
                                          style: TextStyle(
                                              color: Colors.purple[700],
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]))
                        ]))))));
  }
}


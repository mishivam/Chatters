import 'package:chatters/services/authenticate.dart';
import 'package:chatters/services/sharedPreferenceFunction.dart';
// import 'package:chatters/view/chatRoomScreen.dart';
import 'package:chatters/view/mainPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isUserLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await SharedPreferenceFunction.getUserLoggedInSharedPref().then((value){
      if (value != null){
        setState(() {
        isUserLoggedIn = value;
      });
      print('From isUserLoggedIn getLoggedInState main :' + isUserLoggedIn.toString());
      }else{
        setState(() {
          isUserLoggedIn = false;
        });
        print('From isUserLoggedIn getLoggedInState main (Got null hence else part):' + isUserLoggedIn.toString());

      }

      
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner:false,
      theme: ThemeData(
        primaryColor: Color(0xFF304FFE),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xff1F1F1F)
      ),
      home: isUserLoggedIn ? MainPage() : Authenticate(),
    );
  }
}




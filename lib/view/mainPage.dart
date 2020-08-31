import 'package:chatters/services/authenticate.dart';
import 'package:chatters/services/sharedPreferenceFunction.dart';
import 'package:chatters/view/showChatRoom.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'stories.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';
import '../services/firebaseAuth.dart';
import 'searchScreen.dart';
import 'profile.dart';
import 'package:gradient_text/gradient_text.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FireBaseAuth firebaseAuth = new FireBaseAuth();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  Stream chatRoomStream;
  int _selectedIndex = 0;
  Gradient _gradient = LinearGradient(colors: [
    Color(0xffff5f6d),
    Color(0xffff5f6d),
    Color(0xffffc371),
  ]);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  logMeOut() async {
    await firebaseAuth.signOut();
    await SharedPreferenceFunction.saveUserLoggedInSharedPref(false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Authenticate()));
  }

  static List<Widget> _widgets = <Widget>[
    ShowChatRoom(),
    SearchScreen(),
    Stories(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          color:  Colors.white,
          animationDuration:Duration(milliseconds:400),
          backgroundColor: _selectedIndex !=3 ? Colors.purple[900] : null,
          items: [
            Icon(Icons.message,color:Colors.purple[900]),
            Icon(Icons.search,color:Colors.purple[900]),
            Icon(Icons.add_a_photo_sharp,color:Colors.purple[900]),
            Icon(Icons.account_circle,color:Colors.purple[900])
          ],
          index: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: _selectedIndex != 3 ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple[600], Colors.purple[900]]):null),
          child: SingleChildScrollView(
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SafeArea(
                      child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: _selectedIndex != 3 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GradientText(
                  "Chatters..",
                  gradient: _gradient,
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 2),
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.pink[50],
                  ),
                  child: GestureDetector(
                    onTap: () => logMeOut(),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.pink,
                          size: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ):null,
                      ),
                    ),
                    // Stack(
                    //   children: [
                    //     _widgets.elementAt(_selectedIndex),
                    //   ],
                    // )
                    _widgets.elementAt(_selectedIndex)
                  ]),
          ),
        ));
  }
}

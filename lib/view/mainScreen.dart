import 'package:chatters/view/stories.dart';
import 'package:flutter/material.dart';
import 'package:chatters/modal/constants.dart';
import 'package:chatters/services/authenticate.dart';
import 'package:chatters/services/database.dart';
import 'package:chatters/services/firebaseAuth.dart';
import 'package:chatters/services/sharedPreferenceFunction.dart';
import 'package:chatters/view/chatScreen.dart';
import 'package:chatters/view/search.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:gradient_text/gradient_text.dart';

import 'profile.dart';

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
  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data.documents[index].data['chatroomid']
                            .toString()
                            .replaceAll('_', '')
                            .replaceAll(Constants.myName, ''),
                        snapshot.data.documents[index].data['chatroomid']);
                  })
              : Container();
        });
  }

  getUserInfo() async {
    Constants.myName = await SharedPreferenceFunction.getUserNameInSharedPref();
    print('form getUserInfo charRoomScreen : ' + Constants.myName);
    await dataBaseMethods.getChatRoom(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  logMeOut() async {
    await firebaseAuth.signOut();
    await SharedPreferenceFunction.saveUserLoggedInSharedPref(false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Authenticate()));
  }

  Widget showChatRoom(context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
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
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
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
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          //   child: GestureDetector(
          //     onTap:()=>Navigator.push(
          //   context, MaterialPageRoute(builder: (context) => SearchScreen())),
          //     child: TextField(
          //       decoration: InputDecoration(
          //         hintText: "Search...",
          //         hintStyle: TextStyle(color: Colors.grey.shade400),
          //         prefixIcon: Icon(
          //           Icons.search,
          //           color: Colors.grey.shade400,
          //           size: 20,
          //         ),
          //         filled: true,
          //         fillColor: Colors.grey.shade100,
          //         contentPadding: EdgeInsets.all(8),
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(30),
          //             borderSide: BorderSide(color: Colors.grey.shade100)),
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: chatRoomList(),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgets = <Widget>[
    SearchScreen(),
    Stories(),
    Profile()
  ];

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

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
            child: Stack(
              children: [
                showChatRoom(context),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavigationBar(
                    selectedItemColor: Colors.purpleAccent,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    unselectedItemColor: Colors.white54,
                    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.w600),
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.message),
                        title: Text("Chats"),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        title: Text("Chats"),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_a_photo_sharp),
                        title: Text("stories"),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle),
                        title: Text("Profile"),
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                  ),
                ),
              ],
            )));
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  Widget showImage() {
    return Container(
      alignment: Alignment.center,
      height: 55,
      width: 55,
      decoration: BoxDecoration(
          color: Colors.blue[700], borderRadius: BorderRadius.circular(40)),
      child: Text('${userName.substring(0, 1).toUpperCase()}',
          style: TextStyle(color: Colors.white)),
    );
  }

  Widget showUserInfo() {
    return Container(
      alignment: Alignment.center,
      child: Text(userName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'sans-serif',
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationRoom(userName, chatRoomId))),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Row(
              children: [
                FadeIn(0.3, showImage()),
                SizedBox(
                  width: 15,
                ),
                FadeIn(0.7, showUserInfo()),
              ],
            ))
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.black12.withOpacity(0.1),
            border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: .2,
                ),
                top: BorderSide(
                  color: Colors.grey,
                  width: .2,
                ))),
      ),
    );
  }
}

enum _AnimationpProps { opacity, translateX }

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn(this.delay, this.child);
  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AnimationpProps>()
      ..add(_AnimationpProps.opacity, 0.0.tweenTo(1.0))
      ..add(_AnimationpProps.translateX, 130.0.tweenTo(0.0));

    return PlayAnimation<MultiTweenValues<_AnimationpProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
          opacity: value.get(_AnimationpProps.opacity),
          child: Transform.translate(
            offset: Offset(value.get(_AnimationpProps.translateX), 0),
            child: child,
          )),
    );
  }
}

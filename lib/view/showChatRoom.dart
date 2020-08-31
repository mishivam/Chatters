import 'package:chatters/modal/constants.dart';
// import 'package:chatters/services/authenticate.dart';
import 'package:chatters/services/database.dart';
import 'package:chatters/services/firebaseAuth.dart';
import 'package:chatters/services/sharedPreferenceFunction.dart';
import 'package:flutter/material.dart';


import 'chatRoomTile.dart';

class ShowChatRoom extends StatefulWidget {
  @override
  _ShowChatRoomState createState() => _ShowChatRoomState();
}

class _ShowChatRoomState extends State<ShowChatRoom> {
  FireBaseAuth firebaseAuth = new FireBaseAuth();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  Stream chatRoomStream;
  // int _selectedIndex = 0;


  getUserInfo() async {
    Constants.myName = await SharedPreferenceFunction.getUserNameInSharedPref();
    print('form getUserInfo charRoomScreen : ' + Constants.myName);
    await dataBaseMethods.getChatRoom(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  
  Widget chatRoomList() {
    print('chatRoomList form showChatRoom');
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          print("stream buider of charRoomList from showChatRomm");
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
              : Container(child: Text('not getting snapshot data'));
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(top: 8),
          child: chatRoomList(),
        ));
  }
}

// 

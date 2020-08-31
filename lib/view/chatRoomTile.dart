import 'package:chatters/modal/fadeInAnimation.dart';
import 'package:flutter/material.dart';
import 'package:chatters/view/chatScreen.dart';


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
    return Container(
      child: GestureDetector(
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
      ),
    );
  }
}


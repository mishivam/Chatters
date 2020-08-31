import 'package:chatters/modal/constants.dart';
import 'package:chatters/services/database.dart';
// import 'package:chatters/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chatters/modal/menuItems.dart';

class ConversationRoom extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  ConversationRoom(this.userName, this.chatRoomId);
  @override
  _ConversationRoomState createState() => _ConversationRoomState();
}

class _ConversationRoomState extends State<ConversationRoom> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController messageController = TextEditingController();
  // ScrollController _scrollController = ScrollController();
  Stream chatMsgStream;
  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(
        text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems(
        text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Container(
                        height: 4,
                        width: 50,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      itemCount: menuItems.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: menuItems[index].color.shade50,
                              ),
                              height: 50,
                              width: 50,
                              child: Icon(
                                menuItems[index].icons,
                                size: 20,
                                color: menuItems[index].color.shade400,
                              ),
                            ),
                            title: Text(menuItems[index].text),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  sendMessage() async {
    print('From sendMessage chatScreen ');
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        'sendBy': Constants.myName,
        'time': DateTime.now().microsecondsSinceEpoch,
      };
      messageController.text = '';
      await dataBaseMethods.addMessages(widget.chatRoomId, messageMap);
      // messageController.text = '';
    }
  }

  @override
  void initState() {
    dataBaseMethods.getMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMsgStream = value;
      });
    });
    super.initState();
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMsgStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    print('from chatMessageList chatScreen snapshot data : ' +
                        snapshot.data.documents[index].data['message']);
                    return MessageTile(
                      snapshot.data.documents[index].data['message'],
                      snapshot.data.documents[index].data['sendBy'] ==
                          Constants.myName,
                    );
                  },
                )
              : Container();
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.grey.shade900,
    appBar: ChatAppBar(widget.userName),
    body: Stack(children: <Widget>[
      Center(child: Icon(Icons.message, size: 100, color: Colors.grey.shade800,)),
      Container(
          margin: EdgeInsets.only(top: 8, bottom: 75),
          child: chatMessageList()),
      Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        
        alignment: Alignment.bottomCenter,
        child: Container(
            padding: EdgeInsets.only(left: 16, bottom: 10, right: 16),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.indigo.shade300,
                borderRadius: BorderRadius.circular(50)),
            child: Container(
              margin: EdgeInsets.only(top: 8),
              child: Row(
              
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        showModal();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                          // border: Border(top:BorderSide(),bottom:BorderSide(),)
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      
                      child: Container(

                        child: TextField(
                          cursorWidth: 2,
                          
                          controller: messageController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical:8, horizontal: 16),
                              hintText: "Type message...",
                              filled: true,
                              fillColor: Colors.white38,
                              hintStyle:
                                  TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)
                              )
                            ),
                        ),
                      ),
                    ),
                    SizedBox(width:16),
                    GestureDetector(
                      onTap: () => sendMessage(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.purple.shade800,
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ]),
            )),
      ),
    ]));
  }
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  ChatAppBar(this.userName);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.indigo.shade400,
      flexibleSpace: SafeArea(
          child: Container(
        padding: EdgeInsets.only(right: 16),
        child: Row(children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          SizedBox(
            width: 2,
          ),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/facebook.png"),
            maxRadius: 20,
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding:EdgeInsets.only(top:6),
                  child: Text(
                    userName,
                    style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),

                // Text("Online",style: TextStyle(color: Colors.green,fontSize: 12),),
              ],
            ),
          ),
          Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ]),
      )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}



class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  MessageTile(this.message, this.sendByMe);
  @override
  Widget build(BuildContext context) {
    print('From messagTile in chatScreen message:' + message);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width,
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
            color:sendByMe? Colors.indigo: Colors.grey.shade100,
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25))
                : BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
        child: Text(message,
            style: TextStyle(
              color: sendByMe? Colors.white: Colors.black,
              fontSize: 16,
            )),
      ),
    );
  }
}

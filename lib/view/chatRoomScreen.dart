// import 'package:chatters/modal/constants.dart';
// import 'package:chatters/services/authenticate.dart';
// import 'package:chatters/services/database.dart';
// import 'package:chatters/services/firebaseAuth.dart';
// import 'package:chatters/services/sharedPreferenceFunction.dart';
// import 'package:chatters/view/chatScreen.dart';
// // import 'package:chatters/view/search.dart';
// import 'package:simple_animations/simple_animations.dart';
// import 'package:supercharged/supercharged.dart';
// // import 'package:chatApp/widget/widgets.dart';
// import 'package:flutter/material.dart';

// class ChatRoom extends StatefulWidget {
//   @override
//   _ChatRoomState createState() => _ChatRoomState();
// }



// class _ChatRoomState extends State<ChatRoom> {
//   FireBaseAuth firebaseAuth = new FireBaseAuth();
//   DataBaseMethods dataBaseMethods = DataBaseMethods();
//   Stream chatRoomStream;
//     Widget chatRoomList() {
//     return StreamBuilder(
//         stream: chatRoomStream,
//         builder: (context, snapshot) {
//           return snapshot.hasData
//               ? ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   shrinkWrap: true,
//                   itemCount: snapshot.data.documents.length,
//                   itemBuilder: (context, index) {
//                     return ChatRoomTile(
//                         snapshot.data.documents[index].data['chatroomid']
//                             .toString()
//                             .replaceAll('_', '')
//                             .replaceAll(Constants.myName, ''),
//                         snapshot.data.documents[index].data['chatroomid']);
//                   })
//               : Container();
//         });
//   }

//     getUserInfo() async {
//     Constants.myName = await SharedPreferenceFunction.getUserNameInSharedPref();
//     print('form getUserInfo charRoomScreen : ' + Constants.myName);
//     await dataBaseMethods.getChatRoom(Constants.myName).then((value) {
//       setState(() {
//         chatRoomStream = value;
//       });
//     });
//   }

//   logMeOut() async {
//     await firebaseAuth.signOut();
//     await SharedPreferenceFunction.saveUserLoggedInSharedPref(false);
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => Authenticate()));
//   }

//   @override
//   void initState() {
//     getUserInfo();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//           body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 16,right: 16,top: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text("Chats",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
//                     Container(
//                       padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
//                       height: 30,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         color: Colors.pink[50],
//                       ),
//                       child: Row(
//                         children: <Widget>[
//                           Icon(Icons.add,color: Colors.pink,size: 20,),
//                           SizedBox(width: 2,),
//                           Text("New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 16,left: 16,right: 16),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search...",
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                   prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                   contentPadding: EdgeInsets.all(8),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide(
//                           color: Colors.grey.shade100
//                       )
//                   ),
//                 ),
//               ),
//             ),
//             chatRoomList(),
//             // ListView.builder(
//             //   itemCount: chatUsers.length,
//             //   shrinkWrap: true,
//             //   padding: EdgeInsets.only(top: 16),
//             //   physics: NeverScrollableScrollPhysics(),
//             //   itemBuilder: (context, index){
//             //     return ChatUsersList(
//             //       text: chatUsers[index].text,
//             //       secondaryText: chatUsers[index].secondaryText,
//             //       image: chatUsers[index].image,
//             //       time: chatUsers[index].time,
//             //       isMessageRead: (index == 0 || index == 3)?true:false,
//             //     );
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         body: SingleChildScrollView(
// //             physics: BouncingScrollPhysics(),
// //             child: Container(
// //               height: MediaQuery.of(context).size.height,
// //               child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: <Widget>[
// //                     SafeArea(
// //                       child: Padding(
// //                         padding: EdgeInsets.only(left: 16, right: 16, top: 10),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: <Widget>[
// //                             Text(
// //                               "Chats",
// //                               style: TextStyle(
// //                                   fontSize: 30, fontWeight: FontWeight.bold),
// //                             ),
// //                             Container(
// //                               padding: EdgeInsets.only(
// //                                   left: 8, right: 8, top: 2, bottom: 2),
// //                               height: 30,
// //                               decoration: BoxDecoration(
// //                                 borderRadius: BorderRadius.circular(30),
// //                                 color: Colors.pink[50],
// //                               ),
// //                               child: Row(
// //                                 children: <Widget>[
// //                                   Icon(
// //                                     Icons.add,
// //                                     color: Colors.pink,
// //                                     size: 20,
// //                                   ),
// //                                   SizedBox(
// //                                     width: 2,
// //                                   ),
// //                                   Text(
// //                                     "New",
// //                                     style: TextStyle(
// //                                         fontSize: 14,
// //                                         fontWeight: FontWeight.bold),
// //                                   ),
// //                                 ],
// //                               ),
// //                             )
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                     Padding(
// //                         padding: EdgeInsets.only(top: 16, left: 16, right: 16),
// //                         child: TextField(
// //                             decoration: InputDecoration(
// //                           hintText: "Search...",
// //                           hintStyle: TextStyle(color: Colors.grey.shade400),
// //                           prefixIcon: Icon(
// //                             Icons.search,
// //                             color: Colors.grey.shade400,
// //                             size: 20,
// //                           ),
// //                           filled: true,
// //                           fillColor: Colors.grey.shade100,
// //                           contentPadding: EdgeInsets.all(8),
// //                           enabledBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(30),
// //                               borderSide:
// //                                   BorderSide(color: Colors.grey.shade100)),
// //                         ))),
// //                     chatRoomList(),
// //                     FloatingActionButton(
// //                       child: Icon(Icons.search),
// //                       onPressed: () {
// //                         Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                                 builder: (context) => SearchScreen()));
// //                       },
// //                     ),
// //                   ]),
// //             )));
// //   }
// // }

// class ChatRoomTile extends StatelessWidget {
//   final String userName;
//   final String chatRoomId;
//   ChatRoomTile(this.userName, this.chatRoomId);

//   Widget showImage() {
//     return Container(
//       alignment: Alignment.center,
//       height: 55,
//       width: 55,
//       decoration: BoxDecoration(
//           color: Colors.blue[700], borderRadius: BorderRadius.circular(40)),
//       child: Text('${userName.substring(0, 1).toUpperCase()}',
//           style: TextStyle(color: Colors.white)),
//     );
//   }

//   Widget showUserInfo() {
//     return Container(
//       alignment: Alignment.center,
//       child: Text(userName,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontFamily: 'sans-serif',
//           )),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   SafeArea(
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 16, right: 16, top: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             "Chats",
//                             style: TextStyle(
//                                 fontSize: 30, fontWeight: FontWeight.bold),
//                           ),
//                           Container(
//                             padding: EdgeInsets.only(
//                                 left: 8, right: 8, top: 2, bottom: 2),
//                             height: 30,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               color: Colors.pink[50],
//                             ),
//                             child: Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.add,
//                                   color: Colors.pink,
//                                   size: 20,
//                                 ),
//                                 SizedBox(
//                                   width: 2,
//                                 ),
//                                 Text(
//                                   "New",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 16, left: 16, right: 16),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: "Search...",
//                         hintStyle: TextStyle(color: Colors.grey.shade400),
//                         prefixIcon: Icon(
//                           Icons.search,
//                           color: Colors.grey.shade400,
//                           size: 20,
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         contentPadding: EdgeInsets.all(8),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                             borderSide:
//                                 BorderSide(color: Colors.grey.shade100)),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 ConversationRoom(userName, chatRoomId))),
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       child: Row(
//                         children: <Widget>[
//                           FadeIn(0.7, showImage()),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           FadeIn(1.0, showUserInfo()),
//                         ],
//                       ),
//                       decoration: BoxDecoration(
//                           color: Colors.black26,
//                           border: Border(
//                               bottom: BorderSide(
//                                   color: Colors.blue[600], width: .4))),
//                     ),
//                   ),
//                 ])));
//   }
// }

// enum _AnimationpProps { opacity, translateX }

// class FadeIn extends StatelessWidget {
//   final double delay;
//   final Widget child;

//   FadeIn(this.delay, this.child);
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTween<_AnimationpProps>()
//       ..add(_AnimationpProps.opacity, 0.0.tweenTo(1.0))
//       ..add(_AnimationpProps.translateX, 130.0.tweenTo(0.0));

//     return PlayAnimation<MultiTweenValues<_AnimationpProps>>(
//       delay: (300 * delay).round().milliseconds,
//       duration: 500.milliseconds,
//       tween: tween,
//       child: child,
//       builder: (context, child, value) => Opacity(
//           opacity: value.get(_AnimationpProps.opacity),
//           child: Transform.translate(
//             offset: Offset(value.get(_AnimationpProps.translateX), 0),
//             child: child,
//           )),
//     );
//   }
// }

import 'package:chatters/modal/constants.dart';
import 'package:chatters/modal/fadeInAnimation.dart';
import 'package:chatters/services/database.dart';
// import 'package:chatters/view/searchScreen.dart';
// import 'package:chatters/widget/widgets.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatScreen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController inputTextEditingController = TextEditingController();
  Icon crossIcon = Icon(Icons.close, color: Colors.grey.shade100);
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  var searchSnapshot = [];
  var tempSearch = [];
  initiateSearch(searchTxt) async {
    print('initiating initiateSearch..'+ searchTxt);
    
    if(searchTxt.length == 0){
      setState(() {
          searchSnapshot = [];
          tempSearch = [];
      });
    }
    var lowerValue = searchTxt.toLowerCase();
    if(searchSnapshot.length==0 && searchTxt.length ==1 ){
          await dataBaseMethods
        .getUserByletter(lowerValue)
        .then((value) {
          for(int i=0; i<value.documents.length; ++i){
            searchSnapshot.add(value.documents[i].data);
            setState(() {
              tempSearch.add(searchSnapshot[i]);
            });
          }
          }
        );
    }else{
      tempSearch=[];
      searchSnapshot.forEach((element) {
        print("from search.dart else part inititate searh :"+element['name']);
        if(element['name'].startsWith(lowerValue)){
          setState(() {
            tempSearch.add(element);
          });
        }
      });
    }
    if (tempSearch.length == 0 && searchTxt.length > 1) {
      setState(() {});
    }
      // print(searchSnapshot);
  }

  Widget searchGrid(){
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.only(left:10, right:10.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      primary: false,
      shrinkWrap: true,
      children: tempSearch.map((element){
        return FadeIn(0.1,buildResultCard(element));
      }).toList(),
    );
  }

  Widget buildResultCard(data){
    return GestureDetector(
      onTap:()=>createChatRoomAndStartConversation(data['name']),
          child: Card(
        
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2.0,
        color: Colors.purple,
        child:Column(
          children:[
            Text(data['name'],style: TextStyle(color:Colors.grey.shade100, fontSize: 20)),
            SizedBox(height: 25,),
            Text(data['email'],style: TextStyle(color:Colors.grey.shade100, fontSize: 20))
          ]
        )
      ),
    );
  }



  createChatRoomAndStartConversation(String userName) async {
    print('form createChatRommAndStartConv search userName :' +
        userName +
        "Constant.myName:" +
        Constants.myName);
    if (userName != Constants.myName) {
      List<String> user = [userName, Constants.myName];
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      Map<String, dynamic> chatRoomMap = {
        'user': user,
        'chatroomid': chatRoomId
      };
      await dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      print('-----------may be uploading is caousing to rerender the widget--------------------');
      await dataBaseMethods.uploadSearchHistory(Constants.myName, userName);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationRoom(userName, chatRoomId)));
      
    } else {
      print('you can\'t search your own name!');
    }
  }

  getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return "$a\_$b";
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
              child: SafeArea(
          child: Column(
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.purple[600], Colors.purple[900]]),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                // offset: Offset(0.0, 1.0),
                blurRadius: 3,
                spreadRadius: 0.0 //(x,y)
                )
          ],
                  ),
                  child: Row(
          children: [
            IconButton(
              iconSize: 30,
              icon: crossIcon,
              onPressed: (){
                Navigator.of(context).pop();
              } ,
            ),
            Expanded(
              child: TextField(
                textAlign: TextAlign.start,
                controller: inputTextEditingController,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade100,
                    fontWeight: FontWeight.bold),
                cursorColor: Colors.grey.shade100,
                cursorWidth: 3,
                decoration: InputDecoration(
                    hintText: "Start typing..",
                    hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold),
                    contentPadding: EdgeInsets.only(
                        top: 8, left: 10, right: 16, bottom: 8),
                    border: InputBorder.none),
                onChanged: (val){
                  initiateSearch(val);
                },
              ),
            ),
          ],
                  ),
                ),
                searchGrid(),
              ],
            ),
        ),
      ),
    );
  }
}

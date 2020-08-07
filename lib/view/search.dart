import 'package:chatters/modal/constants.dart';
// import 'package:chatters/services/sharedPreferenceFunction.dart';
import 'package:chatters/view/chatScreen.dart';
import 'package:chatters/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chatters/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchUser = TextEditingController();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  QuerySnapshot searchSnapshot;
  

  initiateSearch() async{
    print('initiating initiateSearch..');
    await dataBaseMethods
      .getUserByUserName(searchUser.text)
      .then((val)=> setState((){
        searchSnapshot = val;
        
      }));
  }
  Widget searchList(){
    // print('length of searchSnapshot from searchList function : ${searchSnapshot.documents.length}');
    return searchSnapshot != null ? ListView.builder(
      itemCount:searchSnapshot.documents.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        print('From searchList search searchSnapshot.name:'+searchSnapshot.documents[index].data['name']);
        return searchTile(
          userName:searchSnapshot.documents[index].data['name'],
          userEmail:searchSnapshot.documents[index].data['email'] ,
          
        );
      }
    ): Container(child:Text('No User Found! Please Search with correct username.', style:TextStyle(color:Colors.red, fontSize: 15))) ;
  }
  

  createChatRoomAndStartConversation(String userName)async{
    print('form createChatRommAndStartConv search userName :'+userName + "Constant.myName:"+ Constants.myName);
    if (userName!=Constants.myName){

      
      List<String> user = [userName,Constants.myName];
      String chatRoomId=getChatRoomId(userName, Constants.myName);
      Map<String, dynamic> chatRoomMap = {
        'user':user,
        'chatroomid':chatRoomId
      };
      await dataBaseMethods.createChatRoom(chatRoomId,chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationRoom(userName, chatRoomId)));
    }else{
      print('you can\'t search your own name!');
    }
  }

  Widget searchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:25, vertical:10),
      child:Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[           
              Text(userName, style:textFieldStyle()),
              Text(userEmail, style:textFieldStyle())
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap:()=>createChatRoomAndStartConversation(userName),
            child: Container(
              padding:EdgeInsets.symmetric(horizontal:20, vertical:10),
              child:Icon(Icons.message, color:Colors.blue[700], size:30)
            ),
          )
        ],
      )
    );
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: appBar(context, 'search'),
      body:SingleChildScrollView(
              child: Container(
          child:Column(
            
            children:[
              Container(
                padding:EdgeInsets.symmetric(horizontal:24, vertical:16),
                child: Row(
                  children: <Widget>[
                    Expanded(

                      child:TextField(
                        controller:searchUser,
                        style:TextStyle(color: Colors.white),
                        decoration:InputDecoration(
                          hintText:"search user..",
                          hintStyle: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 18),
                          focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF304FFE))),
                          enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                        )
                      )
                    ),
                    
                    FloatingActionButton(
                      onPressed:()async => searchUser.text!='' ? await initiateSearch() : null,
                      backgroundColor:Color(0xFF304FFE),
                      // shape:Border.all(color:Color(0xFF304FFE),style: ),
                      child:Icon(Icons.search, color:Colors.black)
                    )
                  ],
                ),
              ),
              searchList(),           
            ],
          )
        ),
      )
    );
  }
}

getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return '$b\_$a';
    }else{
      return "$a\_$b";
    }
  }
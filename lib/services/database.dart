import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods{

  final CollectionReference user = Firestore.instance.collection('userInfo');
  final CollectionReference chatRoom = Firestore.instance.collection('chatRoom');

  getUserByUserName(String username)async{
    return await user.where('name', isEqualTo: username).getDocuments();
    
  }
  getUserByUserEmail(String email)async{
    return await user.where('email', isEqualTo: email).getDocuments();
    
  }

  uploadUserInfo(userDataMap)async{
    await user.add(userDataMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap)async{
    await chatRoom.document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addMessages(String chatRoomId, messageMap)async{
    await chatRoom.document(chatRoomId).collection('chats').add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  Future getMessages(String chatRoomId)async{
    return chatRoom.document(chatRoomId).collection('chats').orderBy('time',descending:true).snapshots();
  }
  
  Future getChatRoom(String userName)async{
    return chatRoom.where('user', arrayContains: userName).snapshots();
  }
}
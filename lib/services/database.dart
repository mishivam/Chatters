import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods{

  //Creating database instances..
  final CollectionReference user = Firestore.instance.collection('userInfo');
  final CollectionReference chatRoom = Firestore.instance.collection('chatRoom');
  final CollectionReference searchHistory = Firestore.instance.collection('SearchHistory');


// USER RELETED FUNCTIONS..

  //get user by userName..
  getUserByUserName(String username)async{
    return await user.where('name', isEqualTo: username).getDocuments();   
  }

  //get user by letter ..
  getUserByletter(String searchKey)async{
    return await user.where('searchKey', isEqualTo: searchKey.substring(0,1)).getDocuments();    
  }

  //Get user by email from database..
  getUserByUserEmail(String email)async{
    return await user.where('email', isEqualTo: email).getDocuments();
    
  }

  //Uploading UserInfo to the dataBase..
  Future uploadUserInfo(userDataMap)async{
    await user.add(userDataMap);
  }

//SEARCH RELETED QUERIES..

  //uploading searched history to database..
  Future uploadSearchHistory(String userName, String searchName)async{
     await searchHistory.document(userName).collection('searchHistory').document(userName+searchName).setData({
       'documentId':userName+searchName,
       'currentUserName': userName,
       'searchName':searchName,
       'timestamp':DateTime.now().millisecondsSinceEpoch
     }); 
  }

  //Getting searched history from database..
  Future getSearchHistory(String currentUserName)async{
    return searchHistory.document(currentUserName).collection('searchHistory').orderBy('timestamp',descending: true).snapshots();
  }

  //Deleting searched history from database..
  Future deleteUserFromDatabase(String currentUserName,String deleteUserName)async{
    await searchHistory.document(currentUserName).collection('searchHistory').document(currentUserName+deleteUserName).delete();
    print('old history got deleted..');
  }

//CHATROOM RELETED QUERIES..

  //Creating chat room..
  createChatRoom(String chatRoomId, chatRoomMap)async{
    await chatRoom.document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  //Geting chat room...
  Future getChatRoom(String userName)async{
    return chatRoom.where('user', arrayContains: userName).snapshots();
  }

//MSG RELETED QUERIES..
  //Adding msges to database..
  addMessages(String chatRoomId, messageMap)async{
    await chatRoom.document(chatRoomId).collection('chats').add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  //Getting all the messege..
  Future getMessages(String chatRoomId)async{
    return chatRoom.document(chatRoomId).collection('chats').orderBy('time',descending:true).snapshots();
  }
  
  


  
}
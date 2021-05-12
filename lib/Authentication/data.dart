import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase{

  getuser_username(String userName) async{

    return  await Firestore.instance.collection("user")
        .where("userName", isEqualTo: userName)
        .getDocuments();
  }

  getuser_email(String userEmail) async{

    return  await Firestore.instance.collection("user")
        .where("email", isEqualTo: userEmail)
        .getDocuments().catchError((e){
      print(e.toString);
    });
  }

  uploaduser_info(userMap)
  {
    Firestore.instance.collection("user")
        .add(userMap);
  }

  createChatRoom(String ChatRoomId , ChatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(ChatRoomId).setData(ChatRoomMap);
  }
  
  addMsg(String ChatRoomId, msgMap)
  {
     Firestore.instance.collection("ChatRoom")
         .document(ChatRoomId)
         .collection("Chat")
         .add(msgMap);
  }
  getMsg(String ChatRoomId)
  async{
    return await Firestore.instance.collection("ChatRoom")
        .document(ChatRoomId)
        .collection("Chat")
        .orderBy("time",descending: false)
        .snapshots();
  }
  
  getChatRoom(String userName) async
  {
    return await Firestore.instance.collection("ChatRoom")
        .where("user", arrayContains: userName)
        .snapshots();
  }


}
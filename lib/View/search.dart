import 'package:chatapp/Authentication/data.dart';
import 'package:chatapp/Helper/Const.dart';
import 'package:chatapp/View/chat_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchSrn extends StatefulWidget {
  @override
  _SearchSrnState createState() => _SearchSrnState();
}

class _SearchSrnState extends State<SearchSrn> {

  TextEditingController searchtextEditingController =
      new TextEditingController();
  DataBase dataBase = new DataBase();

  QuerySnapshot querySnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initSrch() async{
    if(searchtextEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await dataBase.getuser_username(searchtextEditingController.text)
          .then((snapshot){
        querySnapshot = snapshot;
        print("$querySnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
          searchtextEditingController.text = "";
        });
      });
    }
  }

  Widget srchList() {
    return querySnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: querySnapshot.documents.length,
            itemBuilder: (context, index) {
              return srchTile(
                userName: querySnapshot.documents[index].data["userName"],
                userEmail: querySnapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  ChatroomAndConversation(String userName) {
    //if (userName != Constants.myName) {

      List<String> user = [Constants.myName, userName];

      String ChatRoomId;

      Map<String, dynamic> ChatRoomMap = {
        "user": user,
        "ChatRoom": ChatRoomId = getChatRoomId(Constants.myName, userName),
      };
      DataBase().createChatRoom(ChatRoomId, ChatRoomMap);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Inbox(
        ChatRoomId
      )));
    //}
  }

  Widget srchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              ChatroomAndConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF554AF2),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Message',
                style: TextStyle(
                  color: Color(0xFFD6CBE8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.compareTo(b)>0) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6CBE8),
      appBar: AppBar(
        backgroundColor: Color(0xFF554AF2),
        title: Image.asset(
          "images/text.png",
          height: 40,
        ),
        centerTitle: false,
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchtextEditingController,
                      decoration: InputDecoration(
                          labelText: 'Search...',
                          labelStyle: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFF554AF2),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initSrch();
                    },
                    child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Image.asset("images/search.png")),
                  ),
                ],
              ),
            ),
            srchList(),
          ],
        ),
      ),
    );
  }
}


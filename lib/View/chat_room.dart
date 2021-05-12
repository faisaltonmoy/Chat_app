import 'package:chatapp/Authentication/auth_sign.dart';
import 'package:chatapp/Authentication/data.dart';
import 'package:chatapp/Helper/auto_login.dart';
import 'package:chatapp/Helper/help_func.dart';
import 'package:chatapp/View/chat_box.dart';
import 'package:chatapp/View/search.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/Helper/Const.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                userName: snapshot.data.documents[index].data['ChatRoom']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.documents[index].data["ChatRoom"],
              );
            })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await Help_func.getUserNameSharedPreference();
    DataBase().getChatRoom(Constants.myName).then((val) {
      setState(() {
        chatRooms = val;
        });
    });
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
        actions: [
          GestureDetector(
            onTap: () {
              AuthSignIn().signOut();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AutoLoggedIn()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomsList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff6F30CF),
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchSrn()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Inbox(
              chatRoomId,
            )
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFD0C5EC),
                const Color(0xFFD6CBE8)
              ],
            ),
           // border: Border.all(color: const Color(0xff6F30CF)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          const Color(0xff6F30CF),
                          const Color(0xff554AF2)
                        ],
                    ),
                    borderRadius: BorderRadius.circular(30)),
                child: Text(userName.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        //fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300)),
              ),
              SizedBox(
                width: 12,
              ),
              Text(userName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Color(0xff6F30CF),
                      fontSize: 16,
                      //fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w400))
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:chatapp/Authentication/data.dart';
import 'package:chatapp/Helper/Const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Inbox extends StatefulWidget {
  final String ChatRoomId;
  Inbox(this.ChatRoomId);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  Stream<QuerySnapshot> chats;
  TextEditingController msgEditingController = new TextEditingController();

  final _controller = ScrollController();

  Widget chatMsg() {
    Timer(
      Duration(milliseconds: 600),
          () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );
    //_controller.animateTo(
      //_controller.position.maxScrollExtent,
      //duration: Duration(seconds: 1),
      //curve: Curves.fastOutSlowIn,
    //);
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: _controller,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MsgTile(
                    message: snapshot.data.documents[index].data["message"],
                    sendByMe: Constants.myName ==
                        snapshot.data.documents[index].data["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  sendMsg() {
    if (msgEditingController.text.isNotEmpty) {
      Map<String, dynamic> msgMap = {
        "sendBy": Constants.myName,
        "message": msgEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DataBase().addMsg(widget.ChatRoomId, msgMap);

      setState(() {
        msgEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DataBase().getMsg(widget.ChatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6CBE8),
      appBar: AppBar(
        backgroundColor: Color(0xFF554AF2),
        title: Text("Conversation"
          ,style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          ),),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 87.0),
              child: chatMsg(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  gradient: LinearGradient(
                    colors: [
                    const Color(0x50FFFFFF),
                  const Color(0xFFE2E2E2)
                  ],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight
              ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: msgEditingController,
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Color(0xff6F30CF),
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        sendMsg();
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("images/s.png",
                            height: 25, width: 25,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class MsgTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MsgTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 10, bottom: 10, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff554AF2), const Color(0xff6F30CF)]
                  : [const Color(0xff6F30CF), const Color(0xffF24AA4)],
            )),
        child: Text(message.trim(),
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Color(0xFFD6CBE8),
                fontSize: 15,
                //fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}

import 'package:chatapp/View/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/Helper/auto_login.dart';

import 'Helper/help_func.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await Help_func.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      debugShowCheckedModeBanner: false,
      home: userIsLoggedIn != null
          ? userIsLoggedIn ? ChatRoom() : AutoLoggedIn()
          : Container(
              child: Center(
                child: AutoLoggedIn(),
              ),
            ),
    );
  }
}

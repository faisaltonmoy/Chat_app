import 'package:chatapp/View/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/View/sign_up.dart';

class AutoLoggedIn extends StatefulWidget {
  @override
  _AutoLoggedInState createState() => _AutoLoggedInState();
}

class _AutoLoggedInState extends State<AutoLoggedIn> {
  bool SignInShowing = true;

  void ToggleView()
  {
    setState(() {
      SignInShowing = !SignInShowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (SignInShowing) {
      return SignIn(ToggleView);
    } else {
      return SignUp(ToggleView);
    }
  }
}

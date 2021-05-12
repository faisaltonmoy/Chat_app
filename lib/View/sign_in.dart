import 'package:chatapp/Authentication/auth_sign.dart';
import 'package:chatapp/Authentication/data.dart';
import 'package:chatapp/Helper/help_func.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_room.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  AuthSignIn authSignIn = new AuthSignIn();
  DataBase dataBase = new DataBase();

  QuerySnapshot querySnapshot ;

  final newkey = GlobalKey<FormState>();

  bool loading = false;

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  SignedIn() async{
    if (newkey.currentState.validate()) {


      await authSignIn
          .signInWithEmailAndPassword(
          emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
          await DataBase().getuser_email(emailEditingController.text);

          Help_func.saveUserLoggedInSharedPreference(true);
          Help_func.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          Help_func.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);

          setState(() {
            loading = true;
          });

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            loading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6CBE8),
      body: loading
      ? Container(
      child: Center(child: CircularProgressIndicator()),
      )
          : Form(
      key: newkey,
      child: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*.42,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/f_logo.png"),
              fit: BoxFit.fitWidth,
            )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(115.0, 0.0, 80.0, 10.0),
            child: Text(
              'Flutter Chats',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: (Icon(Icons.email, color: Colors.black54)),
                  ),
                  Container(
                    width: 300,
                    padding: const EdgeInsets.only(right: 25.0),
                    child: TextFormField(
                      controller: emailEditingController,
                      validator: (val) {
                        return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)
                            ? null
                            : "Enter a correct email";
                      },
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: (Icon(Icons.vpn_key, color: Colors.black54)),
                  ),
                  Container(
                    width: 300,
                    padding: const EdgeInsets.only(right: 25.0),
                    child: TextFormField(
                      controller: passwordEditingController,
                      validator: (val) {
                        return val.length < 7
                            ? "At least 8 characters"
                            : null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(150.0, 0.0, 10.0, 0.0),
            child: FlatButton(
              onPressed: () {},
              textColor: Colors.deepPurpleAccent,
              child: Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 5.0),
            child: Container(
            width: 300,
            height: 50,
            child: RaisedButton(
              onPressed: () {
                SignedIn();
              },
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    ),

          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                child: Container(
                  width: 300,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      authSignIn.GSignIn(context);

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => ChatRoom()));
                    },
                    color: Colors.white,
                    textColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child: Text(
                      'Sign In with GOOGLE',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(80.0, 0.0, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Text(
                  'Do not have account?',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    widget.toggle();
                    //Navigator.of(context)
                      //  .push(MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  textColor: Colors.deepPurpleAccent,
                  child: Text(
                    'Register Now',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

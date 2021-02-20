import 'package:chatchat/pages/search.dart';
import 'package:chatchat/service/auth.dart';
import 'package:chatchat/service/authenticate.dart';
import 'package:chatchat/service/local_storage.dart';
import 'package:chatchat/service/userData.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final AuthMethods _authMethods = new AuthMethods();
  @override
  void initState() {
    setUserInfo();
    super.initState();
  }

  setUserInfo() async {
    UserData.username = await LocalStorage.getUserName();
    UserData.email = await LocalStorage.getUserMail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat room"),
        actions: [
          InkWell(
            onTap: () async {
              _authMethods.signOut();
              await LocalStorage.setUserLoggedIn(false);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Icon(Icons.exit_to_app),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage()));
          }),
    );
  }
}

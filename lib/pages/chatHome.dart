import 'package:chatchat/pages/search.dart';
import 'package:chatchat/service/auth.dart';
import 'package:chatchat/service/authenticate.dart';
import 'package:chatchat/service/database.dart';
import 'package:chatchat/service/local_storage.dart';
import 'package:chatchat/service/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final AuthMethods _authMethods = new AuthMethods();

  DataBaseMethod _database = DataBaseMethod();
  Stream chats;
  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    await setUserInfo();
    await getAllChats();
  }

  getAllChats() async {
    chats = await _database.getAllChats();
    setState(() {});
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
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()))
                .then((value) => onInit());
          }),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://www.wallpapertip.com/wmimgs/44-443855_romantic-love-couple-in-rain-iphone-wallpaper-resolution.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: chats,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data.docs[index];
                        return chatView(
                            document.id
                                .replaceAll(UserData.username, "")
                                .replaceAll("_", ""),
                            document.id);
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      ),
    );
  }

  chatView(String name, String id) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatPage(chatRoomId: id, name: name)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://i.pinimg.com/originals/2f/9d/95/2f9d9562eb2252ae132b4bf8258aa18a.jpg"),
                ),
                trailing: Icon(Icons.message),
                tileColor: Colors.white,
                title: Container(
                  child: Text(
                    name.toUpperCase(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

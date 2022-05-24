// ignore_for_file: library_private_types_in_public_api

import 'package:chatchat/pages/search.dart';
import 'package:chatchat/service/auth.dart';
import 'package:chatchat/service/authenticate.dart';
import 'package:chatchat/service/database.dart';
import 'package:chatchat/service/local_storage.dart';
import 'package:chatchat/service/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final AuthMethods _authMethods = AuthMethods();

  final DataBaseMethod _database = DataBaseMethod();
  Stream<QuerySnapshot>? chats;
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
    // setState(() {});
  }

  setUserInfo() async {
    UserData.username = await LocalStorage.getUserName();
    UserData.email = LocalStorage.getUserMail().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("chat room"),
        actions: [
          InkWell(
            onTap: () async {
              _authMethods.signOut();
              await LocalStorage.setUserLoggedIn(false);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()))
                .then((value) => onInit());
          }),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1592743263126-bb241ee76ac7?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=60&raw_url=true&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bmF0dXJhbCUyMGJhY2tncm91bmR8ZW58MHx8MHx8&auto=format&fit=crop&w=500",
            fit: BoxFit.cover,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: chats,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      return chatView(
                          document.id
                              .replaceAll(UserData.username ?? "", "")
                              .replaceAll("_", ""),
                          document.id);
                    },
                  );
                } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Start new Chat"));
                }
                return const Center(child: CircularProgressIndicator());
              }),
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
              color: Colors.white,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://i.pinimg.com/originals/2f/9d/95/2f9d9562eb2252ae132b4bf8258aa18a.jpg"),
                ),
                trailing: const Icon(Icons.message),
                title: Text(
                  name.toUpperCase(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      );
}

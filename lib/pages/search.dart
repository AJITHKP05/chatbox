import 'package:chatchat/pages/chat_page.dart';
import 'package:chatchat/service/database.dart';
import 'package:chatchat/service/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  QuerySnapshot? datas;
  final _databaseMethods = DataBaseMethod();
  @override
  void initState() {
    super.initState();
    _databaseMethods.getAllUsers().then((value) {
      datas = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchCont = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.grey[800],
              title: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: searchCont,
                decoration: const InputDecoration(
                  labelText: "Search username",
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  _databaseMethods
                      .getUserbyUserName(searchCont.text)
                      .then((value) => datas = value);
                  setState(() {});
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            datas != null
                ? ListView.builder(
                    itemCount: datas?.docs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) => SearchTile(
                      email: datas!.docs[i].get ("email"),
                      name: datas!.docs[i].get ("name"),
                      // name: datas.docs[i].get("email"),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchTile extends StatelessWidget {
   String? chatRoomId;
  final String name;
  final String email;

  SearchTile({ Key? key, required this.name, required this.email,  this.chatRoomId}) : super(key: key);
  final _databaseMethods = DataBaseMethod();
  @override
  Widget build(BuildContext context) {
    return name != UserData.username
        ? ListTile(
            title: Text(name),
            subtitle: Text(email),
            trailing: RaisedButton(
              onPressed: () {
                createChatRoom(name);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(chatRoomId: chatRoomId??"", name: name)));
              },
              child: const Text("Messge"),
            ),
          )
        : Container();
  }

  createChatRoom(String username) {
    List<String?> users = [username, UserData.username];
    chatRoomId = getChatRoomId(username, UserData.username??"");
    Map<String, dynamic> chatroomMap = {
      "users": users,
      "chatRoomId": chatRoomId
    };
    _databaseMethods.createChatRoom(chatRoomId??"", chatroomMap);
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else
      return "$a\_$b";
  }
}

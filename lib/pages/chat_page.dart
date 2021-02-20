import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;

  const ChatPage({Key key, this.chatRoomId}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              tileColor: Colors.grey[800],
              title: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: textCont,
                decoration: InputDecoration(
                  labelText: "Message",
                  labelStyle: TextStyle(color: Colors.blue),
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  textCont.clear();
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

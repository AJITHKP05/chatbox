import 'package:chatchat/service/database.dart';
import 'package:chatchat/service/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String name;

  const ChatPage({Key? key, required this.chatRoomId, required this.name}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textCont = TextEditingController();
  final DataBaseMethod _database = DataBaseMethod();
  Stream<QuerySnapshot>? messageStream;

  getMessages() async {
    messageStream = await _database.getAllMessages(widget.chatRoomId);
    setState(() {});
  }

  sendMessage() async {
    if (textCont.text.isNotEmpty) {
      Map<String, String> map = {
        "message": textCont.text,
        "sendBy": await LocalStorage.getUserName().toString(),
        "ts": DateTime.now().toString(),
        "read": "true"
      };
      _database.sendMessage(widget.chatRoomId, map);
    }
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1600360695828-ee110ac2950e?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=60&raw_url=true&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bmF0dXJhbCUyMGJhY2tncm91bmR8ZW58MHx8MHx8&auto=format&fit=crop&w=500",
              fit: BoxFit.cover,
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: messageStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return  ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data?.docs.length??0 + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          );
                        }
                        DocumentSnapshot document =
                            snapshot.data!.docs[index - 1];

                        return messageTile(
                            document.get('message'), document.get('sendBy'));
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: bottomMessageBar(),
            )
          ],
        ));
  }

  messageTile(String message, String sendBy) {
    return Container(
      padding: EdgeInsets.all(5),
      // width: MediaQuery.of(context).size.width * .6,

      alignment:
          widget.name == sendBy ? Alignment.centerLeft : Alignment.centerRight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          // width: MediaQuery.of(context).size.width * .8,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          color: widget.name == sendBy ? Colors.white : Colors.blue,
          child: Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  bottomMessageBar() => Stack(
        children: [
          Container(
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
                  sendMessage();
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
      );
}

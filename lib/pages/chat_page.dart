import 'package:chatchat/service/database.dart';
import 'package:chatchat/service/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String name;

  const ChatPage({Key key, this.chatRoomId, this.name}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textCont = TextEditingController();
  DataBaseMethod _database = DataBaseMethod();
  Stream messageStream;

  getMessages() async {
    messageStream = await _database.getAllMessages(widget.chatRoomId);
    setState(() {});
  }

  sendMessage() async {
    if (textCont.text.isNotEmpty) {
      Map<String, String> map = {
        "message": textCont.text,
        "sendBy": await LocalStorage.getUserName(),
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
              "https://www.wallpapers13.com/wp-content/uploads/2016/04/Sunset-Boy-and-Girl-Silhouette-romantic-couple-love-Wallpaper-Hd-for-mobile-phones-915x515.jpg",
              fit: BoxFit.cover,
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: messageStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData)
                    return new ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.docs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          );
                        }
                        DocumentSnapshot document =
                            snapshot.data.docs[index - 1];

                        return messageTile(
                            document.get('message'), document.get('sendBy'));
                      },
                    );
                  return Center(
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

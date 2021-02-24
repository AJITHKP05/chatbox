import 'package:cloud_firestore/cloud_firestore.dart';

import 'userData.dart';

class DataBaseMethod {
  Future getUserbyUserName(String name) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: name)
        .get();
  }

  Future getUserbyUserEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .get();
  }

  Future getAllUsers() async {
    return await FirebaseFirestore.instance.collection("Users").get();
  }

  uploadUser(userMap) {
    FirebaseFirestore.instance.collection("Users").add(userMap).catchError((e) {
      print(e);
    });
  }

  void createChatRoom(String chatRoomId, users) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(users)
        .catchError((e) {
      print(e);
    });
  }

  Future<Stream<QuerySnapshot>> getAllMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllChats() async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: UserData.username)
        .snapshots();
  }

  void sendMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }
}

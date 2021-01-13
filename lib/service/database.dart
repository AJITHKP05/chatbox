import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethod {
  Future getUserbyUserName(String name) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: name)
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
}

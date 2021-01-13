import 'package:chatchat/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  QuerySnapshot datas;
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
                style: TextStyle(color: Colors.white),
                controller: searchCont,
                decoration: InputDecoration(
                  labelText: "Search username",
                  labelStyle: TextStyle(color: Colors.blue),
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  _databaseMethods
                      .getUserbyUserName(searchCont.text)
                      .then((value) => datas = value);
                  setState(() {});
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            datas != null
                ? ListView.builder(
                    itemCount: datas.docs.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) => SearchTile(
                      email: datas.docs[i].data()["email"],
                      name: datas.docs[i].data()["name"],
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

class SearchTile extends StatelessWidget {
  final String name;
  final String email;

  const SearchTile({Key key, this.name, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(email),
      trailing: RaisedButton(
        onPressed: () {},
        child: Text("Messge"),
      ),
    );
  }
}

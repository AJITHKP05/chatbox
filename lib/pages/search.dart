import 'package:chatchat/widgets/textInputField.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
                controller: searchCont,
                decoration: InputDecoration(
                    hintText: "Search username",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
              trailing: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            SearchTile(
              name: "name",
              email: "email",
            )
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

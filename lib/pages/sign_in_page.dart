import 'package:chatchat/widgets/textInputField.dart';
import 'package:flutter/material.dart';
import '../widgets/size_cofig.dart';

class SignInPage extends StatefulWidget {
  final Function toggle;

  const SignInPage({Key key, this.toggle}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final unameCont = TextEditingController();
  final passCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignIn"),
      ),
      body: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 4, left: 10, right: 10),
        child: Column(
          children: [
            CommonTextField(
              controller: unameCont,
              hint: "Username",
            ),
            context.columnSpacer,
            CommonTextField(
              controller: passCont,
              hint: "Password",
            ),
            context.columnSpacer,
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(onTap: () {}, child: Text("forget password")),
            ),
            context.columnSpacer,
            RaisedButton(
              onPressed: () {},
              child: Text("SignIn"),
            ),
            context.columnSpacer,
            InkWell(
                onTap: () {
                  widget.toggle();
                },
                child: Text(
                  'Register Now',
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ))
          ],
        ),
      ),
    );
  }
}

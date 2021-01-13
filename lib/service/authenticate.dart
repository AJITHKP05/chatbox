import 'package:chatchat/pages/sign_in_page.dart';
import 'package:chatchat/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignIn = true;
  void toggle() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isSignIn
        ? SignInPage(
            toggle: toggle,
          )
        : SignUpPage(toggle: toggle);
  }
}

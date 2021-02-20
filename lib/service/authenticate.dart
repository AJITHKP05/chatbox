import 'package:chatchat/pages/chatHome.dart';
import 'package:chatchat/pages/sign_in_page.dart';
import 'package:chatchat/pages/sign_up_page.dart';
import 'package:chatchat/service/local_storage.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignIn = true;
  bool alreadyIn = false;
  void toggle() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkForLogedIn();

    return alreadyIn
        ? ChatHome()
        : isSignIn
            ? SignInPage(
                toggle: toggle,
              )
            : SignUpPage(toggle: toggle);
  }

  void checkForLogedIn() async {
    alreadyIn = await LocalStorage.getUserLoggedIn();
    setState(() {});
  }
}

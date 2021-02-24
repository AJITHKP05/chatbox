import 'package:chatchat/service/auth.dart';
import 'package:chatchat/service/database.dart';
import 'package:chatchat/service/firebase_error_manager.dart';
import 'package:chatchat/service/local_storage.dart';
import 'package:chatchat/widgets/textInputField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/size_cofig.dart';
import 'chatHome.dart';

import '../utils/view_utils.dart';

class SignUpPage extends StatefulWidget {
  final Function toggle;

  const SignUpPage({Key key, this.toggle}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final unameCont = TextEditingController();
  final passCont = TextEditingController();
  final emailCont = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final AuthMethods _authMethods = new AuthMethods();
  final DataBaseMethod _dataBaseMethod = new DataBaseMethod();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 4, left: 10, right: 10),
        child: Form(
          // autovalidateMode: AutovalidateMode.always,
          key: formkey,
          child: Column(
            children: [
              CommonTextField(
                controller: unameCont,
                hint: "Username",
                validate: (String value) {
                  return (value.isEmpty || value.length < 5)
                      ? "Username mustbe 5 digit "
                      : null;
                },
              ),
              context.columnSpacer,
              CommonTextField(
                controller: emailCont,
                hint: "Email",
                validate: (String value) {
                  return (value.isEmpty ||
                          !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(value))
                      ? "Enter valid email "
                      : null;
                },
              ),
              context.columnSpacer,
              CommonTextField(
                controller: passCont,
                hint: "Password",
                validate: (String value) {
                  return (value.isEmpty || value.length < 5)
                      ? "Password mustbe 8 digit "
                      : null;
                },
              ),
              context.columnSpacer,
              context.columnSpacer,
              RaisedButton(
                onPressed: () async {
                  if (formkey.currentState.validate()) {
                    Map<String, String> userMap = {
                      "name": unameCont.text,
                      "email": emailCont.text
                    };
                    await _dataBaseMethod
                        .isUsernameUsed(unameCont.text)
                        .then((value) {
                      if (value)
                        context.showSnackBarError("Username is already taken");
                      else {
                        LocalStorage.setUserName(unameCont.text);
                        LocalStorage.setUserMail(emailCont.text);

                        setState(() {
                          isLoading = true;
                          _authMethods
                              .signUp(emailCont.text, passCont.text)
                              .then((value) {
                            if (value is User) {
                              _dataBaseMethod.uploadUser(userMap);
                              LocalStorage.setUserLoggedIn(true);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatHome()));
                            } else
                              context.showSnackBarError(
                                  AuthExceptionHandler.generateExceptionMessage(
                                      value));
                          });
                          isLoading = false;
                        });
                      }
                    });
                  }
                },
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Text("SignUp"),
              ),
              context.columnSpacer,
              InkWell(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Text(
                    'Already have account',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

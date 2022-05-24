import 'package:chatchat/service/auth.dart';
import 'package:chatchat/service/database.dart';
import 'package:chatchat/service/firebase_error_manager.dart';
import 'package:chatchat/service/local_storage.dart';
import 'package:chatchat/widgets/textInputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/size_cofig.dart';
import 'chat_home.dart';
import '../utils/view_utils.dart';

class SignInPage extends StatefulWidget {
  final Function toggle;

  const SignInPage({Key? key, required this.toggle}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final passCont = TextEditingController(text:"ajithkp1234");
  final emailCont = TextEditingController(text:"ajithkp1537@gmail.com");
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final AuthMethods _authMethods = AuthMethods();
  final DataBaseMethod _dataBaseMethod = DataBaseMethod();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("SignIn"),
        ),
        body: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 4, left: 10, right: 10),
          child: Form(
            // autovalidateMode: AutovalidateMode.always,
            key: formkey,
            child: Column(
              children: [
                context.columnSpacer,
                CommonTextField(
                  controller: emailCont,
                  hint: "Email",
                  validate: (String? value) {
                    return (value != null && value.isEmpty ||
                            !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(value!))
                        ? "Enter valid email "
                        : null;
                  },
                ),
                context.columnSpacer,
                CommonTextField(
                  controller: passCont,
                  hint: "Password",
                  validate: (String? value) {
                    return (value != null && value.isEmpty || value!.length < 5)
                        ? "Password mustbe 8 digit "
                        : null;
                  },
                ),
                context.columnSpacer,
                context.columnSpacer,
               if (!isLoading) ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    
                    if (formkey.currentState!.validate()) {
                      QuerySnapshot user;

                      await _dataBaseMethod
                          .getUserbyUserEmail(emailCont.text)
                          .then((value) {
                        user = value;
                        if (user.docs.isNotEmpty) {
                          LocalStorage.setUserName(user.docs[0].get("name"));
                          LocalStorage.setUserMail(emailCont.text);
                          setState(() {
                           

                            _authMethods
                                .signIn(emailCont.text, passCont.text)
                                .then((value) {
                              if (value is User) {
                                LocalStorage.setUserLoggedIn(true);
                                isLoading = false;
                                print("succdess");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ChatHome()));
                              } else {
                                context.showSnackBarError(AuthExceptionHandler
                                    .generateExceptionMessage(value));
                              }
                            });
                            //isLoading = false;
                          });
                        } else {setState(() {
                          isLoading = false;
                        });
                          context.showSnackBarError("Invalid username");
                        }
                      });
                    }
                    isLoading = false;
                  },
                  child:  const Text("SignIn"),
                ),
                if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                      
                context.columnSpacer,
                InkWell(
                    onTap: () {
                      widget.toggle();
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ))
              ],
            ),
          ),
        ));
  }
}

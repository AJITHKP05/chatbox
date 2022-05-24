import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final String userLoggedin = "isLogged";

  static  String userName = "userName";
  static  String userEmail = "userEmail";

  static Future<void> setUserLoggedIn(bool value) async {
    final shared = await SharedPreferences.getInstance();
    shared.setBool(userLoggedin, value);
  }

  static Future<bool?> getUserLoggedIn() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getBool(userLoggedin);
  }

  static Future<void> setUserName(String value) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString(userName, value);
  }

  static Future<String?> getUserName() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString(userName);
  }

  static Future<void> setUserMail(String value) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString(userEmail, value);
  }

  static Future<String?> getUserMail() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString(userEmail);
  }
}

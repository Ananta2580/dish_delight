import 'package:shared_preferences/shared_preferences.dart';


class localDataSaver{

  static String mailkey = "MAILKEY";
  static String namekey = "NAMEKEY";
  static String logkey = "LOGKEY";

  static Future<bool> saveUserName(String username) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(namekey, username);
  }

  static Future<bool> saveMail(String useremail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(mailkey, useremail);
  }

  static Future<bool> saveLoginData(bool isLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(logkey, isLoggedIn);
  }

  static Future<bool?> getLoginData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(logkey);
  }

  static Future<String?> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(namekey);
  }

  static Future<String?> getMail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(mailkey);
  }

}
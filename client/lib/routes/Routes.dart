// import 'package:client/screens/Login-Screen.dart';
import 'package:client/entry_point.dart';
import 'package:client/screens/Disease_screen.dart';
import 'package:client/screens/Login.dart';
// import 'package:client/screens/register_view.dart';
import 'package:client/screens/TestData.dart';
import 'package:client/screens/Profile.dart';
import 'package:client/screens/Update_Info.dart';
import 'package:client/screens/signup_screen.dart';
import 'package:flutter/material.dart';
// import '../screens/Login.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String testdata = '/testdata';
  static const String profile = '/profile';
  static const String update = '/update';
  static const String disease = '/disease';
  static const String entry = '/entry';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => Login(),
      register: (context) => SignUpScreen(),
      testdata: (context) => DataScreen(),
      profile: (context) => UserInfo(),
      update: (context) => UpdateInfo(),
      disease: (context) => Disease(),
      entry: (context) => EntryPoint()
    };
  }
}

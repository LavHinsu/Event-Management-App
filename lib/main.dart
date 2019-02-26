import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'afterlogin.dart';
import 'login.dart';
import 'user.dart' as userdart;

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
    routes: {
      '/afterlogin': (context) => AfterLogin(),},
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;
  String uid;
  bool loggedin=false;

  @override
  void initState(){
    super.initState();
    SharedPreferences.getInstance()..then((prefs){
      setState(() {
        this.prefs=prefs;
        uid=prefs.getString("user");
        userdart.username=prefs.getString('username');
        if(uid!=null) {
          print("loggedin");
          print(uid);
          loggedin=true;
        }
        else{
          //do nothing here
        }
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: loggedin ? new AfterLogin() : AfterSplash(),
      title: new Text(
        'Event App For Managers',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.network(
          'https://udaan19.in/img/logo.8a82523f.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100,
      onClick: () => null,
      loaderColor: Colors.red,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'login_page.dart';
import 'main_page.dart';
import 'user.dart' as userdart;

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
    routes: {
      '/afterlogin': (context) => MainPage(),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;
  String uid;
  bool loggedin = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() {
          this.prefs = prefs;
          uid = prefs.getString("user");
          userdart.username = prefs.getString('username');
              
          if (userdart.username != null) {
            print("loggedin");
            print(uid);
            loggedin = true;
          } else {}
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SplashScreen(
        seconds: 5,
        navigateAfterSeconds: loggedin ? MainPage() : LoginPage(),
        image: Image(image: AssetImage("assets/images/udaan_logo.png")),
        backgroundColor: Colors.white,
        photoSize: 100,
        onClick: () => null,
      ),
    );
  }
}

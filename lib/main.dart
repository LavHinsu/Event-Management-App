import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'data_class.dart';
import 'login_page.dart';
import 'main_page.dart';
import 'msg_page.dart';
import 'user.dart' as userdart;

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
    routes: {
      '/afterlogin': (context) => MainPage(),
      '/msg': (context) => MsgPage()
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
  File jsonFile;
  Directory dir;
  String fileName = "myJSONFile.json";
  bool fileExists = false;
  List<dynamic> fileContent;

//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void createFile() async {
    print("Creating file!");
    File file = new File(dir.path + "/" + "participant.json");
    file.createSync();
    fileExists = true;
    String text = await getFileData("assets/participant.json");
    var events = jsonDecode(text);
    ParticipantList list = ParticipantList.fromJson(events);
    file.writeAsStringSync(json.encode(list.toString()));
  }

  void writeToFile(String key, String value) {
    print("Writing to file!");
    Map<String, String> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, String> jsonFileContent =
      json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile();
    }
    print(fileContent);
  }

  @override
  void initState() {
    super.initState();

//    _firebaseMessaging.getToken().then((token)=> print("token " + token));
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() {
          this.prefs = prefs;
          uid = prefs.getString("uid");
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

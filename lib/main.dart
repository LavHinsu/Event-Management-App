import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
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
  String fileName = "participant.json";
  bool fileExists = false;
  List<dynamic> fileContent;

//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void createFile() async {
    File file = new File(dir.path + "/" + "participant.json");
    file.createSync();
    fileExists = true;
    var response = http.post(
        "https://udaan19-messenger-api.herokuapp.com/getAll");
    String text = await getFileData("assets/participant.json");
    var events = jsonDecode(text);
    ParticipantList list = ParticipantList.fromJson(events);
    file.writeAsStringSync(json.encode(list.toJson()));
  }

  void writeToFile(List<dynamic> person) {
    print("Writing to file!");
    if (fileExists) {
      print("File exists");
      jsonFile.writeAsStringSync(json.encode(person));
    } else {
      print("File does not exist!");
      createFile();
    }
    print(fileContent);
  }

  @override
  void initState() {
    super.initState();
//    getApplicationDocumentsDirectory().then((Directory directory) {
//      dir = directory;
//      jsonFile = new File(dir.path + "/" + fileName);
//      fileExists = jsonFile.existsSync();
//      if (!fileExists) createFile();
//    });

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

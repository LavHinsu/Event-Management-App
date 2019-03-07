import 'dart:async' show Future;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'data_class.dart';
import 'login_page.dart';
import 'rounds_page.dart';
import 'user.dart';

import 'roundslist_page.dart';

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  SharedPreferences prefs;
  List<String> ids = new List();
  List<String> names = new List();
  bool loaded = false;

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() {
          this.prefs = prefs;
          username = prefs.getString('username');
        });
      });
    Firestore.instance
        .collection("managers")
        .document(username)
        .snapshots()
        .listen((data) {
      if (data.exists)
        setState(() {
          loaded = true;
        });
      else
        load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text(username.toString()), accountEmail: null),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Log Out"),
              onTap: () async {
                prefs.setString("token", null);
                prefs.setString('user', null);
                prefs.setString("username", null);
                prefs.setBool("isloggedin", false);
                await auth.signOut();
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: _events(),
      ),
    );
  }

  void load() async {
    String json = await getFileData("assets/events.json");
    final events = jsonDecode(json);
    EventsList event = new EventsList.fromJson(events);
    List<dynamic> list = List();

    for (int i = 0; i < events.length; i++) {
      for (int j = 0; j < event.events[i].managerdata.length; j++) {
        if (event.events[i].managerdata[j].phone == username) {
          Map<String, dynamic> temp = Map();
          temp["id"] = event.events[i].id;
          temp["totalRounds"] = event.events[i].rounds.length;
          temp["currentRound"] = 1;
          temp["first"] = "";
          temp["winner"] = "";
          temp["second"] = "";
          temp["name"] = event.events[i].eventname;
          List<dynamic> roundList = List();

          for (int i = 0; i < event.events[i].rounds.length; i++) {
            Map<String, dynamic> rounds = Map();
            if (i == 0)
              rounds["initial"] = event.events[i].participantdata;
            else
              rounds["initial"] = List();
            rounds["attendee"] = List();
            roundList.add(rounds);
          }
          temp["rounds"] = roundList;
          // ids.add(event.events[i].id);
          // names.add(event.events[i].eventname);
          list.add(temp);
        }
      }
    }

    Firestore.instance
        .collection("managers")
        .document(username)
        .setData({"events": list});
    setState(() {
      loaded = true;
    });
  }

  Widget _events() {
    if (loaded) {
      return Center(
          child: StreamBuilder(
        stream: Firestore.instance
            .collection('managers')
            .document(username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> events = snapshot.data["events"];
            //print(snapshot.data['events'].toString());
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, i) => GestureDetector(
                    onTap: () {
                      print(i);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoundList(
                                    eventid: events[i]["id"],
                                  )));
                    },
                    child: Card(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              events[i]["name"],textScaleFactor: 1.5,
                            ),
                          ),
                        )),
                  ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ));
    } else
      return CircularProgressIndicator();
  }
}

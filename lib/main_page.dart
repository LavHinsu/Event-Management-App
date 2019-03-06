import 'dart:async' show Future;
import 'dart:convert';

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
    fetch();
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

  void fetch() async {
    String json = await getFileData("assets/events.json");
    final events = jsonDecode(json);
    EventsList event = new EventsList.fromJson(events);

    for (int i = 0; i < events.length; i++) {
      for (int j = 0; j < event.events[i].managerdata.length; j++) {
        if (event.events[i].managerdata[j].phone == username) {
          ids.add(event.events[i].id);
          names.add(event.events[i].eventname);
        }
      }
    }
    names.add('you are not a manager, contact the devs');

    setState(() {
      loaded = true;
    });
  }

  Widget _events() {
    if (loaded) {
      return Center(
        child: ListView.builder(
            itemCount: ids.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print(index);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoundList(
                                eventid: ids[index],
                              )));
                  //MaterialPageRoute(
                  //  builder: (context) =>
                  //    RoundsPage(eventid: ids[index])));
                  //final snackBar = SnackBar(content: Text("Tap on $index"));
                  //Scaffold.of(context).showSnackBar(snackBar);
                },
                child: Card(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child:
                          Text(names[index], style: TextStyle(fontSize: 32.0)),
                    ),
                  ),
                ),
              );
            }),
      );
    } else
      return CircularProgressIndicator();
  }
}

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'Data.dart';

import 'login.dart';
import 'rounds.dart';
import 'user.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

class AfterLogin extends StatefulWidget {
  @override
  _AfterLogin createState() => new _AfterLogin();
}

class _AfterLogin extends State<AfterLogin> {
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
                await auth.signOut();
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AfterSplash()));
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

    List<String> managerphone =
        username.split("+91"); //rempove the +91 from the username

    print("phone no of manager:" + managerphone[1]);
    for (int i = 0; i < events.length; i++) {
      for (int j = 0; j < event.events[i].managerdata.length; j++) {
        if (event.events[i].managerdata[j].phone ==
            managerphone[1].toString()) {
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
                          builder: (context) => Rounds(eventid: ids[index])));
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

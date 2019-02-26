import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'login.dart';
import 'rounds.dart';
import 'user.dart';
//import 'package:http/http.dart';


Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}


//import 'user.dart' as user;

class AfterLogin extends StatefulWidget {
  @override
  _AfterLogin createState() => new _AfterLogin();
}

class _AfterLogin extends State<AfterLogin> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // List<Widget> eventChildren = List();
  //List list = List();
  List<String> ids = new List();
  List<String> names = new List();
  List<String> nop = new List();
  var id;

  bool loaded = false;

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
                accountName: Text(username), accountEmail: null),
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
    List events = jsonDecode(json);
    events.forEach((event) {
      ids.add(event["_id"]);
      names.add(event["eventName"]);
    });
    print(ids + names);
    setState(() {
      loaded = true;
    });

    //  print(ids);
    //print(names);
    //print(nop);
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
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Rounds(eventid:ids[index])));
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

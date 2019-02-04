import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'user.dart';
import 'package:http/http.dart';
import 'dart:convert';

//import 'user.dart' as user;

class AfterLogin extends StatefulWidget {
  @override
  _AfterLogin createState() => new _AfterLogin();
}

class _AfterLogin extends State<AfterLogin> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Widget> eventChildren = List();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: Text('AfterLogin'),
        ),
        body: Builder(builder: (BuildContext buildContext) {
          return Container(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: ListView(children: eventChildren),
            ),
          );
        }));
  }

  void fetch() async {
//    Response response =
//        await get(Uri.encodeFull(""), headers: {"Accept": "application/json"});
//    var json = jsonDecode(response.body);
    var widgets = <Widget>[];
    widgets.add(GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Text(
              'Event_1',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
      ),
    ));
    widgets.add(GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Text(
              'Event_1',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
      ),
    ));
    widgets.add(GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Text(
              'Event_1',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
      ),
    ));
    widgets.add(GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Text(
              'Event_1',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
      ),
    ));
    widgets.add(GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Text(
              'Event_1',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
      ),
    ));
    widgets.add(GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Text(
              'Event_1',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
      ),
    ));
    widgets.add(GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Text(
              'Event_1',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
      ),
    ));
    widgets.add(GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Text(
              'Event_1',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
      ),
    ));

    setState(() {
      eventChildren = widgets;
    });
  }
}

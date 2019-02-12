import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'login.dart';
import 'user.dart';
//import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  bool loaded = false;

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
        title: Text('Home'),
      ),
      body: Center(
        child: _events(),
      ),
    );
  }

  void fetch() async {
    Response response = await get("https://lav-hinsu.github.io/events.json");
    var data = jsonDecode(response.body);
    int objectlength = data.length;

    for (int i = 0; i < objectlength; i++) {
      //print(i);
      var temp = data[i];
      //print(temp['id']);
      ids.add(temp['id']);
      names.add(temp['name']);
      nop.add(temp['no-of-participants']);
      //print(data[i]);
      //print(temp['no-of-participants']);
    }
    setState(() {
      loaded = true;
    });

    print(ids);
    print(names);
    print(nop);
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
                  final snackBar = SnackBar(content: Text("Tap on $index"));
                  Scaffold.of(context).showSnackBar(snackBar);
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

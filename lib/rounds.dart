import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'login.dart';
import 'user.dart';
//import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'afterlogin.dart';
import 'participants.dart';

class Rounds extends StatefulWidget {
  final String eventid;
  Rounds({Key key, @required this.eventid}) : super(key: key);
  @override
  _Rounds createState() => new _Rounds();
}

class _Rounds extends State<Rounds> {
  @override
  void initState() {
    super.initState();
    //print(widget.eventid);
    fetchrounds();
  }

  final String data = null;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> round = new List();
  int count;
  bool loaded = false;

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
        child: _rounds(),
      ),
    );
  }

  fetchrounds() async {
    Response response = await get("https://lav-hinsu.github.io/rounds.json");
    var data = jsonDecode(response.body);
    int objectlength = data['event_id'].length;

    var event = data['event_id'];
    //var participants= rounds['participants'];

    var rounds = event['rounds'];
    count = rounds['count'];
    
    print(count);
    setState(() {
      loaded = true;
    });
  }

  Widget _rounds() {
     if (loaded) {
    return Center(
        child: ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  //print(index);
                Navigator.push(context,MaterialPageRoute(builder: (context)=>Participants(roundno:index)));

                },
                child: Card(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child:
                          Text("$index"),
                    ),
                  ),
                ),
              );
            }),
      );
  }else{

    return CircularProgressIndicator();
  }
  }
  
}

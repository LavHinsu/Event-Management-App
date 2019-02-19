import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'login.dart';
import 'user.dart';
//import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'afterlogin.dart';
import 'rounds.dart';

class Participants extends StatefulWidget {
  final int roundno;
  Participants({Key key, @required this.roundno}) : super(key: key);
  @override
  _Participants createState() => new _Participants();
}

class _Participants extends State<Participants> {
  List<String> roundparts= new List();
  List<String> roundparticipants=new List();
  List<String> listofparts=new List();
  List<String> phones = new List();
  List<String> participantnames  = new List();
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    //print(widget.eventid);
    fetchparticipants();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  

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
        child: participants(),
      ),
    );
  }

  fetchparticipants() async {
    Response response = await get("https://lav-hinsu.github.io/rounds.json");
    var data = jsonDecode(response.body);
    //int objectlength = data['event_id'].length;
    var roundparts = data['event_id'];
    var roundparticipants = roundparts['0'];
    var listofparts = roundparticipants['participants'];
  //  print(listofparts);
    var phones = listofparts['phone'];
    var participantnames = listofparts['name'];
   // print(phones);
    //print(names);
    print(phones.length);
    print(phones);
    setState(() {
      loaded = true;
    });
  }

  participants() {
    if(loaded)
    {
    return Center(
      child: ListView.builder(
          itemCount: phones.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print(index);
                print(phones[index]);
              },
              child: Card(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(phones[index]),
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

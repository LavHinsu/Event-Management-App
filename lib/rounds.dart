import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'login.dart';
import 'user.dart';
//import 'package:http/http.dart';

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

class Rounds extends StatefulWidget {
  final String eventid;
  Rounds({Key key, @required this.eventid}) : super(key: key);
  @override
  _Rounds createState() => new _Rounds();
}

class _Rounds extends State<Rounds> {
  int currentRound = 0;
  List rounds = List();
  var currentList;
  List<String> names = List();
  List<String> phone = List();
  List<bool> attend = List();
  List<bool> promote = List();

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
        title: DropdownButton(
            items: <DropdownMenuItem>[
              DropdownMenuItem(child: Text('Round 1')),
              DropdownMenuItem(child: Text('Round 2')),
              DropdownMenuItem(child: Text('Round 3')),
              DropdownMenuItem(child: Text('Winner')),
            ],
            onChanged: (i) {
              setState(() {
                currentRound = i;
                currentList = i >= rounds.length ? null : rounds[currentRound];
              });
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (i) {
            switch (i) {
              case 0:
                showDialog(
                    context: context, builder: (context) => optionDialog);
            }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text("Attendance"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add), title: Text("Promote"))
          ]),
      body: Center(
        child: _rounds(),
      ),
    );
  }

  fetchrounds() async {
    String json = await getFileData("assets/events.json");
    List events = jsonDecode(json);
    for (int i = 0; i < events.length; i++) {
      if (events[i]["_id"].toString() == widget.eventid) {
        events[i]["participants"].forEach((participant) {
          names.add(participant["name"]);
          phone.add(participant["phone"]);
          attend.add(false);
          promote.add(false);
        });
        break;
      }
    }

    rounds.add(ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(names[index]),
                      Checkbox(
                        value: true,
                        onChanged: null,
                      )
                    ],
                  )),
            ),
          );
        }));

    print(count);
    setState(() {
      loaded = true;
      currentList = rounds[currentRound] == null ? null : rounds[currentRound];
    });
  }

  Widget _rounds() {
    if (loaded) {
      return Center(child: currentList);
    } else {
      return CircularProgressIndicator();
    }
  }

  SimpleDialog optionDialog = SimpleDialog(
    children: <Widget>[
      SimpleDialogOption(
        child: Center(child: Text("Edit", style: TextStyle(fontSize: 28.0,),)),
        onPressed: null,
      ), SimpleDialogOption(
        child: Center(
            child: Text("Confirm", style: TextStyle(fontSize: 28.0,),)),
        onPressed: null,
      )
    ],
  );
}

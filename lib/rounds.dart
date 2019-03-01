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

  List<String> round1names = List();
  List<String> round1phone = List();

  List<String> round2names = List();
  List<String> round2phone = List();

  List<String> round3names = List();
  List<String> round3phone = List();

  List<String> winnernames = List();
  List<String> winnerphone = List();

  List<bool> inputs = new List<bool>();

  List<bool> attend = List();
  List<bool> promote = List();

  bool editmode = false;

  @override
  void initState() {
    super.initState();
    //print(widget.eventid);
    fetchrounds();
  }

  void ItemChange(bool val, int index) {
    setState(() {
      inputs[index] = val;
    });
  }

  final String data = null;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> round = new List();
  int count;
  bool loaded = false;
  static const menuItems = <String>['Round 1', 'Round 2', 'Round 3', 'Winners'];

  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
      )
      .toList();

  String _btn1SelectedVal = 'Round 1';
  String _btn2SelectedVal = '';
  String _btn3SelectedVal = '';
  String _btn4SelectedVal = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Color.fromARGB(0xff, 0xff, 0xff, 0xff),
            ),
            onPressed: () {
              setState(() {
                if (editmode) {
                  editmode = false;
                } else
                  editmode = true;
              });
            },
          )
        ],
        title: DropdownButton<String>(
            value: _btn1SelectedVal,
            items: this._dropDownMenuItems,
            onChanged: (String newValue) {
              setState(() {
                 
                _btn1SelectedVal = newValue;
                //print(_btn1SelectedVal);
                //print(_btn2SelectedVal);
                //print(_btn3SelectedVal);
                //print(_btn4SelectedVal);
              });
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (i) {
            switch (i) {
              case 0:
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                              'did these participants attended this round?'),
                          content: Text('NOTICE: This action cannot be undone'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                                child: Text('Confirm'), onPressed: () {}),
                          ],
                        ));
                break;
              case 1:
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                              'Are you sure you want to promote these users?'),
                          content: Text('NOTICE: This action cannot be undone'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                                child: Text('Confirm'), onPressed: () {}),
                          ],
                        ));
                break;
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
    print(count);
    setState(() {
      for (int i = 0; i < names.length; i++) {
        inputs.add(false);
      }
      loaded = true;
    });
  }

  Widget _rounds() {
    if (loaded) {
      return ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    CheckboxListTile(
                      value: inputs[index],
                      title: Text(names[index]),
                      onChanged: editmode
                          ? (bool val) {
                              ItemChange(val, index);
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  static editAttendance() {
    
  }

  static confirmAttendance() {}
}

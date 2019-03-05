import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'data_class.dart';
//import 'package:http/http.dart';

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

class RoundsPage extends StatefulWidget {
  final String eventid;
  String roundno;
  RoundsPage({Key key, @required this.eventid, this.roundno}) : super(key: key);

  @override
  RoundsPageState createState() => new RoundsPageState();
}

class RoundsPageState extends State<RoundsPage> {
  int currentRound = 0;
  List rounds = List();
  var currentList;
  List<String> names = List();
  List<String> phone = List();
  List<bool> inputs = new List<bool>();
  List<bool> attend = List();
  List<bool> promote = List();
  BottomNavigationBarItem _bottomNavigationBarItem;
  bool editmode = false;
  BottomNavigationBarItem attendace = BottomNavigationBarItem(
      icon: Icon(Icons.event), title: Text("Confirm Attendance"));
  BottomNavigationBarItem promotion = BottomNavigationBarItem(
      icon: Icon(Icons.event), title: Text("Promote to next round"));
  @override
  void initState() {
    super.initState();
    //print(widget.eventid);
    fetchRounds();
    _bottomNavigationBarItem = attendace;
  }

  void itemChange(bool val, int index) {
    setState(() {
      if (_bottomNavigationBarItem == attendace)
        attend[index] = val;
      else if (_bottomNavigationBarItem == promotion) promote[index] = val;
    });
  }

  final String data = null;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> round = new List();
  int count;
  bool loaded = false;

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
        title: Text('Participants'),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (i) {
            if (_bottomNavigationBarItem == attendace) {
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
                              child: Text('Confirm'),
                              onPressed: () {
                                List<String> temp = List();
                                for (int i = 0; i < attend.length; i++) {
                                  if (attend[i]) temp.add(phone[i]);
                                }
                                print(temp);
                                setState(() {
                                  _bottomNavigationBarItem = promotion;
                                  phone = temp;
                                  promote = List();
                                  for(int i=0;i<phone.length;i++){
                                    promote.add(false);
                                  }
                                });
                                Navigator.pop(context);
                              }),
                        ],
                      ));
            } else {
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
                              child: Text('Confirm'),
                              onPressed: () {
                                List<String> temp = List();
                                for (int i = 0; i < promote.length; i++) {
                                  if (promote[i]) temp.add(phone[i]);
                                }
                                phone = temp;
                                print(phone);
                              }),
                        ],
                      ));
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

  fetchRounds() async {
    String json = await getFileData("assets/events.json");
    var events = jsonDecode(json);
    EventsList event = new EventsList.fromJson(events);
    // print(event.events[0].participantdata[1].phone);
    for (int i = 0; i < events.length; i++) {
      {
        if (event.events[i].id.toString() == widget.eventid) {
          event.events[i].participantdata.forEach((participant) {
            phone.add(participant);
            attend.add(false);
            promote.add(false);
          });
          break;
        }
      }
    }
    print(count);
    setState(() {
      for (int i = 0; i < phone.length; i++) {
        inputs.add(false);
      }
      loaded = true;
    });
  }

  Widget _rounds() {
    if (loaded) {
      if (int.parse(widget.roundno) == 1) {
        return ListView.builder(
            itemCount: _bottomNavigationBarItem==attendace?attend.length:promote.length,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      CheckboxListTile(
                        value: _bottomNavigationBarItem == attendace
                            ? attend[index]
                            : promote[index],
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Participant name'),
                            Text(phone[index])
                          ],
                        ),
                        onChanged: editmode
                            ? (bool val) {
                                itemChange(val, index);
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    } else {
      return CircularProgressIndicator();
    }
  }

  static editAttendance() {}

  static confirmAttendance() {}
}

import 'dart:async';
import 'dart:convert';
import 'user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_class.dart';
//import 'package:http/http.dart';
import 'participant_class.dart';

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
  var event;
  int index;
  List<dynamic> events;
  List<String> names = List();
  List<dynamic> phone = List();
  List<bool> inputs = new List<bool>();
  List<bool> attend = List();
  List<bool> promote = List();
  bool editmode = false;
  @override
  void initState() {
    super.initState();
    print(widget.roundno);
    currentAction = attendance;
    //print(widget.eventid);
    doc = Firestore.instance.collection("managers").document(username);
    fetchRounds();
  }
 DocumentReference doc;
  Text attendance = Text(
    "Confirm Attendance",
    style: TextStyle(fontSize: 18.0),
  );
  Text promotion = Text("Confirm Promotion", style: TextStyle(fontSize: 18.0));
  Text currentAction;
  void itemChange(bool val, int index) {
    setState(() {
      if (currentAction == attendance)
        attend[index] = val;
      else if (currentAction == promotion) promote[index] = val;
    });
  }

  final String data = null;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> round = new List();
  int count;
  bool loaded = false;

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentAction == attendance) {
            TextEditingController name = TextEditingController();
            TextEditingController phone = TextEditingController();
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    title: Text("Add participant"),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 12.0, right: 12.0),
                        child: TextField(
                          decoration: InputDecoration(labelText: "Name"),
                          controller: name,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 12.0, right: 12.0),
                        child: TextField(
                          decoration:
                              InputDecoration(labelText: "Phone number"),
                          maxLength: 10,
                          controller: phone,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 12.0, right: 12.0),
                        child: FlatButton(
                          onPressed: () {},
                          child: Text("Confirm"),
                        ),
                      ),
                    ],
                  ),
            );
          } else {
            showDialog(context: context, builder: (context) => AlertDialog());
          }
        },
        child: Icon(Icons.add),
      ),
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
      body: Center(
        child: _rounds(),
      ),
    );
  }

  addParticipants() async {}

  fetchRounds() async {

    events = (await doc.snapshots().first).data["events"];
    
    for(int i =0 ;i<events.length;i++){
      if(events[i]["id"]==widget.eventid)
      { index = i;
        event =events[i];
        print(event["rounds"][int.parse(widget.roundno)-1]["initial"].toString());
        phone =event["rounds"][int.parse(widget.roundno)-1]["initial"];
        print("phone : " + phone.toString());
        for(int j =0;j<phone.length;j++){
          attend.add(false);
          promote.add(false);
        }
        break;
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
      if (int.parse(widget.roundno) !=0) {
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: currentAction == attendance
                      ? attend.length
                      : promote.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            CheckboxListTile(
                              value: currentAction == attendance
                                  ? attend[index]
                                  : promote[index],
                              title: GestureDetector(
                                onDoubleTap: () {
                                  TextEditingController name =
                                      TextEditingController();
                                  TextEditingController phoneT =
                                      TextEditingController();
                                  showDialog(
                                      context: context,
                                      builder: (_) => SimpleDialog(
                                            title: Text(
                                                "Change participant details"),
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0,
                                                    left: 12.0,
                                                    right: 12.0),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                      labelText: "Name"),
                                                  controller: name,
                                                  keyboardType:
                                                      TextInputType.text,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0,
                                                    left: 12.0,
                                                    right: 12.0),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                      labelText: phone[index]),
                                                  maxLength: 10,
                                                  controller: phoneT,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0,
                                                    left: 12.0,
                                                    right: 12.0),
                                                child: FlatButton(
                                                  onPressed: () {},
                                                  child: Text("Confirm"),
                                                ),
                                              ),
                                            ],
                                          ));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Participant name'),
                                    Text(phone[index])
                                  ],
                                ),
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
                  }),
            ),
            RaisedButton(
              onPressed: () {
                if (currentAction == attendance) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                                'did these participants attended this round?'),
                            content:
                                Text('NOTICE: This action cannot be undone'),
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
                                      currentAction = promotion;
                                      phone = temp;
                                      promote = List();
                                      for (int i = 0; i < phone.length; i++) {
                                        promote.add(false);
                                      }
                                    });
                                    event["rounds"][int.parse(widget.roundno)-1]["attendee"] =phone;
                                    events[index] =event;
                                    doc.updateData({"events":events});
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
                            content:
                                Text('NOTICE: This action cannot be undone'),
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
                                    event["rounds"][int.parse(widget.roundno)]["initial"] =phone;
                                    events[index] =event;
                                    doc.updateData({"events":events});
                                    Navigator.popAndPushNamed(context, "/msg");
                                  }),
                            ],
                          ));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: currentAction,
              ),
            )
          ],
        );
      }
    } else {
      return CircularProgressIndicator();
    }
  }

  static editAttendance() {}

  static confirmAttendance() {}
}

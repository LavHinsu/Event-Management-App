import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'msg_page.dart';
import 'user.dart';
//import 'package:http/http.dart';

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

class RoundsPage extends StatefulWidget {
  final String eventid;
  String roundno;
  final Map<String, String> names;

  RoundsPage({Key key, @required this.eventid, this.roundno, this.names})
      : super(key: key);

  @override
  RoundsPageState createState() => new RoundsPageState();
}

class RoundsPageState extends State<RoundsPage>
    with SingleTickerProviderStateMixin {
  var event;
  int index;
  String token;
  bool nameBool = false;
  SharedPreferences prefs;
  List<dynamic> events;
  List<dynamic> names = List();
  List<dynamic> phone = List();
  List<bool> inputs = new List<bool>();
  List<bool> attend = List();
  List<bool> promote = List();
  TabController tabController;
  bool editmode = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() {
          this.prefs = prefs;
          token = prefs.getString("token");
//          print(token);
        });
      });
//    print(widget.roundno);
    currentAction = attendance;

    tabController = TabController(vsync: this, length: 3);
    //print(widget.eventid);
    manager = Firestore.instance.collection("managers").document(username);
    participant = Firestore.instance.collection("participant");
    fetchRounds();
  }

  DocumentReference manager;
  CollectionReference participant;
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

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final String data = null;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> round = new List();
  int count;
  bool loaded = false;
  bool tabbed = false;

  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      bottomNavigationBar: tabbed
          ? Material(
          color: Colors.blue,
          child: TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                text: 'All',
              ),
              Tab(text: 'Atendees'),
              Tab(text: 'Promoted')
            ],
          ))
          : null,
      floatingActionButton: int.parse(widget.roundno) == 1
          ? FloatingActionButton(
        onPressed: () {
          if (currentAction == attendance &&
              !(int.parse(widget.roundno) < event["currentRound"])) {
            TextEditingController name = TextEditingController();
            TextEditingController phoneT = TextEditingController();
            TextEditingController branch = TextEditingController();
            TextEditingController year = TextEditingController();
            showDialog(
              context: context,
              builder: (context) =>
                  SimpleDialog(
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
                          controller: phoneT,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 12.0, right: 12.0),
                        child: TextField(
                          decoration:
                          InputDecoration(labelText: "Branch"),
                          controller: branch,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 12.0, right: 12.0),
                        child: TextField(
                          decoration: InputDecoration(labelText: "Year"),
                          maxLength: 1,
                          controller: year,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 12.0, right: 12.0),
                        child: FlatButton(
                          onPressed: () async {
                            if (year.text.isNotEmpty &&
                                name.text.isNotEmpty &&
                                branch.text.isNotEmpty &&
                                phoneT.text.isNotEmpty) {
                              var body = {
                                "name": name.text,
                                "phone": phoneT.text,
                                "branch": branch.text,
                                "year": year.text,
                                "events": {
                                  "rec_no": "123456",
                                  "eventName": event["name"],
                                  "code": "12345678"
                                }
                              };
                              String json1 = json.encode(body);
                              var response = await http.post(
                                  "https://udaan19-messenger-api.herokuapp.com/addParticipant",
                                  body: json1,
                                  headers: {
                                    'content-type': 'application/json',
                                    "Authorization": token
                                  });
                              var zed = json.decode(response.body);
                              print(json.decode(response.body));
                              if (zed.containsKey("success"))
                                key.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        "Participant Successfully registered")));
                              setState(() {
                                List<dynamic> temp = List();
                                phone.forEach((i) => temp.add(i));
                                temp.add(phoneT.text);
                                phone = temp;
                                event["rounds"]
                                [int.parse(widget.roundno) - 1]
                                ["initial"] = temp;
                                events[index] = event;
                                manager.updateData({"events": events});
                              });
                              Navigator.pop(context);
                            } else {
                              key.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      "Participant Successfully registered")));
                            }
                          },
                          child: Text("Confirm"),
                        ),
                      ),
                    ],
                  ),
            );
          }
        },
        child: Icon(Icons.add),
      )
          : null,
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
        title: Text("Round : ${widget.roundno}"),
      ),
      body: Center(
        child: _rounds(),
      ),
    );
  }

  fetchRounds() async {
    events = (await manager
        .snapshots()
        .first).data["events"];

    for (int i = 0; i < events.length; i++) {
      if (events[i]["id"] == widget.eventid) {
        index = i;
        event = events[i];

        phone = event["rounds"][int.parse(widget.roundno) - 1]["initial"];
//        print(phone[0]);
        await Future.forEach(phone, (i) async {
          participant.document(i).get().then((d) {
            names.add(d["name"]);
          });
        }).whenComplete(() {
          print(names);
          setState(() {
            loaded = true;
            nameBool = true;
          });
        });

        print(names);
        //print("phone : "   + phone.toString());
        for (int j = 0; j < phone.length; j++) {
          attend.add(false);
          promote.add(false);
        }
        break;
      }
    }
    print(count);
    setState(() {
      if (int.parse(widget.roundno) < event["currentRound"]) {
        tabbed = true;
      }
    });
  }

  Widget _rounds() {
    if (loaded) {
      if (event["currentRound"] > event["totalRounds"]) {
        return null;
      } else if (int.parse(widget.roundno) == event["currentRound"]) {
        if (nameBool) {
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

                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            SimpleDialog(
                                              title: Text(
                                                  "Change participant details"),
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
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
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 12.0,
                                                      left: 12.0,
                                                      right: 12.0),
                                                  child: FlatButton(
                                                    onPressed: () async {
                                                      print(phone[index]);
                                                      var response = await http
                                                          .post(
                                                          "https://udaan19-messenger-api.herokuapp.com/get",
                                                          body: json.encode({
                                                            "phone": phone[index]
                                                          }),
                                                          headers: {
                                                            'content-type':
                                                            'application/json',
                                                            "Authorization":
                                                            token
                                                          });
                                                      var body = json.decode(
                                                          response.body);
                                                      print(body);
                                                      body["name"] = name.text;
                                                      response = await http.put(
                                                          "https://udaan19-messenger-api.herokuapp.com/update",
                                                          body: json.encode(
                                                              body),
                                                          headers: {
                                                            'content-type':
                                                            'application/json',
                                                            "Authorization":
                                                            token
                                                          });
                                                      body = json.decode(
                                                          response.body);
                                                      print(body);
                                                      if (body["message"] ==
                                                          "Participant updated") {} else {}
                                                    },
                                                    child: Text("Confirm"),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("dfdsf"),
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
                        builder: (context) =>
                            AlertDialog(
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
                                    onPressed: () async {
                                      List<String> temp = List();
                                      for (int i = 0; i < attend.length; i++) {
                                        if (attend[i]) temp.add(phone[i]);
                                      }
                                      // print(temp);
                                      setState(() {
                                        if (int.parse(widget.roundno) !=
                                            event["totalRounds"])
                                          currentAction = promotion;
                                        phone = temp;
                                        promote = List();
                                        for (int i = 0; i < phone.length; i++) {
                                          promote.add(false);
                                        }
                                      });
                                      event["rounds"]
                                      [int.parse(widget.roundno) - 1]
                                      ["attendee"] = phone;
                                      events[index] = event;

                                      var red = {
                                        "contacts": phone,
                                        "eventName": event["name"],
                                        "theRound":
                                        event["currentRound"].toString()
                                      };
                                      print(json.encode(red));
                                      var response = await http.post(
                                          "https://udaan19-messenger-api.herokuapp.com/attendance",
                                          body: json.encode(red),
                                          headers: {
                                            'content-type': 'application/json',
                                            "Authorization": token
                                          });
                                      var body = json.decode(response.body);
                                      print(body);
                                      if (body["message"] ==
                                          "attendance added") {
                                        manager.updateData({"events": events});
                                        Navigator.pop(context);
                                      }
                                    }),
                              ],
                            ));
                  } else {
                    if (int.parse(widget.roundno) != event["totalRounds"])
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: const Text(
                                    'Are you sure you want to promote these users?'),
                                content: Text(
                                    'NOTICE: This action cannot be undone'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  FlatButton(
                                      child: Text('Confirm'),
                                      onPressed: () async {
                                        List<String> temp = List();
                                        for (int i = 0;
                                        i < promote.length;
                                        i++) {
                                          if (promote[i]) temp.add(phone[i]);
                                        }
                                        setState(() {
                                          phone = temp;
                                        });
                                        // print(phone);
//                                      event["rounds"][int.parse(widget.roundno)]
//                                          ["initial"] = phone;
//                                      event["currentRound"] =
//                                          int.parse(widget.roundno) + 1;
//                                      events[index] = event;
//
//                                      doc.updateData({"events": events});
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MsgPage(
                                                      events: events,
                                                      index: index,
                                                      phone: phone,
                                                      event: event,
                                                      round: event[
                                                      "currentRound"]
                                                    )));
                                      }),
                                ],
                              ));
                    else {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RoundsPage(
                                    eventid: widget.eventid,
                                    roundno: '${int.parse(widget.roundno) + 1}',
                                  )));
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: currentAction,
                ),
              )
            ],
          );
        } else
          return CircularProgressIndicator();
      } else if (int.parse(widget.roundno) < event["currentRound"]) {
        setState(() {
          tabbed = true;
        });
        return TabBarView(
          controller: tabController,
          children: <Widget>[
            ListView.builder(
              itemCount: event["rounds"][int.parse(widget.roundno) - 1]
                      ["initial"]
                  .length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          event["rounds"][int.parse(widget.roundno) - 1]
                              ["initial"][index],
                          textScaleFactor: 1.5,
                        ),
                      )),
                    ),
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: event["rounds"][int.parse(widget.roundno) - 1]
                      ["attendee"]
                  .length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          event["rounds"][int.parse(widget.roundno) - 1]
                              ["attendee"][index],
                          textScaleFactor: 1.5,
                        ),
                      )),
                    ),
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount:
                  event["rounds"][int.parse(widget.roundno)]["initial"].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          event["rounds"][int.parse(widget.roundno)]["initial"]
                              [index],
                          textScaleFactor: 1.5,
                        ),
                      )),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      } else if (int.parse(widget.roundno) > event["currentRound"])
        return Center(
          child: Text("Please complete the previous round first"),
        );
    } else {
      return CircularProgressIndicator();
    }
  }
}

import 'dart:async' show Future;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data_class.dart';
import 'login_page.dart';
import 'roundslist_page.dart';
import 'user.dart';

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String token;
  SharedPreferences prefs;
  List<String> ids = new List();
  List<String> names = new List();
  bool loaded = false;

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() {
          this.token = prefs.getString("token");
          print("token : " + token);
          //addParticiapants();
          this.prefs = prefs;
          username = prefs.getString('username');
        });
      });
    Firestore.instance
        .collection("managers")
        .document(username)
        .snapshots()
        .listen((data) {
      if (data.exists)
        setState(() {
          loaded = true;
        });
      else
        load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text(username.toString()), accountEmail: null),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Log Out"),
              onTap: () async {
                prefs.setString("token", null);
                prefs.setString('user', null);
                prefs.setString("username", null);
                prefs.setBool("isloggedin", false);
                await auth.signOut();
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
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

  void addParticiapants() async {
    var response = await http.post(
        "https://udaan19-messenger-api.herokuapp.com/getall",
        body: json.encode({
          'contacts': [
            "9428894767",
            "7405674894",
            "9099539644",
            "9726815593",
            "8347765018",
            "7046750633",
            "7283944774",
            "9055176442",
            "9033722943",
            "8160555677",
            "8733834280",
            "8238144991",
            "8511314418",
            "9558746785",
            "9409216691",
            "6354489678",
            "9726919739",
            "8160607663",
            "6355278118",
            "7046726821",
            "9586275119",
            "9687405887",
            "8960509806",
            "8141560189",
            "7990635057",
            "7600787017",
            "8238830004",
            "9512992683",
            "7487916278",
            "9913671557",
            "8469822358",
            "9428388155",
            "9427563545",
            "7265021583",
            "9033227174",
            "9067924224",
            "9979468172",
            "6354623438",
            "9687914078",
            "8401422420",
            "9265405975",
            "8460584053",
            "9427661995",
            "9712797254",
            "6359466428",
            "9998939450",
            "8140916146",
            "8160084764",
            "9879784707",
            "8200832625",
            "7889866832",
            "9265100295",
            "8490868721",
            "9512302663",
            "9429571813",
            "8238886862",
            "7405829723",
            "9737664396",
            "7046103040",
            "7777986013",
            "7087470898",
            "7575031470",
            "9904623877",
            "8160899636",
            "9054153750",
            "9727339254",
            "9682615933",
            "9879218339",
            "9574538378",
            "9925722451",
            "7889370157",
            "7778032377",
            "7698876286"
          ]
        }),
        headers: {'content-type': 'application/json', "Authorization": token});

    var body = json.decode(response.body)["participants"];

    print(body);
    if (body != null) {
      ParticipantList list = ParticipantList.fromJson(body);
      list.particpants.forEach((i) =>
          Firestore.instance
              .collection("participant")
              .document(i.phone)
              .setData(i.toJson()));
    }
  }

  void load() async {
    String json = await getFileData("assets/events.json");
    final events = jsonDecode(json);
    EventsList event = new EventsList.fromJson(events);
    List<dynamic> list = List();

    for (int i = 0; i < events.length; i++) {
      for (int j = 0; j < event.events[i].managerdata.length; j++) {
        if (event.events[i].managerdata[j].phone == username) {
          Map<String, dynamic> temp = Map();
          temp["id"] = event.events[i].id;
          temp["totalRounds"] = event.events[i].rounds.length;
          temp["currentRound"] = 1;
          temp["first"] = "";
          temp["winner"] = "";
          temp["second"] = "";
          temp["name"] = event.events[i].eventname;
          List<dynamic> roundList = List();

          for (int k = 0; k < event.events[i].rounds.length; k++) {
            Map<String, dynamic> rounds = Map();
            if (k == 0)
              rounds["initial"] = event.events[i].participantdata;
            else
              rounds["initial"] = List();
            rounds["attendee"] = List();
            roundList.add(rounds);
          }
          temp["rounds"] = roundList;
          // ids.add(event.events[i].id);
          // names.add(event.events[i].eventname);
          list.add(temp);
        }
      }
    }

    Firestore.instance
        .collection("managers")
        .document(username)
        .setData({"events": list});
    setState(() {
      loaded = true;
    });
  }

  Widget _events() {
    if (loaded) {
      return Center(
          child: StreamBuilder(
        stream: Firestore.instance
            .collection('managers')
            .document(username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> events = snapshot.data["events"];
            //print(snapshot.data['events'].toString());
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, i) => GestureDetector(
                    onTap: () {
                      print(i);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoundList(
                                    eventid: events[i]["id"],
                                  )));
                    },
                    child: Card(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              events[i]["name"],
                              textScaleFactor: 1.5,
                            ),
                          ),
                        )),
                  ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ));
    } else
      return CircularProgressIndicator();
  }
}

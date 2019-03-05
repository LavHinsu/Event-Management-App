import 'dart:convert';

import 'package:event_app/rounds_page.dart';
import 'package:flutter/material.dart';
import 'data_class.dart';
import 'rounds_page.dart';

class RoundList extends StatefulWidget {
  final String eventid;

  RoundList({Key key, @required this.eventid}) : super(key: key);

  @override
  RoundListState createState() => new RoundListState();
}

class RoundListState extends State<RoundList> {
  @override
  void initState() {
    super.initState();

    fetchnoofrounds();
  }

  bool loaded =false;
  int noofrounds;
  fetchnoofrounds() async {
    String json = await getFileData("assets/events.json");
    var events = jsonDecode(json);
    EventsList event = new EventsList.fromJson(events);

    for (int i = 0; i < events.length; i++) {

      if (event.events[i].id == widget.eventid) {
        noofrounds = event.events[i].rounds.length;
      }
      print('total rounds: $noofrounds');
    }
    setState(() {
      loaded = true;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Rounds'),
      ),
      body: Center(
        child: noofroundswidget(),
      ),
    );
  }

  Widget noofroundswidget() {
    if (loaded) {
      return Center(
        child: ListView.builder(
            itemCount: noofrounds,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoundsPage(
                                eventid: widget.eventid,
                                roundno: '${index + 1}',
                              )));
                },
                child: Card(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text('round ${index + 1}',
                          style: TextStyle(fontSize: 32.0)),
                    ),
                  ),
                ),
              );
            }),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}

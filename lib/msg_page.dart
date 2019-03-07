import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MsgPage extends StatefulWidget {
  final event;
  final round;
  MsgPage({this.event, this.round});
  @override
  _MsgPageState createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> {
  String txt;
  DateTime dt;
  TimeOfDay td;
  bool done = false;
  TextEditingController venue = TextEditingController();
  @override
  void initState() {
    super.initState();
    txt = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Promote Participants"),
          actions: <Widget>[GestureDetector(onTap: null, child: Text("Done"))],
        ),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Select Date : "),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final d = await showDatePicker(
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2019, 3, 1),
                          lastDate: DateTime(2019, 3, 16),
                          context: context);
                      if (d != null)
                        setState(() {
                          dt = d;
                        });
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Select Time : "),
                  IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null)
                        setState(() {
                          td = t;
                        });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: venue,
                decoration: InputDecoration(
                    labelText: "Enter venue", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Generate msg"),
                    onPressed: () {
                      setState(() {
                        if (td != null && dt != null && venue.text.isNotEmpty) {
                          done = true;
                          txt =
                              "Dear participant, Round ${widget.round} of ${widget.event} is on ${dt}, ${td} at " +
                                  venue.text +
                                  ". Kindly be present at the venue on time";
                        } else
                          done = false;
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Send"),
                    onPressed: () {
                      if(done){
    
                       //Navigator.popUntil(context, predicate);
                      }
                    },
                  )
                ],
              ),
            ),
            Text(txt)
          ],
        )));
  }
}

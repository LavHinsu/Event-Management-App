import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MsgPage extends StatefulWidget {
  @override
  _MsgPageState createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> {
  final formats = {
    InputType.both: DateFormat("EEEE, MM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };
  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Promote Participants"),
        actions: <Widget>[GestureDetector(onTap: null, child: Text("Done"))],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DateTimePickerFormField(
                inputType: inputType,
                format: formats[inputType],
                editable: editable,
                decoration: InputDecoration(
                    labelText: 'Date/Time',
                    hasFloatingPlaceholder: false,
                    border: OutlineInputBorder()),
                onChanged: (dt) => setState(() => date = dt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
part 'data_class.g.dart';

@JsonSerializable()
class EventsList {
  final List<Event> events;

  EventsList({
    this.events,
  });

  factory EventsList.fromJson(List<dynamic> parsedJson) {
    List<Event> events = new List<Event>();
    events = parsedJson.map((i) => Event.fromJson(i)).toList();

    return new EventsList(events: events);
  }
}
@JsonSerializable()
class Event {
  final String id;
  final String eventname;
  final List<String> rounds;
  final List<String> participantdata;
  final List<Manager> managerdata;

  Event(
      {this.id,
      this.eventname,
      this.managerdata,
      this.participantdata,
      this.rounds});

  factory Event.fromJson(Map<String, dynamic> json) {
    var participantlist = json['participants'];
    var rounds = json['rounds'];
    var managerlist = json['managers'] as List;
    List<String> participantdata = new List<String>.from(participantlist);
    List<String> rounddata = new List<String>.from(rounds);
    List<Manager> managerdata =
        managerlist.map((i) => Manager.fromJson(i)).toList();

    return new Event(
        id: json['_id'],
        eventname: json['eventName'],
        participantdata: participantdata,
        rounds: rounddata,
        managerdata: managerdata);
  }
}
@JsonSerializable()
class Manager {
  final String name;
  final String phone;

  Manager({this.phone, this.name});

  factory Manager.fromJson(Map<String, dynamic> json) {
    // print(json['name']);
    //print(json['phone']);
    return new Manager(phone: json['phone'], name: json['name']);
  }
}

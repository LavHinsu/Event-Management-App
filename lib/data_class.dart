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

@JsonSerializable()
class ParticipantList {
  final List<Participant> particpants;

  ParticipantList({this.particpants});

  factory ParticipantList.fromJson(List<dynamic> x) =>
      ParticipantList(
          particpants: x.map((i) => Participant.fromJson(i)).toList());
}

@JsonSerializable()
class Participant {
  final String id;
  final String name;
  final String year;
  final String branch;
  final String phone;
  final List<ParticipantEvent> events;

  Participant(
      {this.phone, this.events, this.id, this.name, this.year, this.branch});

  factory Participant.fromJson(Map<String, dynamic> json) {
    var data = json["events"] as List;
    List<ParticipantEvent> events =
    data.map((i) => ParticipantEvent.fromJson(i)).toList();
    return Participant(
        id: json["_id"],
        name: json["name"],
        branch: json["branch"],
        year: json["branch"],
        phone: json["phone"],
        events: events);
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "branch": branch,
        "year": year,
        "phone": phone,
        "events": events.map((i) => i.toJSon()).toList()
      };
}

@JsonSerializable()
class ParticipantEvent {
  final String rec_no;
  final String eventName;
  final String code;
  final int round;

  ParticipantEvent({this.rec_no, this.eventName, this.code, this.round});

  factory ParticipantEvent.fromJson(Map<String, dynamic> json) =>
      ParticipantEvent(
          rec_no: json["rec_no"],
          eventName: json["eventName"],
          code: json["code"],
          round: json["round"]);

  Map<String, dynamic> toJSon() =>
      {
        "rec_no": rec_no,
        "eventName": eventName,
        "code": code,
        "round": round
      };
}

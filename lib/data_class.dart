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

class Event {
  final String id;
  final String eventname;
  final List<Participant> participantdata;
  final List<Manager> managerdata;

  Event({this.id, this.eventname, this.managerdata, this.participantdata});

  factory Event.fromJson(Map<String, dynamic> json) {
    var participantlist = json['participants'] as List;
    var managerlist = json['managers'] as List;
    List<Participant> participantdata =
    participantlist.map((i) => Participant.fromJson(i)).toList();
    List<Manager> managerdata =
    managerlist.map((i) => Manager.fromJson(i)).toList();

    return new Event(
        id: json['_id'],
        eventname: json['eventName'],
        participantdata: participantdata,
        managerdata: managerdata);
  }
}

class Participant {
  final String phone;

  Participant({this.phone});

  factory Participant.fromJson(Map<String, dynamic> json) {
    //print(json['phone']);
    return new Participant(phone: json['phone']);
  }
}

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

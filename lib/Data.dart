class EventsList {
  final List<EventData> events;

  EventsList({
    this.events,
  });

  factory EventsList.fromJson(List<dynamic> parsedJson) {
    List<EventData> events = new List<EventData>();
    events = parsedJson.map((i) => EventData.fromJson(i)).toList();

    return new EventsList(events: events);
  }
}

class EventData {
  final String id;
  final String eventname;
  final List<ParticipantData> participantdata;
  final List<ManagerData> managerdata;

  EventData({this.id, this.eventname, this.managerdata, this.participantdata});

  factory EventData.fromJson(Map<String, dynamic> json) {
    var participantlist = json['participants'] as List;
    var managerlist = json['managers'] as List;
    List<ParticipantData> participantdata =
        participantlist.map((i) => ParticipantData.fromJson(i)).toList();
    List<ManagerData> managerdata =
        managerlist.map((i) => ManagerData.fromJson(i)).toList();

    return new EventData(
        id: json['_id'],
        eventname: json['eventName'],
        participantdata: participantdata,
        managerdata: managerdata);
  }
}

class ParticipantData {
  final String phone;
  ParticipantData({this.phone});
  factory ParticipantData.fromJson(Map<String, dynamic> json) {
    //print(json['phone']);
    return new ParticipantData(phone: json['phone']);
  }
}

class ManagerData {
  final String name;
  final String phone;
  ManagerData({this.phone, this.name});
  factory ManagerData.fromJson(Map<String, dynamic> json) {
   // print(json['name']);
    //print(json['phone']);
    return new ManagerData(phone: json['phone'], name: json['name']);
  }
}

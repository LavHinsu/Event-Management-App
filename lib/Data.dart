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
  EventData({
    this.id,
    this.eventname,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return new EventData(
      id: json['_id'],
      eventname: json['eventName'],
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventsList _$EventsListFromJson(Map<String, dynamic> json) {
  return EventsList(
      events: (json['events'] as List)
          ?.map((e) =>
              e == null ? null : Event.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$EventsListToJson(EventsList instance) =>
    <String, dynamic>{'events': instance.events};

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      id: json['id'] as String,
      eventname: json['eventname'] as String,
      managerdata: (json['managerdata'] as List)
          ?.map((e) =>
              e == null ? null : Manager.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      participantdata:
          (json['participantdata'] as List)?.map((e) => e as String)?.toList(),
      rounds: (json['rounds'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'eventname': instance.eventname,
      'rounds': instance.rounds,
      'participantdata': instance.participantdata,
      'managerdata': instance.managerdata
    };

Manager _$ManagerFromJson(Map<String, dynamic> json) {
  return Manager(phone: json['phone'] as String, name: json['name'] as String);
}

Map<String, dynamic> _$ManagerToJson(Manager instance) =>
    <String, dynamic>{'name': instance.name, 'phone': instance.phone};

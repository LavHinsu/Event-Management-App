// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantList _$ParticipantListFromJson(Map<String, dynamic> json) {
  return ParticipantList(
      participants: (json['participants'] as List)
          ?.map((e) => e == null
              ? null
              : Participant.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ParticipantListToJson(ParticipantList instance) =>
    <String, dynamic>{'participants': instance.participants};

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return Participant(
      id: json['id'] as String,
      name: json['name'] as String,
      currentrounddata: (json['currentrounddata'] as List)
          ?.map((e) =>
              e == null ? null : Rounddata.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      winner: json['winner'] as String,
      firstrunnerup: json['firstrunnerup'] as String,
      secondrunnerup: json['secondrunnerup'] as String);
}

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'winner': instance.winner,
      'firstrunnerup': instance.firstrunnerup,
      'secondrunnerup': instance.secondrunnerup,
      'currentrounddata': instance.currentrounddata
    };

Rounddata _$RounddataFromJson(Map<String, dynamic> json) {
  return Rounddata(
      phone: json['phone'] as String, name: json['name'] as String);
}

Map<String, dynamic> _$RounddataToJson(Rounddata instance) =>
    <String, dynamic>{'name': instance.name, 'phone': instance.phone};

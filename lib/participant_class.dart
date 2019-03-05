import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
part 'participant_class.g.dart';

@JsonSerializable()
class ParticipantList {
  final List<Participant> participants;

  ParticipantList({
    this.participants,
  });

  factory ParticipantList.fromJson(List<dynamic> parsedJson) {
    List<Participant> participants = new List<Participant>();
    participants = parsedJson.map((i) => Participant.fromJson(i)).toList();

    return new ParticipantList(participants: participants);
  }
}

@JsonSerializable()
class Participant {
  final String id;
  final String name;
  final String winner;
  final String firstrunnerup;
  final String secondrunnerup;

  final List<Rounddata> currentrounddata;

  Participant({
    this.id,
    this.name,
    this.currentrounddata,
    this.winner,
    this.firstrunnerup,
    this.secondrunnerup
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    var rounddatalist = json['Rounds'] as List;
    List<Rounddata> rounddatadata =
        rounddatalist.map((i) => Rounddata.fromJson(i)).toList();

    return new Participant(
      id: json['id'],
      name: json['name'],
      winner: json['winner'],
      firstrunnerup: json['1strunnerup'],
      secondrunnerup: json['2ndrunnerup'],
      currentrounddata: rounddatadata,
    );
  }
}

@JsonSerializable()
class Rounddata {
  final String name;
  final String phone;

  Rounddata({this.phone, this.name});

  factory Rounddata.fromJson(Map<String, dynamic> json) {
    // print(json['name']);
    //print(json['phone']);
    return new Rounddata(phone: json['initial'], name: json['attendee']);
  }
}

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'data_class.dart';
String username, password;
FirebaseUser user;

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

Future<Map<String, String>> fetchNames(List<dynamic> phone) async {
  String text = await getFileData("assets/participant.json");
  Map<String, dynamic> events = jsonDecode(text);
  Map<String, String> names = Map();
  events.forEach((key, value) {
    names.putIfAbsent(key, () =>
    Participant
        .fromJson(value)
        .name);
  });
  return names;
}
//
//Future<Map<String,dynamic>> fetchNames(List<dynamic> phone) async {
//  Map<String,dynamic> person = Map();
//  CollectionReference doc = Firestore.instance.collection("participant");
//  phone.forEach((i){
//    doc.document(i).get().then((data){person[i] = data.data; print(data.data);});
//  });
////  print(person);
//  return person;
//}

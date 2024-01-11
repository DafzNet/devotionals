// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';

class DevotionalModel {
  dynamic id;
  String title;
  String openingScriptureText;
  String openingScriptureReference;
  String body;
  DateTime date;
  String? instruction;
  String? confession;
  String? prayer;
  String? furtherScriptures;
  String? dailyScriptureReading;
  String? doingTheWord;
  Map<String, bool> reactions;

  DevotionalModel({
    required this.id,
    required this.title,
    required this.openingScriptureText,
    required this.openingScriptureReference,
    required this.body,
    required this.date,
    this.instruction,
    this.confession,
    this.prayer,
    this.furtherScriptures,
    this.dailyScriptureReading,
    this.doingTheWord,
    this.reactions = const {},
  });




  DevotionalModel copyWith({
    dynamic? id,
    String? title,
    String? openingScriptureText,
    String? openingScriptureReference,
    String? body,
    DateTime? date,
    String? instruction,
    String? confession,
    String? prayer,
    String? furtherScriptures,
    String? dailyScriptureReading,
    String? doingTheWord,
    Map<String, bool>? reactions,
  }) {
    return DevotionalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      openingScriptureText: openingScriptureText ?? this.openingScriptureText,
      openingScriptureReference: openingScriptureReference ?? this.openingScriptureReference,
      body: body ?? this.body,
      date: date ?? this.date,
      instruction: instruction ?? this.instruction,
      confession: confession ?? this.confession,
      prayer: prayer ?? this.prayer,
      furtherScriptures: furtherScriptures ?? this.furtherScriptures,
      dailyScriptureReading: dailyScriptureReading ?? this.dailyScriptureReading,
      doingTheWord: doingTheWord ?? this.doingTheWord,
      reactions: reactions ?? this.reactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'openingScriptureText': openingScriptureText,
      'openingScriptureReference': openingScriptureReference,
      'body': body,
      'date': date.millisecondsSinceEpoch,
      'instruction': instruction,
      'confession': confession,
      'prayer': prayer,
      'furtherScriptures': furtherScriptures,
      'dailyScriptureReading': dailyScriptureReading,
      'doingTheWord': doingTheWord,
      'reactions': reactions,
    };
  }

  factory DevotionalModel.fromMap(Map<String, dynamic> map) {
    Map<String, bool> r = {};
    return DevotionalModel(
      id: map['id'] as dynamic,
      title: map['title'] as String,
      openingScriptureText: map['openingScriptureText'] as String,
      openingScriptureReference: map['openingScriptureReference'] as String,
      body: map['body'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      instruction: map['instruction'] != null ? map['instruction'] as String : null,
      confession: map['confession'] != null ? map['confession'] as String : null,
      prayer: map['prayer'] != null ? map['prayer'] as String : null,
      furtherScriptures: map['furtherScriptures'] != null ? map['furtherScriptures'] as String : null,
      dailyScriptureReading: map['dailyScriptureReading'] != null ? map['dailyScriptureReading'] as String : null,
      doingTheWord: map['doingTheWord'] != null ? map['doingTheWord'] as String : null,
      reactions: Map<String, bool>.from((map.containsKey('reactions')?  Map<String, bool>.from(map['reactions']) : r)),
    );
  }

  String toJson() => json.encode(toMap());

  factory DevotionalModel.fromJson(String source) => DevotionalModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DevotionalModel(id: $id, title: $title, openingScriptureText: $openingScriptureText, openingScriptureReference: $openingScriptureReference, body: $body, date: $date, instruction: $instruction, confession: $confession, prayer: $prayer, furtherScriptures: $furtherScriptures, dailyScriptureReading: $dailyScriptureReading, doingTheWord: $doingTheWord, reactions: $reactions)';
  }

  @override
  bool operator ==(covariant DevotionalModel other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;
  
    return 
      other.id == id &&
      other.title == title &&
      other.openingScriptureText == openingScriptureText &&
      other.openingScriptureReference == openingScriptureReference &&
      other.body == body &&
      other.date == date &&
      other.instruction == instruction &&
      other.confession == confession &&
      other.prayer == prayer &&
      other.furtherScriptures == furtherScriptures &&
      other.dailyScriptureReading == dailyScriptureReading &&
      other.doingTheWord == doingTheWord &&
      mapEquals(other.reactions, reactions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      openingScriptureText.hashCode ^
      openingScriptureReference.hashCode ^
      body.hashCode ^
      date.hashCode ^
      instruction.hashCode ^
      confession.hashCode ^
      prayer.hashCode ^
      furtherScriptures.hashCode ^
      dailyScriptureReading.hashCode ^
      doingTheWord.hashCode ^
      reactions.hashCode;
  }
}


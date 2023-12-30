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


DevotionalModel todayDevetional(){

  return DevotionalModel(
    id: DateTime.now().millisecond,
    title: 'Go for Knowledge', 
    openingScriptureText: "Reprehenderit veniam incididunt officia ea est sit commodo aute ex eiusmod ipsum anim.Dolore pariatur sint anim proident et veniam mollit magna eu ex. Anim culpa esse excepteur aliqua laboris ut officia occaecat nisi anim minim. Eu deserunt ea Lorem culpa et ex do sint laboris fugiat incididunt quis voluptate. Dolore dolore elit in quis tempor laborum sint culpa sunt qui nulla ad. Nostrud ex nisi velit quis aute excepteur anim cillum in ut. Adipisicing et proident officia commodo nulla officia elit anim dolore incididunt cupidatat.But how shall they ask him to save them unless they believe in him? And how can they believe in him if they have never heard about him? And how can they hear about him unless someone tells them?", 
    openingScriptureReference: '2 Peter 3:3', 
    body: 'One of the anchors of faith is the knowledge of God\'s Word. Faith begins where the will of God is known. If you don\'t know what God wants to do how can you expect it? So it is important that you get the knowledge of God\'s Word or your faith will be ineffective. In the realm of faith there are no assumptions because faith is anchored on revelation. When knowledge grows faith grows. Our opening scripture shows us that until you receive the knowledge of the gospel you cannot be saved. This is why Romans 10:17 says, “So then faith cometh by hearing, and hearing by the word of God.” This means that faith is an offspring of the Word of God. If there is no Word, there will be no faith because faith is a product of the Word of God. In Mark 5:25-29, the Bible tells us of the woman who had the issue of blood for twelve years and had suffered many things in the hands of many physicians and had spent all she had but did not get any better, rather the condition grew worse. The Bible reveals that when she heard of Jesus in verse 27 faith was stirred in her heart and she said within herself, “… If I may touch but his clothes, I shall be whole.” Mark 5:28. As she went on to exercise her faith and touched His clothes, she was healed of that plague. God met her at the point of her faith.', 
    date: DateTime.now(),
    instruction: 'Ask for whatsoever you desire; pray in faith in the Name of Jesus',
    furtherScriptures: ['Matthew 12:34-37', 'Romans 10:16-17', '1 Thessalonians 2:13'].join(' '),
    doingTheWord: 'I encourage you to put your faith to work today and God will meet you at the point of your faith',
    dailyScriptureReading: ['2 Corinthians 4', '1 Thessalonians 4', '1 Timothy 1'].join(' ')
  );
}



// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Letters {
  dynamic id;
  String type; //letter or prayer
  String text;
  DateTime date;
  
  Letters({
    required this.id,
    this.type = 'letter',
    required this.text,
    required this.date,
  });

  

  Letters copyWith({
    dynamic? id,
    String? type,
    String? text,
    DateTime? date,
  }) {
    return Letters(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'text': text,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Letters.fromMap(Map<String, dynamic> map) {
    return Letters(
      id: map['id'] as dynamic,
      type: map['type'] as String,
      text: map['text'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Letters.fromJson(String source) => Letters.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Letters(id: $id, type: $type, text: $text, date: $date)';
  }

  @override
  bool operator ==(covariant Letters other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.type == type &&
      other.text == text &&
      other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type.hashCode ^
      text.hashCode ^
      date.hashCode;
  }
}

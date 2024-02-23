import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DailyVerse {
  dynamic id;
  String verseText;
  String reference;
  DateTime date;
  
  DailyVerse({
    required this.id,
    required this.verseText,
    required this.reference,
    required this.date,
  });

  DailyVerse copyWith({
    dynamic? id,
    String? verseText,
    String? reference,
    DateTime? date,
  }) {
    return DailyVerse(
      id: id ?? this.id,
      verseText: verseText ?? this.verseText,
      reference: reference ?? this.reference,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'verseText': verseText,
      'reference': reference,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory DailyVerse.fromMap(Map<String, dynamic> map) {
    return DailyVerse(
      id: map['id'] as dynamic,
      verseText: map['verseText'] as String,
      reference: map['reference'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyVerse.fromJson(String source) => DailyVerse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DailyVerse(id: $id, verseText: $verseText, reference: $reference, date: $date)';
  }

  @override
  bool operator ==(covariant DailyVerse other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.verseText == verseText &&
      other.reference == reference &&
      other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      verseText.hashCode ^
      reference.hashCode ^
      date.hashCode;
  }
}

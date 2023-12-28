// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Note {
  dynamic id;
  dynamic? devId;
  String title;
  String category;
  DateTime date;
  DateTime lastUpdated;
  String tags;
  String body;
  String? photo;

  Note({
    required this.id,
    this.devId,
    required this.title,
    required this.category,
    required this.date,
    required this.lastUpdated,
    required this.tags,
    required this.body,
    this.photo,
  });




  Note copyWith({
    dynamic? id,
    dynamic? devId,
    String? title,
    String? category,
    DateTime? date,
    DateTime? lastUpdated,
    String? tags,
    String? body,
    String? photo,
  }) {
    return Note(
      id: id ?? this.id,
      devId: devId ?? this.devId,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      tags: tags ?? this.tags,
      body: body ?? this.body,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'devId': devId,
      'title': title,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'tags': tags,
      'body': body,
      'photo': photo,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as dynamic,
      devId: map['devId'] != null ? map['devId'] as dynamic : null,
      title: map['title'] as String,
      category: map['category'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated'] as int),
      tags: map['tags'].toString(),
      body: map['body'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Note(id: $id, devId: $devId, title: $title, category: $category, date: $date, lastUpdated: $lastUpdated, tags: $tags, body: $body, photo: $photo)';
  }

  @override
  bool operator ==(covariant Note other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.category == category &&
      other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      devId.hashCode ^
      title.hashCode ^
      category.hashCode ^
      date.hashCode ^
      lastUpdated.hashCode ^
      tags.hashCode ^
      body.hashCode ^
      photo.hashCode;
  }
}

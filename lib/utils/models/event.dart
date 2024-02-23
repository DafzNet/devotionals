// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EventModel {
  dynamic id;
  String title;
  String? theme;
  String? scripture;
  String? description;
  String? image;
  DateTime startDate;
  DateTime? endDate;
  
  EventModel({
    required this.id,
    required this.title,
    this.theme,
    this.scripture,
    this.description,
    this.image,
    required this.startDate,
    this.endDate,
  });

  

  EventModel copyWith({
    dynamic? id,
    String? title,
    String? theme,
    String? scripture,
    String? description,
    String? image,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      theme: theme ?? this.theme,
      scripture: scripture ?? this.scripture,
      description: description ?? this.description,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'theme': theme,
      'scripture': scripture,
      'description': description,
      'image': image,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as dynamic,
      title: map['title'] as String,
      theme: map['theme'] != null ? map['theme'] as String : null,
      scripture: map['scripture'] != null ? map['scripture'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: map['endDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, theme: $theme, scripture: $scripture, description: $description, image: $image, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.theme == theme &&
      other.scripture == scripture &&
      other.description == description &&
      other.image == image &&
      other.startDate == startDate &&
      other.endDate == endDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      theme.hashCode ^
      scripture.hashCode ^
      description.hashCode ^
      image.hashCode ^
      startDate.hashCode ^
      endDate.hashCode;
  }
}

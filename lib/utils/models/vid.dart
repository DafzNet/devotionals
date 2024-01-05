// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';

class VideoData {
  final String id;
  final DateTime time;
  final List<String> tags;
  final String category;
  final Map<String, int> reactions;
  final String? series; // Nullable
  final String? part;   // Nullable

  VideoData({
    required this.id,
    required this.time,
    required this.tags,
    required this.category,
    this.reactions = const {},
    this.series,
    this.part,
  });

  VideoData copyWith({
    String? id,
    DateTime? time,
    List<String>? tags,
    String? category,
    Map<String, int>? reactions,
    String? series,
    String? part,
  }) {
    return VideoData(
      id: id ?? this.id,
      time: time ?? this.time,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      reactions: reactions ?? this.reactions,
      series: series ?? this.series,
      part: part ?? this.part,
    );
  }

  factory VideoData.fromMap(Map<String, dynamic> map) {
    return VideoData(
      id: map['id'],
      time: DateTime.parse(map['time']),
      tags: List<String>.from(map['tags']),
      category: map['category'],
      reactions: Map<String, int>.from(map['reactions']),
      series: map['series'],
      part: map['part'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'tags': tags,
      'category': category,
      'reactions': reactions,
      'series': series,
      'part': part,
    };
  }


  @override
  bool operator ==(covariant VideoData other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;
  
    return 
      other.id == id &&
      other.time == time &&
      other.category == category &&
      other.series == series &&
      other.part == part;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      time.hashCode ^
      tags.hashCode ^
      category.hashCode ^
      reactions.hashCode ^
      series.hashCode ^
      part.hashCode;
  }
}

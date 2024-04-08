import 'package:flutter/material.dart';

class EventModel {
  dynamic id;
  String title;
  String? theme;
  String? scripture;
  String? venue; // Changed from description to venue
  String? image;
  DateTime startDate;
  DateTime? endDate;
  Color? color;

  EventModel({
    required this.id,
    required this.title,
    this.theme,
    this.scripture,
    this.venue, // Changed from description to venue
    this.image,
    required this.startDate,
    this.endDate,
    this.color,
  });

  // Convert EventModel object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'theme': theme,
      'scripture': scripture,
      'venue': venue, // Changed from description to venue
      'image': image,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'color': color != null ? colorToString(color!) : null,
    };
  }

  // Factory method to create EventModel instance from Map
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      title: map['title'],
      theme: map['theme'],
      scripture: map['scripture'],
      venue: map['venue'], // Changed from description to venue
      image: map['image'],
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      color: map['color'] != null ? stringToColor(map['color']) : null,
    );
  }

  // Create a copy of EventModel with modified properties
  EventModel copyWith({
    dynamic id,
    String? title,
    String? theme,
    String? scripture,
    String? venue,
    String? image,
    DateTime? startDate,
    DateTime? endDate,
    Color? color,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      theme: theme ?? this.theme,
      scripture: scripture ?? this.scripture,
      venue: venue ?? this.venue,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      color: color ?? this.color,
    );
  }


}

  String colorToString(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0')}';
  }


 Color stringToColor(String colorString) {
    int value = int.parse(colorString.substring(2), radix: 16);
    return Color(value).withAlpha((value >> 24) & 0xFF);
  }


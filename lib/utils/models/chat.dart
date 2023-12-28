// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chat {
  DateTime? timestamp;
  String senderId;
  String text;
  Chat({
    this.timestamp,
    required this.senderId,
    required this.text,
  });


  Chat copyWith({
    DateTime? timestamp,
    String? senderId,
    String? text,
  }) {
    return Chat(
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'senderId': senderId,
      'text': text,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      timestamp: map['timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int) : null,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Chat(timestamp: $timestamp, senderId: $senderId, text: $text)';

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;
  
    return 
      other.timestamp == timestamp &&
      other.senderId == senderId &&
      other.text == text;
  }

  @override
  int get hashCode => timestamp.hashCode ^ senderId.hashCode ^ text.hashCode;
}

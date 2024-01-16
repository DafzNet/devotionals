// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chat {
  dynamic id;
  DateTime? timestamp;
  String senderId;
  bool isSeen;
  Chat? isReply; // Represents another Chat object
  String text;

  Chat({
    this.id,
    this.timestamp,
    required this.senderId,
    this.isSeen = false,
    this.isReply, // Include isReply in the constructor
    required this.text,
  });

  Chat copyWith({
    dynamic id,
    DateTime? timestamp,
    String? senderId,
    bool? isSeen,
    Chat? isReply, // Include isReply in the copyWith method
    String? text,
  }) {
    return Chat(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      isSeen: isSeen ?? this.isSeen,
      isReply: isReply ?? this.isReply, // Update isReply in the copyWith method
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'senderId': senderId,
      'isSeen': isSeen,
      'isReply': isReply?.toMap(), // Serialize isReply if it exists
      'text': text,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map.containsKey('id')? map['id']:DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp: map['timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int) : null,
      senderId: map['senderId'].toString(),
      isSeen: map.containsKey('isSeen')? map['isSeen'] as bool:false,
      isReply: map.containsKey('isReply')? map['isReply'] != null ? Chat.fromMap(map['isReply'] as Map<String, dynamic>) : null:null, // Deserialize isReply
      text: map['text'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) {
    final decodedJson = json.decode(source);
    if (decodedJson is Map<String, dynamic>) {
      return Chat.fromMap(decodedJson);
    } else {
      throw FormatException("Invalid JSON format");
    }
  }

  @override
  String toString() {
    return 'Chat(id: $id, timestamp: $timestamp, senderId: $senderId, isSeen: $isSeen, isReply: $isReply, text: $text)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return 
      other.id == id &&
      other.timestamp == timestamp &&
      other.senderId == senderId &&
      other.isSeen == isSeen &&
      other.isReply == isReply && // Update isReply in the equality check
      other.text == text;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      timestamp.hashCode ^
      senderId.hashCode ^
      isSeen.hashCode ^
      isReply.hashCode ^ // Include isReply in the hashCode calculation
      text.hashCode;
  }
}

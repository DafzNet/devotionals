// ignore_for_file: public_member_api_docs, sort_constructors_first

class Chat {
  dynamic id;
  DateTime? timestamp;
  String senderId;
  bool isSeen;
  bool isDelivered;
  bool isSent;
  Chat? isReply;
  String text;
  String? image;
  String? audio;

  Chat({
    this.id,
    this.timestamp,
    required this.senderId,
    this.isSeen = false,
    this.isDelivered = false,
    this.isSent = false,
    this.isReply,
    required this.text,
    this.image,
    this.audio,
  });

  Chat copyWith({
    dynamic id,
    DateTime? timestamp,
    String? senderId,
    bool? isSeen,
    bool? isDelivered,
    bool? isSent,
    Chat? isReply,
    String? text,
    String? image,
    String? audio,
  }) {
    return Chat(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      isSeen: isSeen ?? this.isSeen,
      isDelivered: isDelivered ?? this.isDelivered,
      isSent: isSent ?? this.isSent,
      isReply: isReply ?? this.isReply,
      text: text ?? this.text,
      image: image ?? this.image,
      audio: audio ?? this.audio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'senderId': senderId,
      'isSeen': isSeen,
      'isDelivered': isDelivered,
      'isSent': isSent,
      'isReply': isReply?.toMap(),
      'text': text,
      'image': image,
      'audio': audio,
    };
  }

  static Chat fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      timestamp: map['timestamp'] != null? DateTime.fromMillisecondsSinceEpoch(map['timestamp']) : null,
      senderId: map['senderId'],
      isSeen:  map['isSeen']??false,
      isDelivered: map.containsKey('isDelivered') ? map['isDelivered']:false,
      isSent: map.containsKey('isSent') ? map['isSent']:true,
      isReply: map['isReply'] != null ? Chat.fromMap(map['isReply']) : null,
      text: map['text'],
      image: map.containsKey('image') ? map['image']:null,
      audio: map.containsKey('audio')? map['audio']:null,
    );
  }
}


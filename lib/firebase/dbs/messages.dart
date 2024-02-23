import 'package:firebase_database/firebase_database.dart';
import 'package:devotionals/providers/chats.dart';
import 'package:devotionals/utils/models/chat.dart';

class ChatService {
  final DatabaseReference _chatReference = FirebaseDatabase.instance.ref().child('chats');
  final DatabaseReference _buddiesRef = FirebaseDatabase.instance.ref().child('buddies');

  Future<void> updateBuddiesLastChat(String userId, String buddyId, Chat lastChat) async {
    final buddiesRef = _buddiesRef.child(userId).child(buddyId);
    // Set the last chat for the buddy
    await buddiesRef.set({
        'buddyId':buddyId,
        'text': lastChat.text,
        'senderId': lastChat.senderId,
        'timestamp': ServerValue.timestamp,
    });
  }

  Stream<List<Map<String, dynamic>>> listenForNewBuddies(String userId) {
    final buddiesRef = _buddiesRef.child(userId);

    final buds = buddiesRef.onValue.map<List<Map<String, dynamic>>>((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> __data = snapshot.value as Map;
        Map _data = Map.from(__data);
        List<Map<String, dynamic>> data = [];
        
        
        for (var l in _data.values.toList()) {
          data.add(
            Map<String, dynamic>.from(l),
          );
        }
        
        final d = data.map((e) => {
          'buddyId': e['buddyId'],
          'chat':Chat.fromMap(
            {
              'timestamp': e['timestamp'],
              'text': e['text'],
              'senderId': e['senderId'],
              'isSeen':e['isSeen']??true,
              'isReply': e.containsKey('isReply') && e['isReply'] != null?Map<String, dynamic>.from(e['isReply']):null,
              'id':e['id'],
              'audio':e['audio'],
              'image':e['image'],
              'isDelivered':e['isDelivered']??false,
              'isSent':e['isSent']??false
            }
            
          )
        }
        ).toList();


        return d;

      }

      return [];
   }
   
   );

   return buds;
  }


  void createChatDocument(String user1, String user2, Chat chat) async {
    // Check for an existing document with the provided user1 and user2
    List<String> mails = [user1, user2];
    mails.sort();
    DataSnapshot dataSnapshot = await _chatReference.child(mails.join('_')).get();

    if (dataSnapshot.value != null) {
      // If a matching document is found, add the chat to its subcollection
      await _chatReference
          .child(mails.join('_'))
          .child('messages')
          .child(chat.id.toString())
          .set({
            'text': chat.text,
            'senderId': chat.senderId,
            'timestamp': ServerValue.timestamp,
            'isReply':chat.isReply?.toMap(),
            'isSeen':chat.isSeen,
            'id':chat.id.toString(),
            'audio':chat.audio,
            'image':chat.image,
            'isDelivered':chat.isDelivered,
            'isSent':chat.isSent

          });
    } else {
      // If no matching document is found, create a new document and add the chat
      DatabaseReference newChatRef = _chatReference.child(mails.join('_'));
      newChatRef.set({
        'user1': mails[0],
        'user2': mails[1],
      });

      DatabaseReference subcollectionRef = newChatRef.child('messages');
      subcollectionRef.child(chat.id.toString()).set({
        'text': chat.text,
        'senderId': chat.senderId,
        'timestamp': ServerValue.timestamp,
        'isReply':chat.isReply?.toMap(),
        'isSeen':chat.isSeen,
        'id':chat.id.toString(),
        'audio':chat.audio,
        'image':chat.image,
        'isDelivered':chat.isDelivered,
        'isSent':chat.isSent
      });
    }

    await updateBuddiesLastChat(user1, user2, chat);
    await updateBuddiesLastChat(user2, user1, chat);                                                  
  }

  Stream<List<Chat>> getChats(String user1, String user2) {
    List<String> mails = [user1, user2];
    mails.sort();

    DatabaseReference chatRef = _chatReference.child(mails.join('_'));

    return chatRef.child('messages').onValue.map<List<Chat>>((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> __data = snapshot.value as Map;
        Map _data = Map.from(__data);
        List<Map<String, dynamic>> data = [];
        
        for (var l in _data.values.toList()) {
          
          final k = l.containsKey('isReply') && l['isReply'] != null? Map.from(l['isReply']):null;
          l['isReply'] = k!=null? Map<String, dynamic>.from(k):null;
          data.add(
            Map<String, dynamic>.from(l),
          );
        }

        List<Chat> messages = [];
        
        for (var e in data) {
          messages.add(Chat.fromMap(e as Map<String, dynamic>));
        }
        
        return messages;
      } else {
        return [];
      }
    });
  }

  Future<List<Chat>> getChatsFuture(String userId) async {
    DataSnapshot querySnapshot1 =
        await _chatReference.orderByChild('user1').equalTo(userId).limitToLast(1).get();

    if (querySnapshot1.value != null) {
      String chatKey = querySnapshot1.key!;
      DataSnapshot snapshot =
          await _chatReference.child(chatKey).child('messages').get();
      return (snapshot.value as Map<dynamic, dynamic>).entries
          .map((entry) => Chat.fromMap(entry.value as Map<String, dynamic>))
          .toList();
    } else {
      DataSnapshot querySnapshot2 =
          await _chatReference.orderByChild('user2').equalTo(userId).limitToLast(1).get();

      if (querySnapshot2.value != null) {
        String chatKey = querySnapshot2.key!;
        DataSnapshot snapshot =
            await _chatReference.child(chatKey).child('messages').get();
        return (snapshot.value as Map<dynamic, dynamic>).entries
            .map((entry) => Chat.fromMap(entry.value as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    }
  }


  Future<void> updateChat(String user1, String user2, Chat updatedChat) async {
    List<String> mails = [user1, user2];
    mails.sort();
    DatabaseReference chatRef = _chatReference.child(mails.join('_')).child('messages').child(updatedChat.id);

    await chatRef.set({
      'text': updatedChat.text,
      'senderId' : updatedChat.senderId,
      'timestamp': updatedChat.timestamp?.millisecondsSinceEpoch,
      'isReply':updatedChat.isReply?.toMap(),
      'isSeen':updatedChat.isSeen,
      'id':updatedChat.id.toString(),
      'audio':updatedChat.audio,
      'image':updatedChat.image,
      'isDelivered':updatedChat.isDelivered,
      'isSent':updatedChat.isSent
    });
  }

  Future<void> deleteChat(String user1, String user2, Chat chat) async {
    List<String> mails = [user1, user2];
    mails.sort();
    DatabaseReference chatRef = _chatReference.child(mails.join('_')).child('messages').child(chat.id);
    await chatRef.remove();
  }
}

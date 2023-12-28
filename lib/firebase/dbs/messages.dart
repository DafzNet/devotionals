// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:devotionals/providers/chats.dart';
// import 'package:devotionals/utils/models/chat.dart';

// class ChatService {
//   final CollectionReference _chatCollection = FirebaseFirestore.instance.collection('chats');

//   void createChatDocument(String user1, String user2, Chat chat) async {
//     // Check for an existing document with the provided user1 and user2
//     List<String> mails = [user1, user2];
//     mails.sort();
//     QuerySnapshot querySnapshot = await _chatCollection
//         .where('user1', isEqualTo: mails[0])
//         .where('user2', isEqualTo: mails[1])
//         .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       // If a matching document is found, add the chat to its subcollection
//       String documentId = querySnapshot.docs.first.id;
//       await _chatCollection
//           .doc(documentId)
//           .collection('messages')
//           .add({'text': chat.text, 'senderId':chat.senderId, 'timestamp': FieldValue.serverTimestamp()});
//     } else {
//       // If no matching document is found, create a new document and add the chat
//       final docRef = await _chatCollection.add({
//         'user1': mails[0],
//         'user2': mails[1],
//       });

//       final subcollectionRef = docRef.collection('messages');
//       await subcollectionRef.add({'text': chat.text, 'senderId':chat.senderId, 'timestamp': FieldValue.serverTimestamp()});
//       print('Chat document created with ID: ${docRef.id}');
//     }
//   }


//   Stream<List<Chat>> getChats(String user1, String user2) {
//     List<String> mails = [user1, user2];
//     mails.sort();  
//     final query = _chatCollection
//         .where('user1', isEqualTo: mails[0])
//         .where('user2', isEqualTo: mails[1])  // Add orderBy clause for 'Timestamp'
//         .limit(1);

//     return query.snapshots().asyncMap<List<Chat>>((querySnapshot) async {
//       if (querySnapshot.docs.isNotEmpty) {
//         String documentId = querySnapshot.docs.first.id;
//         final subcollectionRef = _chatCollection.doc(documentId).collection('messages');
//         final snapshot = await subcollectionRef.get();  // Order by 'Timestamp' in the subcollection
//         List<Chat> messages = snapshot.docs.map((doc) => Chat.fromMap(doc.data() as Map<String, dynamic>)).toList();
//         ChatModelProvider().setChatMessages(messages);
//         return messages;
//       } else {
//         return [];
//       }
//     });
//   }

//   Future<List<Chat>> getChatsFuture(String userId) async {
//     final query = _chatCollection
//         .where('user1', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1);

//     final query2 = _chatCollection
//         .where('user2', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1);

//     final querySnapshot = await query.get();
//     if (querySnapshot.docs.isNotEmpty) {
//       String documentId = querySnapshot.docs.first.id;
//       final subcollectionRef = _chatCollection.doc(documentId).collection('messages');
//       final snapshot = await subcollectionRef.get();
//       return snapshot.docs.map((doc) => Chat.fromMap(doc.data() as Map<String, dynamic>)).toList();
//     } else {
//       final querySnapshot2 = await query2.get();
//       if (querySnapshot2.docs.isNotEmpty) {
//         String documentId = querySnapshot2.docs.first.id;
//         final subcollectionRef = _chatCollection.doc(documentId).collection('messages');
//         final snapshot = await subcollectionRef.get();
//         return snapshot.docs.map((doc) => Chat.fromMap(doc.data() as Map<String, dynamic>)).toList();
//       } else {
//         return [];
//       }
//     }
//   }


// Stream<List<String>> getChatsStream(String userId) {
//   final query = _chatCollection
//       .where('user1', isEqualTo: userId)
//       .limit(1);

//   final query2 = _chatCollection
//       .where('user2', isEqualTo: userId)
//       .limit(1);

//   return query.snapshots().asyncMap<List<String>>((querySnapshot) async {
//     if (querySnapshot.docs.isNotEmpty) {
//       String documentId = querySnapshot.docs.first.get('user2');
//       return [documentId];
//     } else {
//       final querySnapshot2 = await query2.get();
//       if (querySnapshot2.docs.isNotEmpty) {
//         String documentId = querySnapshot2.docs.first.get('user1');
//         return [documentId];
//       } else {
//         return [];
//       }
//     }
//   });
// }
// }







import 'package:firebase_database/firebase_database.dart';
import 'package:devotionals/providers/chats.dart';
import 'package:devotionals/utils/models/chat.dart';

class ChatService {
  final DatabaseReference _chatReference =
      FirebaseDatabase.instance.ref().child('chats');

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

    return buddiesRef.onValue.map<List<Map<String, dynamic>>>((event) {
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
        
        return data.map((e) => {
          'buddyId': e['buddyId'],
          'chat':Chat.fromMap(
            {
              'timestamp': e['timestamp'],
              'text': e['text'],
              'senderId': e['senderId']
            }
          )
        }
        ).toList();

      }

      return [];
   }
   
   );
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
          .push()
          .set({
            'text': chat.text,
            'senderId': chat.senderId,
            'timestamp': ServerValue.timestamp,
          });
    } else {
      // If no matching document is found, create a new document and add the chat
      DatabaseReference newChatRef = _chatReference.child(mails.join('_'));
      newChatRef.set({
        'user1': mails[0],
        'user2': mails[1],
      });

      DatabaseReference subcollectionRef = newChatRef.child('messages');
      subcollectionRef.push().set({
        'text': chat.text,
        'senderId': chat.senderId,
        'timestamp': ServerValue.timestamp,
      });

      print('Chat document created with ID: ${newChatRef.key}');
    }
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
          data.add(
            Map<String, dynamic>.from(l),
          );
        }

        List<Chat> messages = data
            .map((entry) =>
                Chat.fromMap(entry as Map<String, dynamic>))
            .toList();
        ChatModelProvider().setChatMessages(messages);
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
}

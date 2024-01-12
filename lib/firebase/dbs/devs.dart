import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/utils/models/comment.dart';

import '../../utils/models/models.dart';

class DevotionalService {
  final CollectionReference _devotionalCollection =
      FirebaseFirestore.instance.collection('devotionals');

  // Create
  Future<void> createDevotional(DevotionalModel devotional) async {
    await _devotionalCollection.doc(devotional.id).set(devotional.toMap());
  }

  // Read
  Future<DevotionalModel?> getLastDevotional() async {
    Query query = _devotionalCollection
        .orderBy('date', descending: true)
        .limit(1);

    QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      return DevotionalModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    } else {
      return null; // No devotional found
    }
  }

  // Read
  Future<List> getDevotionals({DocumentSnapshot? lastDocument}) async {
    Query query = _devotionalCollection
        .orderBy('date', descending: true)
        .limit(30);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot snapshot = await query.get();

    List<DevotionalModel> devotionals = snapshot.docs
        .map((doc) => DevotionalModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return [devotionals, snapshot.docs.isNotEmpty ? snapshot.docs.last : null];
  }

  // Delete
  Future<void> deleteDevotional(DevotionalModel dev) async {
    await _devotionalCollection.doc(dev.id).delete();
  }


  Future<void> updateDevotional(DevotionalModel dev) async {
    await _devotionalCollection.doc(dev.id).update(dev.toMap());
  }


    // Create Comment
  Future<void> createComment(String devotionalId, CommentModel comment) async {
    CollectionReference commentsCollection =
        _devotionalCollection.doc(devotionalId).collection('comments');

    await commentsCollection.add(comment.toMap());
  }

  // Read Comments (Load on Demand)
  Future<List<CommentModel>> getComments(String devotionalId) async {
    CollectionReference commentsCollection =
        _devotionalCollection.doc(devotionalId).collection('comments');

    QuerySnapshot snapshot = await commentsCollection.get();

    List<CommentModel> comments = snapshot.docs
        .map((doc) => CommentModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return comments;
  }

  // Reply to Comment
  Future<void> replyToComment(String devotionalId, String commentId, CommentModel reply) async {
    CollectionReference repliesCollection =
        _devotionalCollection.doc(devotionalId).collection('comments').doc(commentId).collection('replies');
    await repliesCollection.add(reply.toMap());
  }

  // Read Replies (Load on Demand)
  Future<List<CommentModel>> getReplies(String devotionalId, String commentId) async {
    CollectionReference repliesCollection =
        _devotionalCollection.doc(devotionalId).collection('comments').doc(commentId).collection('replies');

    QuerySnapshot snapshot = await repliesCollection.get();

    List<CommentModel> replies = snapshot.docs
        .map((doc) => CommentModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return replies;
  }
}

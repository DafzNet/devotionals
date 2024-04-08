import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/utils/models/comment.dart';
import 'package:devotionals/utils/models/prayerreq.dart';

class PrayerFire {
  final CollectionReference _prayerRequestCollection =
      FirebaseFirestore.instance.collection('prayerrequest');

  Future addPrayerRequest(PrayerRequest request) async {
    // Set the document ID explicitly
    await _prayerRequestCollection.doc(request.id.toString()).set(request.toMap());
  }

  Future<PrayerRequest?> getPrayerRequest(String requestId) async {
    final DocumentSnapshot docSnapshot =
        await _prayerRequestCollection.doc(requestId).get();

    if (docSnapshot.exists) {
      return PrayerRequest.fromMap(
          docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null; // Document with the given ID doesn't exist
    }
  }

  Future<List<PrayerRequest>> getPrayerRequests() async {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;

    final querySnapshot = await _prayerRequestCollection.orderBy('date', descending: true)
        .where('date', isGreaterThan: oneWeekAgo)
        // .where('waiting', isEqualTo: false)
        .get();

    return querySnapshot.docs
        .map((doc) =>
            PrayerRequest.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<PrayerRequest>> getPrayerRequestsAdmin() async {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;

    final querySnapshot = await _prayerRequestCollection.orderBy('date', descending: true)
        .where('date', isGreaterThan: oneWeekAgo)
        // .where('waiting', isEqualTo: true)
        .get();

    return querySnapshot.docs
        .map((doc) =>
            PrayerRequest.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }


  Stream<List<PrayerRequest>> getPrayerRequestsAdminStream() {
  final now = DateTime.now();
  final oneWeekAgo = now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;

  return _prayerRequestCollection.orderBy('date', descending: true)
      .where('date', isGreaterThan: oneWeekAgo)
      // .where('waiting', isEqualTo: true)
      .snapshots()
      .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) =>
                PrayerRequest.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
}


  Future<void> updatePrayerRequest(PrayerRequest request) async {
    await _prayerRequestCollection
        .doc(request.id.toString())
        .update(request.toMap());
  }



  

  Future<void> deletePrayerRequest(PrayerRequest request) async {
    await _prayerRequestCollection.doc(request.id.toString()).delete();
  }

  // Create Comment
  Future<void> createComment(String prayerRequestId, CommentModel comment) async {
    CollectionReference commentsCollection =
        _prayerRequestCollection.doc(prayerRequestId).collection('comments');
    await commentsCollection.doc(comment.id).set(comment.toMap());
  }

  // Update Comment
  Future<void> updateComment(String prayerRequestId, CommentModel comment) async {
    CollectionReference commentsCollection =
        _prayerRequestCollection.doc(prayerRequestId).collection('comments');
    await commentsCollection.doc(comment.id).update(comment.toMap());
  }

  // Read Comments
  Future<List<CommentModel>> getComments(String prayerRequestId) async {
    CollectionReference commentsCollection =
        _prayerRequestCollection.doc(prayerRequestId).collection('comments');

    QuerySnapshot snapshot = await commentsCollection.get();

    List<CommentModel> comments = snapshot.docs
        .map((doc) => CommentModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return comments;
  }

  // Delete Comment
  Future<void> deleteComment(String prayerRequestId, String commentId) async {
    CollectionReference commentsCollection =
        _prayerRequestCollection.doc(prayerRequestId).collection('comments');
    await commentsCollection.doc(commentId).delete();
  }
}

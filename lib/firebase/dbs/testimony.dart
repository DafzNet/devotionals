import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/utils/models/testimony_model.dart';

class TestimonyService{
  final CollectionReference _devotionalCollection =
      FirebaseFirestore.instance.collection('testimonies');

  // Create
  Future<void> createTestimony(TestimonyModel devotional) async {
    await _devotionalCollection.doc(devotional.id).set(devotional.toMap());
  }

  // Read
  Future<List> getTestimonies({DocumentSnapshot? lastDocument}) async {
    Query query = _devotionalCollection
        .orderBy('timestamp', descending: true)
        .limit(30);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot snapshot = await query.get();

    List<TestimonyModel> testimonies = snapshot.docs
        .map((doc) => TestimonyModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return [testimonies, snapshot.docs.isNotEmpty ? snapshot.docs.last : null];
  }


  // Delete
  Future<void> deleteTestimony(TestimonyModel dev) async {
    await _devotionalCollection.doc(dev.id).delete();
  }


  Future<void> updateTestimony(TestimonyModel dev) async {
    await _devotionalCollection.doc(dev.id).update(dev.toMap());
  }
}

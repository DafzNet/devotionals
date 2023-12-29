import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/models/models.dart';

class DevotionalService {
  final CollectionReference _devotionalCollection =
      FirebaseFirestore.instance.collection('devotionals');

  // Create
  Future<void> createDevotional(DevotionalModel devotional) async {
    await _devotionalCollection.doc(devotional.id).set(devotional.toMap());
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
}

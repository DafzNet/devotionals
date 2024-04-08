import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/utils/models/letters.dart';

class ApostleLettersFirestoreService {
  final CollectionReference _lettersCollection = FirebaseFirestore.instance.collection('apostle_letters');

  // Create operation
  Future<void> addLetter(Letters letter) async {
    try {
      await _lettersCollection.doc(letter.id.toString()).set(letter.toMap());
    } catch (e) {
      print('Error adding daily verse: $e');
    }
  }

  Future<void> updateLetter(Letters letter) async {
    try {
      await _lettersCollection.doc(letter.id.toString()).update(letter.toMap());
    } catch (e) {
      print('Error updating daily verse: $e');
    }
  }

  // Delete operation
  Future<void> deleteLetter(Letters letter) async {
    try {
      await _lettersCollection.doc(letter.id.toString()).delete();
    } catch (e) {
      print('Error deleting daily verse: $e');
    }
  }

  Future<List<Letters>> getAllLetters() async {
    try {
      final querySnapshot = await _lettersCollection.orderBy('date', descending: true).get();
      return querySnapshot.docs.map((doc) => Letters.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting all daily verses: $e');
      return [];
    }
  }

  // Get latest daily verse
  Future<Letters?> getLatestLetter() async {
    try {
      final querySnapshot = await _lettersCollection.orderBy('date', descending: true).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        return Letters.fromMap(querySnapshot.docs.first.data() as  Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting latest daily verse: $e');
      return null;
    }
  }
}

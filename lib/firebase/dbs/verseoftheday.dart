import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/utils/models/dailyverse.dart';

class VerseofDayFirestoreService {
  final CollectionReference _dailyVersesCollection = FirebaseFirestore.instance.collection('daily_verses');

  // Create operation
  Future<void> addDailyVerse(DailyVerse verse) async {
    try {
      await _dailyVersesCollection.doc(verse.id.toString()).set(verse.toMap());
    } catch (e) {
      print('Error adding daily verse: $e');
    }
  }

  Future<void> updateDailyVerse(DailyVerse verse) async {
    try {
      await _dailyVersesCollection.doc(verse.id.toString()).update(verse.toMap());
    } catch (e) {
      print('Error updating daily verse: $e');
    }
  }

  // Delete operation
  Future<void> deleteDailyVerse(DailyVerse verse) async {
    try {
      await _dailyVersesCollection.doc(verse.id.toString()).delete();
    } catch (e) {
      print('Error deleting daily verse: $e');
    }
  }

Future<List<DailyVerse>> getAllDailyVerses() async {
  try {
    final currentDate = DateTime.now().millisecondsSinceEpoch;
    final querySnapshot = await _dailyVersesCollection.where('date', isLessThanOrEqualTo: currentDate).orderBy('date', descending: true).get();
    return querySnapshot.docs.map((doc) => DailyVerse.fromMap(doc.data() as Map<String, dynamic>)).toList();
  } catch (e) {
    print('Error getting all daily verses: $e');
    return [];
  }
}


  // Get latest daily verse
  Future<DailyVerse?> getLatestDailyVerse() async {
    try {
      final querySnapshot = await _dailyVersesCollection.orderBy('date', descending: true).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        return DailyVerse.fromMap(querySnapshot.docs.first.data() as  Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting latest daily verse: $e');
      return null;
    }
  }
}

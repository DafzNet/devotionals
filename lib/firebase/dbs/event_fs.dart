import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/models/event.dart';

class VerseofDayFirestoreService {
  final CollectionReference _eventCollection = FirebaseFirestore.instance.collection('events');

  // Create operation
  Future<void> addDailyVerse(EventModel event) async {
    try {
      await _eventCollection.doc(event.id.toString()).set(event.toMap());
    } catch (e) {
      print('Error adding daily verse: $e');
    }
  }

  Future<void> updateDailyVerse(EventModel event) async {
    try {
      await _eventCollection.doc(event.id.toString()).update(event.toMap());
    } catch (e) {
      print('Error updating daily verse: $e');
    }
  }

  // Delete operation
  Future<void> deleteDailyVerse(EventModel event) async {
    try {
      await _eventCollection.doc(event.id.toString()).delete();
    } catch (e) {
      print('Error deleting daily verse: $e');
    }
  }

  Future<List<EventModel>> getAllDailyVerses() async {
    try {
      final querySnapshot = await _eventCollection.get();
      return querySnapshot.docs.map((doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting all daily verses: $e');
      return [];
    }
  }

  // Get latest daily verse
  Future<EventModel?> getLatestDailyVerse() async {
    try {
      final querySnapshot = await _eventCollection.orderBy('startdDate', descending: true).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        return EventModel.fromMap(querySnapshot.docs.first.data() as  Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting latest daily verse: $e');
      return null;
    }
  }
}

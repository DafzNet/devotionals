import 'package:devotionals/utils/models/note_model.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';


class NoteRepository {
  final Database _database;
  final StoreRef<int, Map<String, dynamic>> _store =
      intMapStoreFactory.store('notes');

  NoteRepository(
    this._database
  );

  Future insertNote(Note note) async {
    await _store.add(_database, note.toMap());
  }

  Future<void> updateNote(Note note) async {
    final finder = Finder(filter: Filter.equals('id', note.id));
    await _store.update(_database, note.toMap(), finder: finder);
  }

  Future<void> deleteNoteByNoteId(Note note) async {
    final finder = Finder(filter: Filter.equals('id', note.id));
    await _store.delete(_database, finder: finder);
  }

  Future<List<Note>> getAllNotes({String? cat}) async {
    final records = cat != null ?  await _store.find(_database, finder: Finder(filter: Filter.equals('category', cat))):await _store.find(_database);

    return records.map((record) => Note.fromMap(record.value)).toList(growable: false);
  }

  Stream<List<Note>> getNotesStream() {
    final snapshots = _store.query().onSnapshots(_database);
    return snapshots.map(
      (List<RecordSnapshot<int, Map<String, dynamic>>> snapshots) {
        return snapshots
            .map((snapshot) => Note.fromMap(snapshot.value))
            .toList(growable: false);
      },
    );
  }

  // Search notes based on any attribute
  Future<List<Note>> searchNotesByAttribute(String attribute, dynamic value) async {
    final finder = Finder(filter: Filter.equals(attribute, value));
    final records = await _store.find(_database, finder: finder);
    return records.map((record) => Note.fromMap(record.value)).toList();
  }

  Stream<List<Note>> getDateStream(DateTime date) {
    final finder = Finder(filter: Filter.equals('date', date.toIso8601String()));
    return _store
        .query(finder: finder)
        .onSnapshots(_database)
        .map((snapshots) => snapshots.map((snapshot) => Note.fromMap(snapshot.value)).toList());
  }

  Stream<List<Note>> getTagsStream(List<String> tags) {
    final finder = Finder(filter: Filter.equals('tags', tags));
    return _store
        .query(finder: finder)
        .onSnapshots(_database)
        .map((snapshots) => snapshots.map((snapshot) => Note.fromMap(snapshot.value)).toList());
  }

  Stream<List<Note>> getCategoryStream(String category) {
    final finder = Finder(filter: Filter.equals('category', category));
    return _store
        .query(finder: finder)
        .onSnapshots(_database)
        .map((snapshots) => snapshots.map((snapshot) => Note.fromMap(snapshot.value)).toList());
  }

}

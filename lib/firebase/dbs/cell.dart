import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/utils/models/cell.dart';

class CellFire {
  final CollectionReference _cellsCollection =
      FirebaseFirestore.instance.collection('cells');

  Future<void> addCell(CellModel cell) async {
    await _cellsCollection.doc(cell.id.toString()).set(cell.toMap());
  }

  Future<CellModel?> getCell(String cellId) async {
    final DocumentSnapshot docSnapshot = await _cellsCollection.doc(cellId).get();

    if (docSnapshot.exists) {
      return CellModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null; // Document with the given ID doesn't exist
    }
  }

  Future<List<CellModel>> getCells() async {
    final querySnapshot = await _cellsCollection.get();
    return querySnapshot.docs
        .map((doc) => CellModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateCell(CellModel cell) async {
    await _cellsCollection.doc(cell.id).update(cell.toMap());
  }

  Future<void> deleteCell(CellModel cell) async {
    await _cellsCollection.doc(cell.id.toString()).delete();
  }
}

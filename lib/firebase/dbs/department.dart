import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/utils/models/department.dart';

class DepartmentFire {
  final CollectionReference _depsCollection =
      FirebaseFirestore.instance.collection('departments');

  Future addDepartment(DepartmentModel dep) async {
    // Set the document ID explicitly
    await _depsCollection.doc(dep.id.toString()).set(dep.toMap());
  }

  Future<DepartmentModel?> getDepartment(String depId) async {
    final DocumentSnapshot docSnapshot = await _depsCollection.doc(depId).get();

    if (docSnapshot.exists) {
      return DepartmentModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null; // Document with the given ID doesn't exist
    }
  }

  Future<List<DepartmentModel>> getDepartments() async {
    final querySnapshot = await _depsCollection.get();
    return querySnapshot.docs
        .map((doc) => DepartmentModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateDepartment(DepartmentModel dep) async {
    await _depsCollection.doc(dep.id).update(dep.toMap());
  }

  Future<void> deleteDepartment(DepartmentModel dep) async {
    await _depsCollection.doc(dep.id.toString()).delete();
  }
}

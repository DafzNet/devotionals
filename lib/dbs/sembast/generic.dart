import 'dart:convert';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DataStore {
  Database? _database;
  final String storeName;

  DataStore(this.storeName);

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }

  Future<Database> initDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'cric_sembast.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }

  StoreRef<int, Map<String, dynamic>> get store =>
      intMapStoreFactory.store(storeName);

  Future insert(String key, Map<String, dynamic> data) async {
    await store.record(key.hashCode).add(await database, data);
  }

  Future<void> insertList(String key, List<Map<String, dynamic>> dataList) async {
    final dataAsString = jsonEncode(dataList);
    await store.record(key.hashCode).put(await database, {'data':dataAsString});
  }

  Future<List<Map<String, dynamic>>?> getList(String key) async {
    final storedData = await store.record(key.hashCode).get(await database);
    
    if (storedData != null) {
      final decodedData = jsonDecode(storedData['data']) as List<dynamic>;
      // print(decodedData);
      return decodedData.cast<Map<String, dynamic>>();
      
    }

    

    return [];
  }

  Future<void> update(Map<String, dynamic> data, String key) async {
    await store.record(key.hashCode).update(await database, data);
  }

  Future<void> delete(String key) async {
    await store.record(key.hashCode).delete(await database);
  }

  Future<bool> containsKey(String key) async {
    final result = await store.record(key.hashCode).exists(await database);
    return result;
  }

  Future<Map<String, dynamic>?> get(String key) async {
    final result = store.record(key.hashCode);
    return await result.get(await database);
  }
}

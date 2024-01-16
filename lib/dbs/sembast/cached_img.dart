
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DatabaseHelper {
  Database? _database;

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

  String _getKeyFromUrl(String url) {
    // You can use a hash function or any method to convert the URL to a unique integer key.
    // For simplicity, we'll use a basic hash function here.
    return url.hashCode.toString();
  }
Future<void> saveImage(String url, List<int> imageData, int expiryTimestamp) async {
    final store = intMapStoreFactory.store('images');
    final key = _getKeyFromUrl(url);
    final record = store.record(int.parse(key));

    await (await database).transaction((txn) async {
      await record.put(txn, {'data': imageData, 'expiryTimestamp': expiryTimestamp});
    });
  }

  Future<List<int>?> getImage(String url) async {
    final store = intMapStoreFactory.store('images');
    final key = _getKeyFromUrl(url);
    final record = store.record(int.parse(key));

    final snapshot = await record.getSnapshot(await database);

    if (snapshot != null) {
      final storedData = snapshot.value;

      if (storedData.isNotEmpty) {
        final List<int> imageData = List<int>.from(storedData['data'] as List);
        final int expiryTimestamp = storedData['expiryTimestamp'] as int;

        // Check if the cached image is still valid based on expiry time
        if (DateTime.now().millisecondsSinceEpoch < expiryTimestamp) {
          return imageData;
        } else {
          // Image has expired, remove it from the cache
          await record.delete(await database);
        }
      }
    }

    return null;
  }

}

import 'package:devotionals/utils/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class UserRepo {
  Database? _database;
  final StoreRef<int, Map<String, dynamic>> _store =
      intMapStoreFactory.store('users');

  UserRepo();

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

  Future insert(User user) async {
    final expiryTimestamp = DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch;
    final userWithExpiry = {
      ...user.toMap(),
      'expiryTimestamp': expiryTimestamp,
    };
    await _store.add(await database, userWithExpiry);
  }

  Future<void> update(User user) async {
    final finder = Finder(filter: Filter.equals('userID', user.userID));
    await _store.update(await database, user.toMap(), finder: finder);
  }

  Future<void> delete(User user) async {
    final finder = Finder(filter: Filter.equals('userID', user.userID));
    await _store.delete(await database, finder: finder);
  }

  Future<User?> get(String id) async {
    final finder = Finder(filter: Filter.equals('userID', id));
    final userRecords = await _store.find(await database, finder: finder);

    if (userRecords.isNotEmpty) {
      final userMap = userRecords.first.value;
      final expiryTimestamp = userMap['expiryTimestamp'] as int?;

      if (expiryTimestamp != null && expiryTimestamp < DateTime.now().millisecondsSinceEpoch) {
        // User has expired, delete the user
        await delete(User.fromMap(userMap));
        return null;
      }

      return User.fromMap(userMap);
    }

    return null;
  }


  Future<bool> containsKey(String id) async {
    final finder = Finder(filter: Filter.equals('userID', id));
    final user = await _store.find(await database, finder: finder);

    if (user.isNotEmpty) {
      final expiryTimestamp = user.first['expiryTimestamp'] as int?;
      if (expiryTimestamp != null && expiryTimestamp < DateTime.now().millisecondsSinceEpoch) {
        // User has expired, delete the user
        await delete(User.fromMap(user.first.value));
        return false;
      }
      return true;
    }

    return false;
  }

  Future<List<User>> getAllUser() async {
    final records = await _store.find(await database);

    return records.map((record) => User.fromMap(record.value)).toList(growable: false);
  }
}

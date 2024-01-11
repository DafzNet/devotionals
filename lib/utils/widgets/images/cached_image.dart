import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CachedNetworkImage extends StatefulWidget {
  final String imageUrl;

  const CachedNetworkImage({required this.imageUrl});

  @override
  _CachedNetworkImageState createState() => _CachedNetworkImageState();
}

class _CachedNetworkImageState extends State<CachedNetworkImage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>?>(
      future: _databaseHelper.getImage(widget.imageUrl),
      builder: (context, snapshot) {
      
        if (snapshot.connectionState == ConnectionState.waiting) {
    
          return Center(child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator()));
        } else if (snapshot.data != null) {
          final Uint8List imageData = Uint8List.fromList(snapshot.data!);
          return Image.memory(imageData);
        } else {
          return Column(
            children: [
              _fetchAndCacheImage(),
            ],
          );
        }
      },
    );
  }

  Widget _fetchAndCacheImage() {
    return FutureBuilder<http.Response>(
      future: http.get(Uri.parse(widget.imageUrl)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final imageData = snapshot.data!.bodyBytes;
          _databaseHelper.saveImage(widget.imageUrl, imageData);
          return Image.memory(Uint8List.fromList(imageData), fit: BoxFit.cover,);
        }
      },
    );
  }
}



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
    final dbPath = join(appDocumentDir.path, 'your_database_name.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }

  String _getKeyFromUrl(String url) {
    // You can use a hash function or any method to convert the URL to a unique integer key.
    // For simplicity, we'll use a basic hash function here.
    return url.hashCode.toString();
  }

  Future<void> saveImage(String url, List<int> imageData) async {
    final store = intMapStoreFactory.store('images');
    final key = _getKeyFromUrl(url);
    final record = store.record(int.parse(key));

    await (await database).transaction((txn) async {
      await record.put(txn, {'data': imageData});
    });
  }

  Future<List<int>?> getImage(String url) async {
    final store = intMapStoreFactory.store('images');
    final key = _getKeyFromUrl(url);
    final record = store.record(int.parse(key));

    final snapshot = await record.getSnapshot(await database);
    final newSnapshot  = snapshot!.value;


    if (newSnapshot.isNotEmpty) {
      return List<int>.from(newSnapshot['data'] as List);
    }

    return null;
  }
}

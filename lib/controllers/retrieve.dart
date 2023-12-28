
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';



class BibleReader {
  late List<List<dynamic>> _bibleData;

  Future<List<List<dynamic>>> loadBibleData(String csvPath) async {
    
    _bibleData = const CsvToListConverter(
      eol: '\n',
    ).convert(csvPath);
    return _bibleData;
  }

}


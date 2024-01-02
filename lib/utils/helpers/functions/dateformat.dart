import 'package:devotionals/utils/helpers/functions/ordinal.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  String dayOfMonth = DateFormat('d').format(date);

  // Add ordinal indicator
  String formattedDay = addOrdinalIndicator(dayOfMonth);

  String monthYear = DateFormat('MMMM y').format(date);

  return '$formattedDay $monthYear';
}
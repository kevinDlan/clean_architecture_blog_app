import 'package:intl/intl.dart';

String formatDateBydMMYYY(DateTime dateTime) {
  return DateFormat('d MMM, yyyy').format(dateTime);
}

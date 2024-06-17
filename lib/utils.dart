import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => 'Ksh ${price.toStringAsFixed(2)}';
  // static formatDate(DateTime date) => DateFormat.yMd().format(date);
  static formatDate(DateTime date) =>
      DateFormat('EEE, MMM d yyyy').format(date);

  static int rowCountPerPage(invoices) {
    return invoices.isEmpty ? 1 : (invoices.length > 5 ? 5 : invoices.length);
  }
}

import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _ugxFormat = NumberFormat('#,##0', 'en_US');

  /// Formats amount to Ugandan Shillings e.g. "UGX 3,500"
  static String formatUGX(num amount) {
    return 'UGX ${_ugxFormat.format(amount)}';
  }
}

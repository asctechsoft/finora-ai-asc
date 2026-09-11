import 'package:intl/intl.dart';
import '../models/ui_models/currency_info.dart';

class Money {
  Money._();

  /// e.g. 1280 USD -> "$1,280"; 23.5 -> "$23.50" only when it has cents.
  static String format(double amount, String currencyCode, {bool decimals = false}) {
    final info = CurrencyInfo.byCode(currencyCode);
    final hasCents = decimals || amount % 1 != 0;
    final pattern = hasCents ? '#,##0.00' : '#,##0';
    final formatted = NumberFormat(pattern).format(amount.abs());
    return '${info.symbol}$formatted';
  }

  /// Signed display: "+$5,000" / "-$1,500".
  static String signed(double amount, String currencyCode) {
    final sign = amount < 0 ? '-' : '+';
    return '$sign${format(amount, currencyCode)}';
  }

  static String compact(double amount, String currencyCode) {
    final info = CurrencyInfo.byCode(currencyCode);
    return '${info.symbol}${NumberFormat.compact().format(amount)}';
  }
}

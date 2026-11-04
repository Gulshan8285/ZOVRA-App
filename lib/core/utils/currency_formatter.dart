import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: 0,
    locale: 'en_IN',
  );

  static String format(num amount) {
    return _formatter.format(amount);
  }

  static String formatWithoutSymbol(num amount) {
    return NumberFormat.decimalPattern('en_IN').format(amount);
  }
}


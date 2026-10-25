class AppFormatters {
  AppFormatters._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// "23 Feb 2026"
  static String date(DateTime dt) {
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
  }

  /// "23/02/2026"
  static String dateShort(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  /// "09:30 AM"
  static String time(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')} $period';
  }

  /// "09:30"
  static String time24(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  /// "₹ 500.00"
  static String currency(double amount) {
    return '₹ ${amount.toStringAsFixed(2)}';
  }

  /// "₹ 500"
  static String currencyShort(double amount) {
    return '₹ ${amount.toStringAsFixed(0)}';
  }
}

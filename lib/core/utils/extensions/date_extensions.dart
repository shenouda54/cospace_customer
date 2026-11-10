import 'package:intl/intl.dart';

/// Date formatting extensions.
extension DateExtensions on DateTime {
  /// Formats as `YYYY-MM-DD` for Firestore storage.
  String toFirestoreDate() => DateFormat('yyyy-MM-dd').format(this);

  /// Formats as a readable date like `June, 9th`.
  String toReadableDate() => DateFormat('MMMM, d').format(this);

  /// Formats as `dd/MM/yyyy` for display.
  String toDisplayDate() => DateFormat('dd/MM/yyyy').format(this);
}

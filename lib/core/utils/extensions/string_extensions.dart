/// String utility extensions.
extension StringExtensions on String {
  /// Capitalizes the first letter.
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Whether the string is a valid email format.
  bool get isValidEmail => RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(this);

  /// Whether the string is a strong password (min 6 chars).
  bool get isValidPassword => length >= 6;

  /// Whether the string is a phone number with 8 to 15 digits.
  bool get isValidPhone {
    final digits = replaceAll(RegExp(r'\D'), '');
    return digits.length >= 8 && digits.length <= 15;
  }
}

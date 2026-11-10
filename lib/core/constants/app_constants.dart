/// Domain-level constants shared across the Customer App.
abstract final class AppConstants {
  /// Maximum number of seats a customer can book per room.
  static const int maxSeatsPerRoom = 6;

  /// Minimum number of seats for a booking.
  static const int minSeatsPerRoom = 1;

  /// The five fixed daily time slots available for booking.
  static const List<String> dailyFixedTimeSlots = [
    '09:00',
    '11:00',
    '13:00',
    '15:00',
    '17:00',
  ];

  /// Firestore collection names.
  static const String usersCollection = 'users';
  static const String categoriesCollection = 'categories';
  static const String venuesCollection = 'venues';
  static const String reservationsCollection = 'reservations';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CoSpace';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get searchByVenueName => 'Search by venue name...';

  @override
  String get categories => 'Categories';

  @override
  String get venues => 'Venues';

  @override
  String get venueDetails => 'Venue Details';

  @override
  String get rooms => 'Rooms';

  @override
  String get description => 'Description';

  @override
  String get location => 'Location';

  @override
  String get bookNow => 'Book Now';

  @override
  String get amountOfGuests => 'Amount of guests';

  @override
  String get reservationDate => 'Reservation date';

  @override
  String get availableTimeSlots => 'Available time slots';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get bookingSuccess => 'Booking confirmed successfully!';

  @override
  String get bookingFailed => 'Booking failed. This slot may have been taken.';

  @override
  String get slotAlreadyBooked => 'This time slot is already booked.';

  @override
  String get noResultsFound => 'No results found.';

  @override
  String get noVenuesAvailable => 'No venues available in this category.';

  @override
  String get seats => 'Seats';

  @override
  String get selected => 'Selected';

  @override
  String get available => 'Available';

  @override
  String get booked => 'Booked';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get logout => 'Logout';

  @override
  String get maxSeatsReached => 'Maximum 6 seats allowed.';

  @override
  String get minSeatsReached => 'Minimum 1 seat required.';

  @override
  String get loginRequired => 'Please login to continue.';

  @override
  String get invalidCredentials => 'Invalid email or password.';

  @override
  String get registrationSuccess => 'Account created successfully!';

  @override
  String get selectRoom => 'Select a room';

  @override
  String get selectDate => 'Select a date';

  @override
  String get selectTimeSlot => 'Select a time slot';

  @override
  String get skipLogin => 'Skip (Demo / Test Mode)';
}

import 'package:flutter_test/flutter_test.dart';
import 'package:cospace_customer/features/reservation/model/booking_model.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';

void main() {
  group('BookingModel', () {
    test('uniqueSlotLockId locks one room, date, and time', () {
      const booking = BookingModel(
        id: 'res_1',
        venueId: 'venue_123',
        venueName: 'Workspace Hub',
        customerId: 'cust_456',
        roomNumber: 2,
        seatsCount: 4,
        date: '2026-06-09',
        timeSlot: '09:00',
      );

      expect(
        booking.uniqueSlotLockId,
        'venue_123_room2_2026-06-09_09:00',
      );
    });

    test('toJson and fromJson keep the shared booking fields', () {
      final json = {
        'id': 'res_1',
        'venueId': 'venue_123',
        'venueName': 'Workspace Hub',
        'customerId': 'cust_456',
        'roomNumber': 3,
        'seatsCount': 6,
        'date': '2026-06-09',
        'timeSlot': '13:00',
      };

      final model = BookingModel.fromJson(json);
      expect(model.roomNumber, 3);
      expect(model.seatsCount, 6);
      expect(model.date, '2026-06-09');
      expect(model.timeSlot, '13:00');
      expect(model.toJson(), json);
    });

    test('AppConstants constraints are verified', () {
      expect(AppConstants.maxSeatsPerRoom, 6);
      expect(AppConstants.minSeatsPerRoom, 1);
      expect(AppConstants.bookingsCollection, 'bookings');
      expect(AppConstants.dailyFixedTimeSlots, [
        '09:00',
        '11:00',
        '13:00',
        '15:00',
        '17:00',
      ]);
    });
  });
}

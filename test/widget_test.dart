import 'package:flutter_test/flutter_test.dart';
import 'package:cospace_customer/features/reservation/model/reservation_model.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';

void main() {
  group('ReservationModel Tests', () {
    test('uniqueSlotLockId creates correct composite key', () {
      const reservation = ReservationModel(
        id: 'res_1',
        venueId: 'venue_123',
        venueName: 'Workspace Hub',
        customerId: 'cust_456',
        roomNumber: 2,
        seatsCount: 4,
        reservationDate: '2026-11-10',
        timeSlot: '09:00',
      );

      expect(
        reservation.uniqueSlotLockId,
        'venue_123_room2_2026-11-10_09:00',
      );
    });

    test('toJson and fromJson work correctly', () {
      final json = {
        'id': 'res_1',
        'venueId': 'venue_123',
        'venueName': 'Workspace Hub',
        'customerId': 'cust_456',
        'roomNumber': 3,
        'seatsCount': 6,
        'reservationDate': '2026-11-10',
        'timeSlot': '13:00',
      };

      final model = ReservationModel.fromJson(json);
      expect(model.roomNumber, 3);
      expect(model.seatsCount, 6);
      expect(model.timeSlot, '13:00');
      expect(model.toJson(), json);
    });

    test('AppConstants constraints are verified', () {
      expect(AppConstants.maxSeatsPerRoom, 6);
      expect(AppConstants.minSeatsPerRoom, 1);
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

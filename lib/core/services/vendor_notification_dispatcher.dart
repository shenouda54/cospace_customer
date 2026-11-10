import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cospace_customer/core/services/firebase_service.dart';

/// Dispatches a notification event to the Vendor app upon successful booking.
class VendorNotificationDispatcher {
  VendorNotificationDispatcher._();
  static final VendorNotificationDispatcher instance =
      VendorNotificationDispatcher._();

  /// Writes a notification document that the Vendor app listens to.
  Future<void> dispatchBookingNotification({
    required String venueId,
    required String venueName,
    required String customerName,
    required int roomNumber,
    required String reservationDate,
    required String timeSlot,
  }) async {
    if (!FirebaseService.instance.isInitialized) return;

    try {
      await FirebaseService.instance.firestore
          .collection('vendor_notifications')
          .add({
        'venueId': venueId,
        'venueName': venueName,
        'customerName': customerName,
        'roomNumber': roomNumber,
        'reservationDate': reservationDate,
        'timeSlot': timeSlot,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (_) {}
  }
}

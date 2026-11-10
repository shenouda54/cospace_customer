import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';

/// Centralized Firebase references.
/// All Firestore and Auth access goes through this service.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  /// Checks if Firebase has been initialized successfully.
  bool get isInitialized {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Current authenticated user, or null if not signed in or not initialized.
  User? get currentUser {
    if (!isInitialized) return null;
    try {
      return auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  /// Whether a user session is active.
  bool get isAuthenticated => currentUser != null;

  // ── Collection References ──

  CollectionReference<Map<String, dynamic>> get usersRef =>
      firestore.collection(AppConstants.usersCollection);

  CollectionReference<Map<String, dynamic>> get categoriesRef =>
      firestore.collection(AppConstants.categoriesCollection);

  CollectionReference<Map<String, dynamic>> get venuesRef =>
      firestore.collection(AppConstants.venuesCollection);

  CollectionReference<Map<String, dynamic>> get reservationsRef =>
      firestore.collection(AppConstants.reservationsCollection);
}

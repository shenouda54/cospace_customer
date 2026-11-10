import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';

/// Centralized Firebase references.
/// All Firestore and Auth access goes through this service.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Current authenticated user, or null if not signed in.
  User? get currentUser => auth.currentUser;

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

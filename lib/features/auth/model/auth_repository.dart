import 'package:cospace_customer/core/services/firebase_service.dart';
import 'package:cospace_customer/core/storage/secure_storage_helper.dart';
import 'package:cospace_customer/core/storage/local_keys.dart';
import 'package:cospace_customer/features/auth/model/customer_user_model.dart';

/// Repository handling all authentication operations for the customer.
class AuthRepository {
  final _firebase = FirebaseService.instance;

  /// Register a new customer account.
  Future<CustomerUserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final credential = await _firebase.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = CustomerUserModel(
      uid: credential.user!.uid,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );

    // Save user profile to Firestore
    await _firebase.usersRef.doc(user.uid).set(user.toJson());

    // Persist session securely
    await _persistSession(user);

    return user;
  }

  /// Sign in an existing customer.
  Future<CustomerUserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebase.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _firebase.usersRef.doc(credential.user!.uid).get();
    final user = CustomerUserModel.fromJson(doc.data()!);

    // Persist session securely
    await _persistSession(user);

    return user;
  }

  /// Sign out the current customer.
  Future<void> logout() async {
    await _firebase.auth.signOut();
    await SecureStorageHelper.clearAll();
  }

  /// Check if a user session exists.
  Future<bool> isLoggedIn() async {
    final token = await SecureStorageHelper.read(key: AppLocalKeys.userToken);
    return token != null && _firebase.isAuthenticated;
  }

  /// Persist user session data securely.
  Future<void> _persistSession(CustomerUserModel user) async {
    final token = await _firebase.currentUser?.getIdToken();
    if (token != null) {
      await SecureStorageHelper.write(
        key: AppLocalKeys.userToken,
        value: token,
      );
    }
    await SecureStorageHelper.write(
      key: AppLocalKeys.userId,
      value: user.uid,
    );
    await SecureStorageHelper.write(
      key: AppLocalKeys.userEmail,
      value: user.email,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cospace_customer/core/services/firebase_service.dart';
import 'package:cospace_customer/core/storage/local_keys.dart';
import 'package:cospace_customer/core/storage/secure_storage_helper.dart';
import 'package:cospace_customer/core/utils/extensions/string_extensions.dart';
import 'package:cospace_customer/features/auth/model/auth_failure.dart';
import 'package:cospace_customer/features/auth/model/customer_user_model.dart';

/// Repository handling all authentication operations for the customer.
class AuthRepository {
  AuthRepository({FirebaseService? firebase})
      : _firebase = firebase ?? FirebaseService.instance;

  final FirebaseService _firebase;

  /// Register a new customer account.
  Future<CustomerUserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) {
    return _guard(() async {
      final normalizedName = fullName.trim();
      final normalizedEmail = email.trim();
      final normalizedPhone = phoneNumber.trim();
      _validateRegistration(
        fullName: normalizedName,
        email: normalizedEmail,
        password: password,
        phoneNumber: normalizedPhone,
      );

      if (!_firebase.isInitialized) {
        final user = CustomerUserModel(
          uid: 'local_${DateTime.now().millisecondsSinceEpoch}',
          fullName: normalizedName,
          email: normalizedEmail,
          phoneNumber: normalizedPhone,
        );
        await _persistSession(user);
        return user;
      }

      final credential = await _firebase.auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = CustomerUserModel(
        uid: credential.user!.uid,
        fullName: normalizedName,
        email: normalizedEmail,
        phoneNumber: normalizedPhone,
      );

      await _firebase.usersRef.doc(user.uid).set(user.toJson());
      await credential.user?.updateDisplayName(normalizedName);
      await _persistSession(user);
      return user;
    });
  }

  /// Sign in an existing customer.
  Future<CustomerUserModel> login({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final normalizedEmail = email.trim();
      _validateLogin(email: normalizedEmail, password: password);

      if (!_firebase.isInitialized) {
        final storedEmail =
            await SecureStorageHelper.read(key: AppLocalKeys.userEmail);
        final storedId =
            await SecureStorageHelper.read(key: AppLocalKeys.userId);
        if (storedEmail != null &&
            storedId != null &&
            storedEmail.toLowerCase() != normalizedEmail.toLowerCase()) {
          throw const AuthFailure(AuthFailureCode.invalidCredentials);
        }

        final user = CustomerUserModel(
          uid: storedId ?? 'local_${normalizedEmail.hashCode}',
          fullName: await SecureStorageHelper.read(
                key: AppLocalKeys.userFullName,
              ) ??
              normalizedEmail,
          email: normalizedEmail,
          phoneNumber: await SecureStorageHelper.read(
                key: AppLocalKeys.userPhone,
              ) ??
              '',
        );
        await _persistSession(user);
        return user;
      }

      final credential = await _firebase.auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final uid = credential.user!.uid;
      final doc = await _firebase.usersRef.doc(uid).get();
      final data = doc.data();

      final user = data == null
          ? CustomerUserModel(
              uid: uid,
              fullName: credential.user?.displayName ?? '',
              email: credential.user?.email ?? normalizedEmail,
              phoneNumber: '',
            )
          : CustomerUserModel.fromJson(data);

      if (data == null) {
        await _firebase.usersRef.doc(uid).set(user.toJson());
      }

      await _persistSession(user);
      return user;
    });
  }

  /// Sign out the current customer and clear the secure session.
  Future<void> logout() async {
    if (_firebase.isInitialized) {
      try {
        await _firebase.auth.signOut();
      } on FirebaseAuthException {
        // Local session is still cleared so the customer cannot stay signed in.
      }
    }
    await SecureStorageHelper.clearAll();
  }

  /// Restore a customer from Firebase Auth, or from secure storage when Firebase
  /// is not configured.
  Future<CustomerUserModel?> restoreSession() async {
    if (_firebase.isInitialized) {
      final current = _firebase.currentUser;
      if (current == null) return null;

      final doc = await _firebase.usersRef.doc(current.uid).get();
      final data = doc.data();
      final user = data == null
          ? CustomerUserModel(
              uid: current.uid,
              fullName: current.displayName ?? '',
              email: current.email ?? '',
              phoneNumber: '',
            )
          : CustomerUserModel.fromJson(data);
      await _persistSession(user);
      return user;
    }

    final token = await SecureStorageHelper.read(key: AppLocalKeys.userToken);
    final uid = await SecureStorageHelper.read(key: AppLocalKeys.userId);
    final email = await SecureStorageHelper.read(key: AppLocalKeys.userEmail);
    if (token == null || uid == null || email == null) return null;

    return CustomerUserModel(
      uid: uid,
      fullName:
          await SecureStorageHelper.read(key: AppLocalKeys.userFullName) ?? '',
      email: email,
      phoneNumber:
          await SecureStorageHelper.read(key: AppLocalKeys.userPhone) ?? '',
    );
  }

  void _validateLogin({
    required String email,
    required String password,
  }) {
    if (!email.isValidEmail) {
      throw const AuthFailure(AuthFailureCode.invalidEmail);
    }
    if (!password.isValidPassword) {
      throw const AuthFailure(AuthFailureCode.weakPassword);
    }
  }

  void _validateRegistration({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) {
    if (fullName.isEmpty) {
      throw const AuthFailure(AuthFailureCode.emptyName);
    }
    _validateLogin(email: email, password: password);
    if (!phoneNumber.isValidPhone) {
      throw const AuthFailure(AuthFailureCode.invalidPhone);
    }
  }

  Future<void> _persistSession(CustomerUserModel user) async {
    String? token;
    final current = _firebase.currentUser;
    if (_firebase.isInitialized && current != null) {
      token = await current.getIdToken();
    }

    await SecureStorageHelper.write(
      key: AppLocalKeys.userToken,
      value: token ?? 'local_session_${user.uid}',
    );
    await SecureStorageHelper.write(
      key: AppLocalKeys.userId,
      value: user.uid,
    );
    await SecureStorageHelper.write(
      key: AppLocalKeys.userEmail,
      value: user.email,
    );
    await SecureStorageHelper.write(
      key: AppLocalKeys.userFullName,
      value: user.fullName,
    );
    await SecureStorageHelper.write(
      key: AppLocalKeys.userPhone,
      value: user.phoneNumber,
    );
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(AuthFailureCode.fromFirebase(error.code));
    } on FirebaseException catch (error) {
      throw AuthFailure(AuthFailureCode.fromFirebase(error.code));
    } catch (_) {
      throw const AuthFailure(AuthFailureCode.unknown);
    }
  }
}

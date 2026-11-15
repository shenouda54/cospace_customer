import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/features/auth/model/auth_failure.dart';
import 'package:cospace_customer/features/auth/model/auth_repository.dart';
import 'package:cospace_customer/features/auth/model/customer_user_model.dart';
import 'package:cospace_customer/features/auth/view_model/auth_state.dart';

/// Cubit managing authentication state for the customer.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthInitial());

  final AuthRepository _authRepository;

  /// Skips authentication temporarily for testing/development.
  // TODO: هتتشال بعد ما نخلص الهوم
  void skipLogin() {
    emit(
      const AuthAuthenticated(
        CustomerUserModel(
          uid: 'guest_user',
          fullName: 'Guest User',
          email: 'guest@cospace.com',
          phoneNumber: '',
        ),
      ),
    );
  }

  /// Register a new customer.
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.register(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      emit(AuthAuthenticated(user, isNewAccount: true));
    } on AuthFailure catch (error) {
      emit(AuthError(error.code));
    }
  }

  /// Login an existing customer.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } on AuthFailure catch (error) {
      emit(AuthError(error.code));
    }
  }

  /// Logout the current customer.
  Future<void> logout() async {
    emit(const AuthLoading());
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }

  /// Restore a saved session when the app starts.
  Future<void> checkAuthStatus() async {
    emit(const AuthChecking());
    try {
      final user = await _authRepository.restoreSession();
      if (user == null) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } on AuthFailure {
      emit(const AuthUnauthenticated());
    }
  }
}

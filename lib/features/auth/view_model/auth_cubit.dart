import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/features/auth/model/auth_repository.dart';
import 'package:cospace_customer/features/auth/view_model/auth_state.dart';

/// Cubit managing authentication state for the customer.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthInitial());

  final AuthRepository _authRepository;

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
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
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
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Logout the current customer.
  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }

  /// Check saved session on app start.
  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      // User is still logged in but we don't have the model in memory.
      // The app should navigate based on FirebaseAuth state.
      emit(const AuthInitial());
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}

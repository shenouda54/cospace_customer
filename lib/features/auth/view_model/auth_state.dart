import 'package:equatable/equatable.dart';
import 'package:cospace_customer/features/auth/model/auth_failure.dart';
import 'package:cospace_customer/features/auth/model/customer_user_model.dart';

/// Authentication states.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthChecking extends AuthState {
  const AuthChecking();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final CustomerUserModel user;
  final bool isNewAccount;

  const AuthAuthenticated(
    this.user, {
    this.isNewAccount = false,
  });

  @override
  List<Object?> get props => [user, isNewAccount];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final AuthFailureCode code;
  const AuthError(this.code);

  @override
  List<Object?> get props => [code];
}

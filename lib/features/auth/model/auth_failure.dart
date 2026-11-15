/// Reasons an authentication attempt can fail.
enum AuthFailureCode {
  invalidEmail,
  weakPassword,
  emptyName,
  invalidPhone,
  invalidCredentials,
  emailAlreadyInUse,
  userDisabled,
  tooManyRequests,
  network,
  unknown;

  static AuthFailureCode fromFirebase(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthFailureCode.invalidEmail;
      case 'weak-password':
        return AuthFailureCode.weakPassword;
      case 'email-already-in-use':
        return AuthFailureCode.emailAlreadyInUse;
      case 'user-disabled':
        return AuthFailureCode.userDisabled;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return AuthFailureCode.invalidCredentials;
      case 'network-request-failed':
      case 'unavailable':
        return AuthFailureCode.network;
      case 'too-many-requests':
        return AuthFailureCode.tooManyRequests;
      default:
        return AuthFailureCode.unknown;
    }
  }
}

/// Thrown by [AuthRepository] when credentials or Firebase reject a request.
class AuthFailure implements Exception {
  const AuthFailure(this.code);

  final AuthFailureCode code;
}

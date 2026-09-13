import 'package:firebase_auth/firebase_auth.dart';

class AuthExceptionMapper {
  /// Translates a raw exception into a user-friendly string
  static String mapException(dynamic exception) {
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'invalid-email':
          return 'The email address is not valid. Please check and try again.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'user-not-found':
          return 'We couldn\'t find an account with that email address.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password. Please try again.';
        case 'email-already-in-use':
          return 'An account already exists with this email address. Please log in instead.';
        case 'operation-not-allowed':
          return 'This sign-in method is not enabled. Please contact support.';
        case 'weak-password':
          return 'Your password is too weak. Please use a stronger password.';
        case 'network-request-failed':
          return 'A network error occurred. Please check your internet connection.';
        case 'too-many-requests':
          return 'We have blocked all requests from this device due to unusual activity. Try again later.';
        default:
          return exception.message ?? 'An unknown authentication error occurred. Please try again.';
      }
    }

    return 'An unexpected error occurred. Please try again.';
  }
}

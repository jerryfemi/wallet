import 'package:wallet/features/auth/domain/entities/user_profile.dart';

abstract class AuthRepository {
  /// Stream of the currently authenticated user's profile
  Stream<UserProfile?> get authStateChanges;

  /// Returns the current user's profile, or null if not authenticated
  UserProfile? get currentUser;

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password);

  /// Sign up with email, password, and display name
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Send a password reset email
  Future<void> sendPasswordResetEmail(String email);
}

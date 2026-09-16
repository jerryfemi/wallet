import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
}

@riverpod
Stream<User?> authState(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<void> build() async {
    // Initial state is just empty
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.signInWithEmailAndPassword(email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      print('Firebase Sign In Error: $e'); // Debugging raw error
      state = AsyncError(e, st);
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await ref.read(walletRepositoryProvider).createInitialWallet(user.uid);
      }

      state = const AsyncData(null);
    } catch (e, st) {
      debugPrint('Firebase Sign Up Error: $e'); // Debugging raw error
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

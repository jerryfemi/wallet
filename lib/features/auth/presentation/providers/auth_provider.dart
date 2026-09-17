import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wallet/features/auth/domain/repositories/auth_repository.dart';
import 'package:wallet/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';

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
    
    // 1. Grab everything we need from `ref` BEFORE the async operation starts!
    final repository = ref.read(authRepositoryProvider);
    final walletRepo = ref.read(walletRepositoryProvider);
    
    try {
      await repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 2. Use the walletRepo we grabbed earlier instead of `ref.read`
        await walletRepo.createInitialWallet(user.uid);
      }
      
      // We purposefully don't set state to AsyncData here because GoRouter 
      // instantly redirects us and disposes this controller before it finishes!
    } catch (e, st) {
      debugPrint('Firebase Sign Up Error: $e');
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

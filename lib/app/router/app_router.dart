import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:wallet/features/auth/presentation/screens/login_screen.dart';
import 'package:wallet/features/auth/presentation/screens/register_screen.dart';
import 'package:wallet/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:wallet/features/home/presentation/screens/home_screen.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/screens/markets_screen.dart';
import 'package:wallet/features/markets/presentation/screens/coin_details_screen.dart';
import 'package:wallet/features/markets/presentation/screens/about_coin_screen.dart';
import 'package:wallet/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:wallet/features/wallet/presentation/screens/receive_screen.dart';
import 'package:wallet/features/wallet/presentation/screens/send_screen.dart';
import 'package:wallet/features/transactions/presentation/screens/activity_screen.dart';
import 'package:wallet/features/profile/presentation/screens/profile_screen.dart';
import 'package:wallet/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:wallet/features/transactions/presentation/screens/transaction_detail_screen.dart';
import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';
import 'package:wallet/shared/widgets/app_shell.dart';
import 'package:wallet/app/router/routes.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(Ref ref) {
  final notifier = ref.watch(authGateProvider.notifier);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.home,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: notifier,
    routes: [
      // ── Auth ─────────────────────────────────────────────────────────────
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) =>
            ForgotPasswordScreen(initialEmail: state.extra as String? ?? ""),
      ),

      // ── Main Shell ───────────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.markets,
                builder: (context, state) => const MarketsScreen(),
                routes: [
                  GoRoute(
                    path: Routes.coinDetails,
                    builder: (context, state) {
                      final coin = state.extra as CoinEntity;
                      return CoinDetailsScreen(coin: coin);
                    },
                    routes: [
                      GoRoute(
                        path: Routes.aboutCoin,
                        builder: (context, state) {
                          final coin = state.extra as CoinEntity;
                          return AboutCoinScreen(coin: coin);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.wallet,
                builder: (context, state) => const WalletScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.activity,
                builder: (context, state) => const ActivityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Full-screen flows (outside shell, no bottom nav) ───────────────
      GoRoute(
        path: '${Routes.send}/:coinId',
        builder: (context, state) {
          final coin = state.extra as CoinEntity;
          return SendScreen(coin: coin);
        },
      ),
      GoRoute(
        path: '${Routes.receive}/:coinId',
        builder: (context, state) {
          final coin = state.extra as CoinEntity;
          return ReceiveScreen(coin: coin);
        },
      ),
      GoRoute(
        path: Routes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.transactionDetail,
        builder: (context, state) {
          final tx = state.extra as TransactionEntity?;
          return TransactionDetailScreen(
            transactionId: state.pathParameters['transactionId'] ?? '',
            transaction: tx,
          );
        },
      ),
    ],


    // ── Redirect logic ──────────────────────────────────────────────────────
    redirect: (context, state) {
      final location = state.matchedLocation;

      // If we are waiting for the very first auth state emission, stay where we are or go to a splash screen.
      // For now, we bypass the gate until Firebase is fully hooked up.
      /*
      if (notifier.authStateKnown == false) {
        return location == '/' ? null : '/';
      }
      */

      final isLoggedIn = notifier.isAuthenticated;
      final isAuthRoute =
          location == Routes.login ||
          location == Routes.register ||
          location == Routes.forgotPassword;

      // 1. Not logged in -> Redirect to login
      if (!isLoggedIn) {
        return isAuthRoute ? null : Routes.login;
      }

      // 2. Logged in and trying to access auth screens -> Redirect to home
      if (isLoggedIn && isAuthRoute) {
        return Routes.home;
      }

      return null;
    },
  );
}

// ---------------------------------------------------------------------------
// RouterNotifier
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
class AuthGate extends _$AuthGate implements ChangeNotifier {
  bool _isAuthenticated = false;
  bool _authStateKnown = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get authStateKnown => _authStateKnown;

  @override
  void build() {
    // Listen to Firebase Auth state changes
    ref.listen<AsyncValue<User?>>(authStateProvider, (_, next) {
      if (!next.isLoading) {
        _authStateKnown = true;
        _isAuthenticated = next.value != null;
        notifyListeners();
      }
    });
  }

  // ── ChangeNotifier plumbing ───────────────────────────────────────────────
  final List<VoidCallback> _listeners = [];

  @override
  void addListener(VoidCallback l) => _listeners.add(l);

  @override
  void removeListener(VoidCallback l) => _listeners.remove(l);

  @override
  bool get hasListeners => _listeners.isNotEmpty;

  @override
  void notifyListeners() {
    for (final l in List.of(_listeners)) {
      l();
    }
  }

  @override
  void dispose() {}
}

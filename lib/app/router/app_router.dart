import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/markets/presentation/screens/markets_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/transactions/presentation/screens/activity_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../shared/widgets/app_shell.dart';
import 'routes.dart';



final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
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
        builder: (context, state) => const ForgotPasswordScreen(),
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
      final isAuthRoute = location == Routes.login || 
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
});

// ---------------------------------------------------------------------------
// RouterNotifier
// ---------------------------------------------------------------------------

final routerNotifierProvider = NotifierProvider<RouterNotifier, void>(
  RouterNotifier.new,
);

class RouterNotifier extends Notifier<void> implements ChangeNotifier {
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

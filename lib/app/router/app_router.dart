import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorMarketsKey = GlobalKey<NavigatorState>(debugLabel: 'shellMarkets');
final GlobalKey<NavigatorState> _shellNavigatorWalletKey = GlobalKey<NavigatorState>(debugLabel: 'shellWallet');
final GlobalKey<NavigatorState> _shellNavigatorActivityKey = GlobalKey<NavigatorState>(debugLabel: 'shellActivity');
final GlobalKey<NavigatorState> _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.home,
  // TODO: Add auth redirect logic here
  routes: <RouteBase>[
    GoRoute(
      path: Routes.login,
      builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.register,
      builder: (BuildContext context, GoRouterState state) => const RegisterScreen(),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      builder: (BuildContext context, GoRouterState state) => const ForgotPasswordScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // Branch 0: Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.home,
              builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
            ),
          ],
        ),
        // Branch 1: Markets
        StatefulShellBranch(
          navigatorKey: _shellNavigatorMarketsKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.markets,
              builder: (BuildContext context, GoRouterState state) => const MarketsScreen(),
            ),
          ],
        ),
        // Branch 2: Wallet
        StatefulShellBranch(
          navigatorKey: _shellNavigatorWalletKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.wallet,
              builder: (BuildContext context, GoRouterState state) => const WalletScreen(),
            ),
          ],
        ),
        // Branch 3: Activity
        StatefulShellBranch(
          navigatorKey: _shellNavigatorActivityKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.activity,
              builder: (BuildContext context, GoRouterState state) => const ActivityScreen(),
            ),
          ],
        ),
        // Branch 4: Profile
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.profile,
              builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

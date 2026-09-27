import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:wallet/features/profile/presentation/providers/currency_provider.dart';
import 'package:wallet/features/profile/presentation/widgets/currency_selection_sheet.dart';
import 'package:wallet/features/profile/presentation/widgets/logout_confirmation_sheet.dart';
import 'package:wallet/features/profile/presentation/widgets/profile_menu_group.dart';
import 'package:wallet/app/theme/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/app/router/routes.dart';
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can pull real user data from auth provider if available
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Pinned App Bar (Compact, no title)
          const SliverAppBar(pinned: true),

          // 2. User Info Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user?.photoURL != null && user!.photoURL!.isNotEmpty 
                            ? user.photoURL!
                            : 'https://api.dicebear.com/7.x/micah/png?seed=${user?.uid ?? 'Trader'}&backgroundColor=transparent',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'Trader',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'trader@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Menu Options
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // First Group: Account Settings
                  ProfileMenuGroup(
                    options: [
                      MenuOption(
                        iconAsset: 'assets/icons/edit.svg',
                        title: 'Edit Profile',
                        onTap: () {
                          context.go('${Routes.profile}/${Routes.editProfile}');
                        },
                      ),
                      MenuOption(
                        iconAsset: 'assets/icons/key.svg',
                        title: 'Change Password',
                        iconColor: Colors.amber,
                        onTap: () {},
                      ),
                      MenuOption(
                        iconAsset: 'assets/icons/currency.svg',
                        title: 'Preferred Currency',
                        trailingText: ref.watch(currencyProvider).code,
                        onTap: () => CurrencySelectionSheet.show(context),
                      ),
                      MenuOption(
                        iconAsset: 'assets/icons/edit.svg', // Still waiting on a moon/theme icon, edit is placeholder
                        title: 'Dark Mode',
                        trailingWidget: Switch.adaptive(
                          value: ref.watch(themeModeProvider) == ThemeMode.dark,
                          onChanged: (value) {
                            ref.read(themeModeProvider.notifier).toggleTheme();
                          },
                          activeColor: Theme.of(context).colorScheme.primary
                              .withValues(alpha: 0.05),
                        ),
                        onTap: () =>
                            ref.read(themeModeProvider.notifier).toggleTheme(),
                      ),
                      MenuOption(
                        iconAsset: 'assets/icons/bell.svg',
                        title: 'Notifications',
                        iconColor: Colors.amber,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Second Group: Security & Support
                  ProfileMenuGroup(
                    options: [
                      MenuOption(
                        iconAsset: 'assets/icons/shield.svg',
                        title: 'Security',
                        onTap: () {},
                      ),
                      MenuOption(
                        iconAsset: 'assets/icons/help.svg',
                        title: 'Help & Support',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error
                              .withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        LogoutConfirmationSheet.show(
                          context,
                          onConfirm: () {
                            ref.read(authControllerProvider.notifier).signOut();
                          },
                        );
                      },
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // App Version
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

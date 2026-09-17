import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wallet/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            ref.read(authControllerProvider.notifier).signOut();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Log Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}

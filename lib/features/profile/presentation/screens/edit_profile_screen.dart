import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:wallet/features/profile/presentation/widgets/avatar_selection_sheet.dart';

class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AsyncLoading;
    
    // We maintain local state before saving
    final nameController = useTextEditingController(text: user?.displayName ?? '');
    
    // Extract current seed from photoURL or default to user.uid
    final initialSeed = _extractSeed(user?.photoURL) ?? (user?.uid ?? 'Trader');
    final selectedSeed = useState<String>(initialSeed);

    final currentAvatarUrl = 'https://api.dicebear.com/7.x/micah/png?seed=${selectedSeed.value}&backgroundColor=transparent';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isEmpty) return;
                
                await ref.read(authControllerProvider.notifier).updateProfile(
                  displayName: newName,
                  photoUrl: currentAvatarUrl,
                );
                
                if (context.mounted) {
                  context.pop();
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar Section
            Center(
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
                        imageUrl: currentAvatarUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final seed = await AvatarSelectionSheet.show(
                        context, 
                        currentSeed: selectedSeed.value,
                      );
                      if (seed != null) {
                        selectedSeed.value = seed;
                      }
                    },
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Change Avatar'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),

            // Form Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Display Name',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, 
                      vertical: 16,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Email Address',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: user?.email ?? ''),
                  enabled: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, 
                      vertical: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Email address cannot be changed at this time.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _extractSeed(String? url) {
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri != null && uri.queryParameters.containsKey('seed')) {
      return uri.queryParameters['seed'];
    }
    return null;
  }
}

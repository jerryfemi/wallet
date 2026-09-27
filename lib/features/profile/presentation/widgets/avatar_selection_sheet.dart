import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarSelectionSheet extends StatelessWidget {
  final String currentSeed;

  const AvatarSelectionSheet({
    super.key,
    required this.currentSeed,
  });

  static Future<String?> show(BuildContext context, {required String currentSeed}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarSelectionSheet(currentSeed: currentSeed),
    );
  }

  // A list of cool predetermined seeds for Dicebear Micah avatars
  static const List<String> avatarSeeds = [
    'Felix', 'Aneka', 'Jasper', 'Leo', 'Eden', 
    'Lily', 'Max', 'Luna', 'Oliver', 'Sam',
    'Jack', 'Mia', 'Nolan', 'Zoe', 'Caleb', 'Ava'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Text(
            'Choose Avatar',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: avatarSeeds.length,
            itemBuilder: (context, index) {
              final seed = avatarSeeds[index];
              final isSelected = seed == currentSeed;
              final url = 'https://api.dicebear.com/7.x/micah/png?seed=$seed&backgroundColor=transparent';

              return GestureDetector(
                onTap: () => Navigator.of(context).pop(seed),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: colorScheme.primary, width: 3)
                        : null,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

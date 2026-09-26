import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuOption {
  final String iconAsset;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final Color? iconColor;

  MenuOption({
    required this.iconAsset,
    required this.title,
    this.trailingText,
    required this.onTap,
    this.iconColor,
  });
}

class ProfileMenuGroup extends StatelessWidget {
  final List<MenuOption> options;

  const ProfileMenuGroup({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < options.length; i++) ...[
            _buildTile(context, options[i]),
            if (i < options.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                indent: 56,
                endIndent: 16,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, MenuOption option) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: option.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    option.iconAsset,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      option.iconColor ??
                          Theme.of(context).iconTheme.color ??
                          Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (option.trailingText != null) ...[
                Text(
                  option.trailingText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

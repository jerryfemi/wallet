import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_list_tile.dart';

/// A dedicated slide-up asset picker sheet with search.
/// Returns the selected coin ID when tapped, or null if dismissed.
class AssetPickerSheet extends HookConsumerWidget {
  const AssetPickerSheet({super.key});

  /// Shows the picker as a new modal sheet layered on top of the current sheet.
  static Future<String?> show(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push<String>(
      StupidSimpleCupertinoSheetRoute<String>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        snappingConfig:
            SheetSnappingConfig([0.85], initialSnap: 0.85),
        child: const _AssetPickerWrapper(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final searchController = useTextEditingController();
    final searchQuery = useState('');

    final marketsState = ref.watch(marketsProvider);
    final markets = marketsState.value ?? [];

    // Filter markets by search query and exclude tether
    final filteredMarkets = markets.where((coin) {
      if (coin.id == 'tether') return false;
      if (searchQuery.value.isEmpty) return true;
      final q = searchQuery.value.toLowerCase();
      return coin.name.toLowerCase().contains(q) ||
          coin.symbol.toLowerCase().contains(q);
    }).toList();

    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header: Back button + Title
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Select Asset',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: searchController,
                onChanged: (v) => searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: 'Search coins...',
                  prefixIcon: Icon(Icons.search_rounded,
                      color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: theme.textTheme.bodyLarge,
              ),
            ),

            const SizedBox(height: 12),

            // Coin list
            if (markets.isEmpty)
              const Expanded(
                  child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: filteredMarkets.length,
                  itemBuilder: (context, index) {
                    final coin = filteredMarkets[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(coin.id),
                      child: CoinListTile(coin: coin),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Wrapper to provide SafeArea at the bottom for the picker content.
class _AssetPickerWrapper extends StatelessWidget {
  const _AssetPickerWrapper();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      top: false,
      child: AssetPickerSheet(),
    );
  }
}
